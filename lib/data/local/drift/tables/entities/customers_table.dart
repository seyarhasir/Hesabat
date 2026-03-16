import 'package:drift/drift.dart';

class CustomersTable extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  RealColumn get totalOwed => real().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get updatedByDeviceId => text().nullable()();
  TextColumn get payload => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
