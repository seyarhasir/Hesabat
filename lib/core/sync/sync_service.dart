import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import '../network/connectivity_service.dart';

class SyncProgress {
  final int processed;
  final int total;

  const SyncProgress({required this.processed, required this.total});
}

enum ConflictResolutionChoice { useLocal, useServer, merge }

enum ConflictEntityType { sales, stock, debt, customer, productPrice, generic }

class SyncConflictDetails {
  final SyncQueueItem queueItem;
  final Map<String, dynamic> localPayload;
  final Map<String, dynamic>? serverPayload;
  final ConflictEntityType type;

  const SyncConflictDetails({
    required this.queueItem,
    required this.localPayload,
    required this.serverPayload,
    required this.type,
  });
}

class SyncService {
  SyncService._();
  static final SyncService instance = SyncService._();

  AppDatabase? _db;
  SupabaseClient get _supabase => Supabase.instance.client;

  Future<void> initialize(AppDatabase db) async {
    _db = db;
  }

  Future<void> enqueueOperation({
    required String shopId,
    required String targetTable,
    required String recordId,
    required String operation,
    required Map<String, dynamic> payload,
  }) async {
    final db = _db;
    if (db == null) return;

    await db.into(db.syncQueue).insert(
          SyncQueueCompanion.insert(
            shopId: Value(shopId),
            targetTable: targetTable,
            recordId: recordId,
            operation: operation.toUpperCase(),
            payload: jsonEncode(payload),
          ),
        );
  }

  Future<int> pendingCount() async {
    final db = _db;
    if (db == null) return 0;

    final pending = await (db.select(db.syncQueue)..where((t) => t.syncedAt.isNull())).get();
    return pending.length;
  }

  Future<int> conflictCount() async {
    final db = _db;
    if (db == null) return 0;

    final pending = await (db.select(db.syncQueue)..where((t) => t.syncedAt.isNull())).get();
    return pending.where((e) => _isConflictMessage(e.errorMessage)).length;
  }

