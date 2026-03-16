import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/storage/storage_providers.dart';
import '../../data/local/drift/app_database.dart';
import '../../data/local/drift/app_database_provider.dart';
import '../../domain/entities/sync_queue_item.dart';
import '../../domain/usecases/sync_usecase_providers.dart';

class CustomerWriteActions {
  final Ref _ref;

  const CustomerWriteActions(this._ref);

  Future<bool> addOrUpdateCustomer({
    required String name,
    String? phone,
    required double totalOwed,
    String? customerId,
  }) async {
    final db = _ref.read(appDatabaseProvider);
    final localKv = _ref.read(localKvStoreProvider);
    final enqueue = _ref.read(enqueueSyncOperationProvider);

    final shopId = await localKv.readString('active_shop_id');
    final deviceId = await localKv.readString('active_device_id');
    if (shopId == null || shopId.isEmpty || deviceId == null || deviceId.isEmpty) {
      return false;
    }

    final id = customerId ?? const Uuid().v4();
    final existing = await (db.select(db.customersTable)
          ..where((t) => t.id.equals(id))
          ..limit(1))
        .getSingleOrNull();

    final now = DateTime.now().toUtc();

    await db.into(db.customersTable).insertOnConflictUpdate(
          CustomersTableCompanion.insert(
            id: id,
            shopId: shopId,
            name: name,
            phone: Value(phone),
            totalOwed: Value(totalOwed),
            updatedAt: Value(now),
            updatedByDeviceId: Value(deviceId),
            payload: '{}',
          ),
        );

    final payload = <String, dynamic>{
      'id': id,
      'shop_id': shopId,
      'name': name,
      'phone': phone,
      'total_owed': totalOwed,
      'updated_at': now.toIso8601String(),
      'updated_by_device_id': deviceId,
    };

    await enqueue(
      deviceId: deviceId,
      entityType: 'customers',
      entityId: id,
      operation: existing == null ? SyncOperation.insert : SyncOperation.update,
      payload: payload,
    );

    return true;
  }

  Future<bool> deleteCustomer({required String customerId}) async {
    final db = _ref.read(appDatabaseProvider);
    final localKv = _ref.read(localKvStoreProvider);
    final enqueue = _ref.read(enqueueSyncOperationProvider);

    final shopId = await localKv.readString('active_shop_id');
    final deviceId = await localKv.readString('active_device_id');
    if (shopId == null || shopId.isEmpty || deviceId == null || deviceId.isEmpty) {
      return false;
    }

    await (db.delete(db.customersTable)..where((t) => t.id.equals(customerId))).go();

    await enqueue(
      deviceId: deviceId,
      entityType: 'customers',
      entityId: customerId,
      operation: SyncOperation.delete,
      payload: {
        'id': customerId,
        'shop_id': shopId,
      },
    );

    return true;
  }
}

final customerWriteActionsProvider = Provider<CustomerWriteActions>((ref) {
  return CustomerWriteActions(ref);
});
