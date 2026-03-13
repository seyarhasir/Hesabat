import 'package:drift/drift.dart';

@DataClassName('SaleItem')
class SaleItems extends Table {
  TextColumn get id => text().clientDefault(() => 'local_item_${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get saleId => text().named('sale_id')();
  TextColumn get productId => text().named('product_id').nullable()();
  TextColumn get productNameSnapshot => text().named('product_name_snapshot')();
  RealColumn get quantity => real()();
  RealColumn get unitPrice => real().named('unit_price')();
  RealColumn get subtotal => real()();
  DateTimeColumn get createdAt => dateTime().named('created_at').clientDefault(() => DateTime.now())();
  
  // Sync status
  TextColumn get syncStatus => text().named('sync_status').withDefault(const Constant('pending'))();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
