import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/storage/storage_providers.dart';
import '../../data/local/drift/app_database.dart';
import '../../data/local/drift/app_database_provider.dart';
import '../../domain/entities/sync_queue_item.dart';
import '../../domain/usecases/sync_usecase_providers.dart';

class ProductWriteActions {
  final Ref _ref;

  const ProductWriteActions(this._ref);

  Future<bool> addOrUpdateProduct({
    required String name,
    required double price,
    required double stockQuantity,
    String? productId,
  }) async {
    final db = _ref.read(appDatabaseProvider);
    final localKv = _ref.read(localKvStoreProvider);
    final enqueue = _ref.read(enqueueSyncOperationProvider);

    final shopId = await localKv.readString('active_shop_id');
    final deviceId = await localKv.readString('active_device_id');
    if (shopId == null || shopId.isEmpty || deviceId == null || deviceId.isEmpty) {
      return false;
    }

    final id = productId ?? const Uuid().v4();
    final existing = await (db.select(db.productsTable)
          ..where((t) => t.id.equals(id))
          ..limit(1))
        .getSingleOrNull();

    final now = DateTime.now().toUtc();

    await db.into(db.productsTable).insertOnConflictUpdate(
          ProductsTableCompanion.insert(
            id: id,
            shopId: shopId,
            name: name,
            price: Value(price),
            stockQuantity: Value(stockQuantity),
            updatedAt: Value(now),
            updatedByDeviceId: Value(deviceId),
            payload: '{}',
          ),
        );

    final payload = <String, dynamic>{
      'id': id,
      'shop_id': shopId,
      'name': name,
      'price': price,
      'stock_quantity': stockQuantity,
      'updated_at': now.toIso8601String(),
      'updated_by_device_id': deviceId,
    };

    await enqueue(
      deviceId: deviceId,
      entityType: 'products',
      entityId: id,
      operation: existing == null ? SyncOperation.insert : SyncOperation.update,
      payload: payload,
    );

    return true;
  }

  Future<bool> deleteProduct({required String productId}) async {
    final db = _ref.read(appDatabaseProvider);
    final localKv = _ref.read(localKvStoreProvider);
    final enqueue = _ref.read(enqueueSyncOperationProvider);

    final shopId = await localKv.readString('active_shop_id');
    final deviceId = await localKv.readString('active_device_id');
    if (shopId == null || shopId.isEmpty || deviceId == null || deviceId.isEmpty) {
      return false;
    }

    await (db.delete(db.productsTable)..where((t) => t.id.equals(productId))).go();

    await enqueue(
      deviceId: deviceId,
      entityType: 'products',
      entityId: productId,
      operation: SyncOperation.delete,
      payload: {
        'id': productId,
        'shop_id': shopId,
      },
    );

    return true;
  }
}

final productWriteActionsProvider = Provider<ProductWriteActions>((ref) {
  return ProductWriteActions(ref);
});
