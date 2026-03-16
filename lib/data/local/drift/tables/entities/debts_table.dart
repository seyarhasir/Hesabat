import 'package:drift/drift.dart';

class DebtsTable extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text()();
  RealColumn get amountOriginal => real().withDefault(const Constant(0))();
  RealColumn get amountPaid => real().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('open'))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get updatedByDeviceId => text().nullable()();
  TextColumn get payload => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
