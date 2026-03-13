import 'package:drift/drift.dart';

@DataClassName('Device')
class Devices extends Table {
  TextColumn get id => text().clientDefault(() => 'local_dev_${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get shopId => text().named('shop_id')();
  TextColumn get deviceId => text().named('device_id')();
  TextColumn get platform => text()(); // android, ios
  TextColumn get appVersion => text().named('app_version').nullable()();
  DateTimeColumn get lastSyncAt => dateTime().named('last_sync_at').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').clientDefault(() => DateTime.now())();
  
  // Sync status
  TextColumn get syncStatus => text().named('sync_status').withDefault(const Constant('pending'))();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<String> get customConstraints => [
    'UNIQUE (shop_id, device_id)',
  ];
}
