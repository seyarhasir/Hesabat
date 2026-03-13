import 'package:drift/drift.dart';

@DataClassName('Customer')
class Customers extends Table {
  TextColumn get id => text().clientDefault(() => 'local_cust_${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get shopId => text().named('shop_id')();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  RealColumn get totalOwed => real().named('total_owed').withDefault(const Constant(0.0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get lastInteractionAt => dateTime().named('last_interaction_at').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').clientDefault(() => DateTime.now())();
  
  // Sync status
  TextColumn get syncStatus => text().named('sync_status').withDefault(const Constant('pending'))();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();
  TextColumn get localId => text().named('local_id').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