  Future<List<SyncQueueItem>> getUnresolvedConflicts({int limit = 100}) async {
    final db = _db;
    if (db == null) return const [];

    final pending = await (db.select(db.syncQueue)
          ..where((t) => t.syncedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(limit))
        .get();

    return pending.where((e) => _isConflictMessage(e.errorMessage)).toList();
  }

  Future<List<SyncConflictDetails>> getUnresolvedConflictDetails({int limit = 100}) async {
    final conflicts = await getUnresolvedConflicts(limit: limit);
    final out = <SyncConflictDetails>[];

    for (final item in conflicts) {
      final local = _parsePayload(item.payload);
      final type = _entityTypeFor(item.targetTable, local);
      final server = await _fetchServerRecord(item.targetTable, item.recordId);

      out.add(
        SyncConflictDetails(
          queueItem: item,
          localPayload: local,
          serverPayload: server,
          type: type,
        ),
      );
    }

    return out;
  }

  Future<int> syncPending({
    int batchSize = 500,
    void Function(SyncProgress progress)? onProgress,
  }) async {
    final db = _db;
    if (db == null) return 0;

    if (!ConnectivityService.instance.isOnline) {
      throw Exception('Offline');
    }

    final items = await (db.select(db.syncQueue)
          ..where((t) => t.syncedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(batchSize))
        .get();

    final syncableItems = items.where((e) => !_isConflictMessage(e.errorMessage)).toList();

    if (syncableItems.isEmpty) {
      onProgress?.call(const SyncProgress(processed: 0, total: 0));
      return 0;
    }

    var processed = 0;
    for (final item in syncableItems) {
      try {
        await _push(item);
        await (db.update(db.syncQueue)..where((t) => t.id.equals(item.id))).write(
          SyncQueueCompanion(
            syncedAt: Value(DateTime.now()),
            errorMessage: const Value(null),
            conflictResolved: const Value(true),
          ),
        );
      } catch (e) {
        final message = e.toString();
        final isConflict = _isConflictMessage(message);
        await (db.update(db.syncQueue)..where((t) => t.id.equals(item.id))).write(
          SyncQueueCompanion(
            errorMessage: Value(isConflict ? 'CONFLICT: $message' : message),
            conflictResolved: Value(!isConflict),
          ),
        );
      }

      processed++;
      onProgress?.call(SyncProgress(processed: processed, total: syncableItems.length));
    }

    return processed;
  }

  Future<void> resolveConflict({
    required String queueId,
    required ConflictResolutionChoice choice,
  }) async {
    final db = _db;
    if (db == null) return;

    final item = await ((db.select(db.syncQueue)..where((t) => t.id.equals(queueId))).getSingleOrNull());
    if (item == null) return;

    final local = _parsePayload(item.payload);
    final type = _entityTypeFor(item.targetTable, local);
    final server = await _fetchServerRecord(item.targetTable, item.recordId);

    if (choice == ConflictResolutionChoice.useServer || type == ConflictEntityType.debt) {
      await (db.update(db.syncQueue)..where((t) => t.id.equals(queueId))).write(
        SyncQueueCompanion(
          syncedAt: Value(DateTime.now()),
          conflictResolved: const Value(true),
          errorMessage: const Value(null),
        ),
      );
      return;
    }

    if (choice == ConflictResolutionChoice.merge) {
      final merged = _mergeByType(type: type, local: local, server: server);
      await _supabase.from(item.targetTable).upsert(merged);
      await (db.update(db.syncQueue)..where((t) => t.id.equals(queueId))).write(
        SyncQueueCompanion(
          syncedAt: Value(DateTime.now()),
          conflictResolved: const Value(true),
          errorMessage: const Value(null),
          payload: Value(jsonEncode(merged)),
        ),
      );
      return;
    }

    try {
      await _push(item);
      await (db.update(db.syncQueue)..where((t) => t.id.equals(queueId))).write(
        SyncQueueCompanion(
          syncedAt: Value(DateTime.now()),
          conflictResolved: const Value(true),
          errorMessage: const Value(null),
        ),
      );
    } catch (e) {
      await (db.update(db.syncQueue)..where((t) => t.id.equals(queueId))).write(
        SyncQueueCompanion(
          conflictResolved: const Value(false),
          errorMessage: Value('CONFLICT: ${e.toString()}'),
        ),
      );
      rethrow;
    }
  }

  bool _isConflictMessage(String? message) {
    if (message == null || message.trim().isEmpty) return false;
    final m = message.toLowerCase();
    return m.contains('conflict') ||
        m.contains('duplicate key') ||
        m.contains('violates unique constraint') ||
        m.contains('409');
  }

  Map<String, dynamic> _parsePayload(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return _asStringDynamicMap(decoded);
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  ConflictEntityType _entityTypeFor(String table, Map<String, dynamic> local) {
    final t = table.toLowerCase();
    if (t == 'sales' || t == 'sale_items') return ConflictEntityType.sales;
    if (t == 'inventory_adjustments' || t == 'products_stock') return ConflictEntityType.stock;
    if (t == 'debts' || t == 'debt_payments') return ConflictEntityType.debt;
    if (t == 'customers') return ConflictEntityType.customer;
    if (t == 'products' && local.containsKey('sale_price')) return ConflictEntityType.productPrice;
    return ConflictEntityType.generic;
  }

  Future<Map<String, dynamic>?> _fetchServerRecord(String table, String recordId) async {
    try {
      final res = await _supabase.from(table).select().eq('id', recordId).maybeSingle();
      final mapped = _asStringDynamicMap(res);
      return mapped.isEmpty ? null : mapped;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _asStringDynamicMap(Object? value) {
    if (value == null) return <String, dynamic>{};
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      final out = <String, dynamic>{};
      value.forEach((key, v) {
        out[key.toString()] = v;
      });
      return out;
    }
    return <String, dynamic>{};
  }

  Map<String, dynamic> _mergeByType({
    required ConflictEntityType type,
    required Map<String, dynamic> local,
    required Map<String, dynamic>? server,
  }) {
    switch (type) {
      case ConflictEntityType.sales:
        return {...?server, ...local};
      case ConflictEntityType.stock:
        final serverAdj = (server?['quantity'] as num?)?.toDouble() ?? 0;
        final localAdj = (local['quantity'] as num?)?.toDouble() ?? 0;
        return {
          ...?server,
          ...local,
          'quantity': serverAdj + localAdj,
        };
      case ConflictEntityType.debt:
        return Map<String, dynamic>.from(server ?? local);
      case ConflictEntityType.customer:
        final localUpdated = DateTime.tryParse(local['updated_at']?.toString() ?? '');
        final serverUpdated = DateTime.tryParse(server?['updated_at']?.toString() ?? '');
        if (serverUpdated != null && (localUpdated == null || serverUpdated.isAfter(localUpdated))) {
          return Map<String, dynamic>.from(server ?? local);
        }
        return {...?server, ...local};
      case ConflictEntityType.productPrice:
        return {...?server, ...local};
      case ConflictEntityType.generic:
        return {...?server, ...local};
    }
  }

  Future<void> _push(SyncQueueItem item) async {
    final payload = jsonDecode(item.payload);
    if (payload is! Map) throw Exception('Invalid payload');

    final op = item.operation.toUpperCase();
    switch (op) {
      case 'INSERT':
      case 'UPDATE':
        await _supabase.from(item.targetTable).upsert(Map<String, dynamic>.from(payload));
        break;
      case 'DELETE':
        await _supabase.from(item.targetTable).delete().eq('id', item.recordId);
        break;
      default:
        throw Exception('Unsupported operation: $op');
    }
  }
}
