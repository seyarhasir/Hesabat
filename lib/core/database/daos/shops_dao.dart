import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/shops_table.dart';

part 'shops_dao.g.dart';

@DriftAccessor(tables: [Shops])
class ShopsDao extends DatabaseAccessor<AppDatabase> with _$ShopsDaoMixin {
  ShopsDao(super.db);

  Future<List<Shop>> getAllShops() => select(shops).get();

  Future<Shop?> getShopById(String id) =>
      (select(shops)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<Shop?> getShopByOwnerId(String ownerId) =>
      (select(shops)..where((s) => s.ownerId.equals(ownerId))).getSingleOrNull();

  Future<int> insertShop(ShopsCompanion shop) => into(shops).insert(shop);

  Future<bool> updateShop(ShopsCompanion shop) => update(shops).replace(shop);

  Future<int> deleteShop(String id) =>
      (delete(shops)..where((s) => s.id.equals(id))).go();

  Stream<List<Shop>> watchAllShops() => select(shops).watch();

  Stream<Shop?> watchShopById(String id) =>
      (select(shops)..where((s) => s.id.equals(id))).watchSingleOrNull();

  Future<List<Shop>> getShopsBySyncStatus(String status) =>
      (select(shops)..where((s) => s.syncStatus.equals(status))).get();

  Future<int> updateSyncStatus(String id, String status) =>
      (update(shops)..where((s) => s.id.equals(id))).write(
        ShopsCompanion(syncStatus: Value(status)),
      );

  Future<int> markAsSynced(String id) =>
      (update(shops)..where((s) => s.id.equals(id))).write(
        ShopsCompanion(
          syncStatus: const Value('synced'),
          syncedAt: Value(DateTime.now()),
        ),
      );
}
