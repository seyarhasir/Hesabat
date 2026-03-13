import 'package:drift/drift.dart';

@DataClassName('Category')
class Categories extends Table {
  TextColumn get id => text().clientDefault(() => 'local_cat_${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get shopId => text().named('shop_id')();
  TextColumn get nameDari => text().named('name_dari')();
  TextColumn get namePashto => text().named('name_pashto').nullable()();
  TextColumn get nameEn => text().named('name_en').nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').clientDefault(() => DateTime.now())();
  
  // Sync status
  TextColumn get syncStatus => text().named('sync_status').withDefault(const Constant('pending'))();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
