import 'package:drift/drift.dart';

@DataClassName('InventoryAdjustment')
class InventoryAdjustments extends Table {
  TextColumn get id => text().clientDefault(() => 'local_adj_${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get shopId => text().named('shop_id')();
  TextColumn get productId => text().named('product_id')();
  RealColumn get quantityBefore => real().named('quantity_before')();
  RealColumn get quantityAfter => real().named('quantity_after')();
  RealColumn get quantityChange => real().named('quantity_change')();
  TextColumn get reason => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get adjustedAt => dateTime().named('adjusted_at').clientDefault(() => DateTime.now())();
  
  // Sync status
  TextColumn get syncStatus => text().named('sync_status').withDefault(const Constant('pending'))();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
