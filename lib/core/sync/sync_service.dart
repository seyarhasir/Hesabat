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

  Future<int> pullFromCloud() async {
    final db = _db;
    if (db == null) return 0;

    final user = _supabase.auth.currentUser;
    if (user == null) return 0;

    final shopRow = await _supabase
        .from('shops')
        .select()
        .eq('owner_id', user.id)
        .order('updated_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (shopRow == null) return 0;

    final shopId = shopRow['id']?.toString();
    if (shopId == null || shopId.isEmpty) return 0;

    final now = DateTime.now();

    await db.into(db.shops).insertOnConflictUpdate(
          ShopsCompanion.insert(
            id: Value(shopId),
            ownerId: user.id,
            name: (shopRow['name'] ?? 'My Shop').toString(),
            nameDari: Value(_strOrNull(shopRow['name_dari'])),
            phone: Value(_strOrNull(shopRow['phone'])),
            city: Value((shopRow['city'] ?? 'Kabul').toString()),
            district: Value(_strOrNull(shopRow['district'])),
            shopType: Value((shopRow['shop_type'] ?? 'general').toString()),
            currencyPref: Value((shopRow['currency_pref'] ?? 'AFN').toString()),
            languagePref: Value((shopRow['language_pref'] ?? 'fa').toString()),
            subscriptionStatus: Value((shopRow['subscription_status'] ?? 'trial').toString()),
            trialEndsAt: Value(_dateOrNow(shopRow['trial_ends_at'], now.add(const Duration(days: 30)))),
            subscriptionEndsAt: Value(_dateOrNull(shopRow['subscription_ends_at'])),
            createdAt: Value(_dateOrNow(shopRow['created_at'], now)),
            updatedAt: Value(_dateOrNow(shopRow['updated_at'], now)),
            syncStatus: const Value('synced'),
            syncedAt: Value(now),
          ),
        );

    final products = await _supabase.from('products').select().eq('shop_id', shopId);
    for (final r in products) {
      final row = Map<String, dynamic>.from(r as Map);
      await db.into(db.products).insertOnConflictUpdate(
            ProductsCompanion.insert(
              id: Value((row['id'] ?? '').toString()),
              shopId: shopId,
              nameDari: (row['name_dari'] ?? row['name'] ?? '').toString().isEmpty
                  ? 'Unnamed product'
                  : (row['name_dari'] ?? row['name']).toString(),
              namePashto: Value(_strOrNull(row['name_pashto'])),
              nameEn: Value(_strOrNull(row['name_en'])),
              barcode: Value(_strOrNull(row['barcode'])),
              price: Value(_numOrZero(row['price'])),
              costPrice: Value(_numOrNull(row['cost_price'])),
              stockQuantity: Value(_numOrZero(row['stock_quantity'])),
              minStockAlert: Value(_numOrDefault(row['min_stock_alert'], 5)),
              unit: Value((row['unit'] ?? 'piece').toString()),
              categoryId: Value(_strOrNull(row['category_id'])),
              imageUrl: Value(_strOrNull(row['image_url'])),
              expiryDate: Value(_dateOrNull(row['expiry_date'])),
              prescriptionRequired: Value((row['prescription_required'] ?? false) == true),
              dosage: Value(_strOrNull(row['dosage'])),
              manufacturer: Value(_strOrNull(row['manufacturer'])),
              color: Value(_strOrNull(row['color'])),
              sizeVariant: Value(_strOrNull(row['size_variant'])),
              imei: Value(_strOrNull(row['imei'])),
              serialNumber: Value(_strOrNull(row['serial_number'])),
              weightGrams: Value(_numOrNull(row['weight_grams'])),
              isActive: Value((row['is_active'] ?? true) == true),
              createdAt: Value(_dateOrNow(row['created_at'], now)),
              updatedAt: Value(_dateOrNow(row['updated_at'], now)),
              syncStatus: const Value('synced'),
              syncedAt: Value(now),
              localId: Value(_strOrNull(row['local_id'])),
            ),
          );
    }

    final customers = await _supabase.from('customers').select().eq('shop_id', shopId);
    for (final r in customers) {
      final row = Map<String, dynamic>.from(r as Map);
      await db.into(db.customers).insertOnConflictUpdate(
            CustomersCompanion.insert(
              id: Value((row['id'] ?? '').toString()),
              shopId: shopId,
              name: (row['name'] ?? '').toString().isEmpty ? 'Unknown customer' : row['name'].toString(),
              phone: Value(_strOrNull(row['phone'])),
              totalOwed: Value(_numOrZero(row['total_owed'])),
              notes: Value(_strOrNull(row['notes'])),
              lastInteractionAt: Value(_dateOrNull(row['last_interaction_at'])),
              createdAt: Value(_dateOrNow(row['created_at'], now)),
              updatedAt: Value(_dateOrNow(row['updated_at'], now)),
              syncStatus: const Value('synced'),
              syncedAt: Value(now),
              localId: Value(_strOrNull(row['local_id'])),
            ),
          );
    }

    final sales = await _supabase.from('sales').select().eq('shop_id', shopId);
    final saleIds = <String>[];
    for (final r in sales) {
      final row = Map<String, dynamic>.from(r as Map);
      final saleId = (row['id'] ?? '').toString();
      if (saleId.isEmpty) continue;
      saleIds.add(saleId);

      await db.into(db.sales).insertOnConflictUpdate(
            SalesCompanion.insert(
              id: Value(saleId),
              shopId: shopId,
              customerId: Value(_strOrNull(row['customer_id'])),
              totalAmount: _numOrZero(row['total_amount']),
              totalAfn: _numOrDefault(row['total_afn'], _numOrZero(row['total_amount'])),
              discount: Value(_numOrDefault(row['discount'], 0)),
              paymentMethod: Value((row['payment_method'] ?? 'cash').toString()),
              currency: Value((row['currency'] ?? 'AFN').toString()),
              exchangeRate: Value(_numOrDefault(row['exchange_rate'], 1)),
              isCredit: Value((row['is_credit'] ?? false) == true),
              note: Value(_strOrNull(row['note'])),
              createdOffline: Value((row['created_offline'] ?? false) == true),
              localId: Value(_strOrNull(row['local_id'])),
              syncedAt: Value(_dateOrNull(row['synced_at']) ?? now),
              createdAt: Value(_dateOrNow(row['created_at'], now)),
              updatedAt: Value(_dateOrNow(row['updated_at'], now)),
              syncStatus: const Value('synced'),
            ),
          );
    }

    if (saleIds.isNotEmpty) {
      final saleItems = await _supabase.from('sale_items').select().inFilter('sale_id', saleIds);
      for (final r in saleItems) {
        final row = Map<String, dynamic>.from(r as Map);
        await db.into(db.saleItems).insertOnConflictUpdate(
              SaleItemsCompanion.insert(
                id: Value((row['id'] ?? '').toString()),
                saleId: (row['sale_id'] ?? '').toString(),
                productId: Value(_strOrNull(row['product_id'])),
                productNameSnapshot: (row['product_name_snapshot'] ?? '').toString().isEmpty
                    ? 'Unknown item'
                    : row['product_name_snapshot'].toString(),
                quantity: _numOrZero(row['quantity']),
                unitPrice: _numOrZero(row['unit_price']),
                subtotal: _numOrZero(row['subtotal']),
                createdAt: Value(_dateOrNow(row['created_at'], now)),
                syncStatus: const Value('synced'),
                syncedAt: Value(now),
              ),
            );
      }
    }

    final debts = await _supabase.from('debts').select().eq('shop_id', shopId);
    for (final r in debts) {
      final row = Map<String, dynamic>.from(r as Map);
      await db.into(db.debts).insertOnConflictUpdate(
            DebtsCompanion.insert(
              id: Value((row['id'] ?? '').toString()),
              shopId: shopId,
              customerId: (row['customer_id'] ?? '').toString(),
              saleId: Value(_strOrNull(row['sale_id'])),
              amountOriginal: _numOrZero(row['amount_original']),
              amountPaid: Value(_numOrDefault(row['amount_paid'], 0)),
              amountRemaining: Value(_numOrDefault(
                row['amount_remaining'],
                _numOrZero(row['amount_original']) - _numOrDefault(row['amount_paid'], 0),
              )),
              status: Value((row['status'] ?? 'open').toString()),
              dueDate: Value(_dateOrNull(row['due_date'])),
              lastReminderSentAt: Value(_dateOrNull(row['last_reminder_sent_at'])),
              notes: Value(_strOrNull(row['notes'])),
              createdAt: Value(_dateOrNow(row['created_at'], now)),
              updatedAt: Value(_dateOrNow(row['updated_at'], now)),
              syncStatus: const Value('synced'),
              syncedAt: Value(now),
            ),
          );
    }

    final debtPayments = await _supabase.from('debt_payments').select().eq('shop_id', shopId);
    for (final r in debtPayments) {
      final row = Map<String, dynamic>.from(r as Map);
      await db.into(db.debtPayments).insertOnConflictUpdate(
            DebtPaymentsCompanion.insert(
              id: Value((row['id'] ?? '').toString()),
              debtId: (row['debt_id'] ?? '').toString(),
              shopId: shopId,
              amount: _numOrZero(row['amount']),
              paymentMethod: Value((row['payment_method'] ?? 'cash').toString()),
              currency: Value((row['currency'] ?? 'AFN').toString()),
              notes: Value(_strOrNull(row['notes'])),
              createdAt: Value(_dateOrNow(row['created_at'], now)),
              syncStatus: const Value('synced'),
              syncedAt: Value(now),
            ),
          );
    }

    return products.length + customers.length + sales.length + debts.length + debtPayments.length;
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

  String? _strOrNull(Object? value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }

  DateTime? _dateOrNull(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  DateTime _dateOrNow(Object? value, DateTime fallback) {
    return _dateOrNull(value) ?? fallback;
  }

  double _numOrZero(Object? value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  double _numOrDefault(Object? value, double fallback) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? fallback;
  }

  double? _numOrNull(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
