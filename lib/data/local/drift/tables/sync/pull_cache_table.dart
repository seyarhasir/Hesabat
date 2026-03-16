import 'package:drift/drift.dart';

class PullCacheTable extends Table {
  TextColumn get entityTable => text()();
  TextColumn get rowId => text()();
  TextColumn get payload => text()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get updatedByDeviceId => text().nullable()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {entityTable, rowId};
}
