import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../domain/entities/sync_checkpoint.dart';
import '../../../domain/entities/sync_queue_item.dart';
import '../../../domain/repositories/sync_queue_repository.dart';
import '../drift/app_database.dart';

class DriftSyncQueueRepository implements SyncQueueRepository {
  final AppDatabase _db;

  const DriftSyncQueueRepository(this._db);

  @override
  Future<void> enqueue(SyncQueueItem item) async {
    await _db.into(_db.syncQueueTable).insert(
          SyncQueueTableCompanion.insert(
            opId: item.opId,
            deviceId: item.deviceId,
            entityType: item.entityType,
            entityId: item.entityId,
            operation: item.operation.name,
            payload: jsonEncode(item.payload),
            createdAt: item.createdAt,
            attemptCount: Value(item.attemptCount),
            lastError: Value(item.lastError),
            isSynced: const Value(false),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<List<SyncQueueItem>> getPending({int limit = 100}) async {
    final rows = await (_db.select(_db.syncQueueTable)
          ..where((t) => t.isSynced.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(limit))
        .get();

    return rows
        .map(
          (r) => SyncQueueItem(
            opId: r.opId,
            deviceId: r.deviceId,
            entityType: r.entityType,
            entityId: r.entityId,
            operation: _operationFromString(r.operation),
            payload: _decodePayload(r.payload),
            createdAt: r.createdAt,
            attemptCount: r.attemptCount,
            lastError: r.lastError,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> markAttempt({required String opId, required String error}) async {
    final query = _db.update(_db.syncQueueTable)..where((t) => t.opId.equals(opId));

    final current = await (_db.select(_db.syncQueueTable)
          ..where((t) => t.opId.equals(opId))
          ..limit(1))
        .getSingleOrNull();

    if (current == null) return;

    await query.write(
      SyncQueueTableCompanion(
        attemptCount: Value(current.attemptCount + 1),
        lastError: Value(error),
      ),
    );
  }

  @override
  Future<void> markSuccess({required String opId}) async {
    final query = _db.update(_db.syncQueueTable)..where((t) => t.opId.equals(opId));

    await query.write(
      const SyncQueueTableCompanion(
        isSynced: Value(true),
        lastError: Value(null),
      ),
    );
  }

  @override
  Future<SyncCheckpoint> getCheckpoint() async {
    final row = await (_db.select(_db.syncCheckpointTable)..limit(1)).getSingleOrNull();
    if (row == null) return const SyncCheckpoint();

    return SyncCheckpoint(
      lastPulledAt: row.lastPulledAt,
      lastPushedAt: row.lastPushedAt,
    );
  }

  @override
  Future<void> setCheckpoint(SyncCheckpoint checkpoint) async {
    final row = await (_db.select(_db.syncCheckpointTable)..limit(1)).getSingleOrNull();

    if (row == null) {
      await _db.into(_db.syncCheckpointTable).insert(
            SyncCheckpointTableCompanion.insert(
              id: const Value(1),
              lastPulledAt: Value(checkpoint.lastPulledAt),
              lastPushedAt: Value(checkpoint.lastPushedAt),
            ),
            mode: InsertMode.insertOrReplace,
          );
      return;
    }

    final query = _db.update(_db.syncCheckpointTable)..where((t) => t.id.equals(row.id));
    await query.write(
      SyncCheckpointTableCompanion(
        lastPulledAt: Value(checkpoint.lastPulledAt),
        lastPushedAt: Value(checkpoint.lastPushedAt),
      ),
    );
  }

  SyncOperation _operationFromString(String value) {
    switch (value) {
      case 'insert':
        return SyncOperation.insert;
      case 'update':
        return SyncOperation.update;
      case 'delete':
        return SyncOperation.delete;
      default:
        return SyncOperation.update;
    }
  }

  Map<String, dynamic> _decodePayload(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) {
        return decoded.map((k, v) => MapEntry(k.toString(), v));
      }
      return {};
    } catch (_) {
      return {};
    }
  }
}
