import 'package:drift/drift.dart';

@DataClassName('SyncQueueItem')
class SyncQueue extends Table {
  TextColumn get id => text().clientDefault(() => 'local_sync_${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get shopId => text().named('shop_id').nullable()();
  TextColumn get deviceId => text().named('device_id').nullable()();
  TextColumn get targetTable => text().named('table_name')();
  TextColumn get recordId => text().named('record_id')();
  TextColumn get operation => text()(); // INSERT, UPDATE, DELETE
  TextColumn get payload => text()(); // JSON string
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();
  BoolColumn get conflictResolved => boolean().named('conflict_resolved').withDefault(const Constant(false))();
  TextColumn get errorMessage => text().named('error_message').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}
