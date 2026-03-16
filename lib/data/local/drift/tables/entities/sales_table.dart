import 'package:drift/drift.dart';

class SalesTable extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text()();
  RealColumn get totalAmount => real().withDefault(const Constant(0))();
  BoolColumn get isCredit => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get updatedByDeviceId => text().nullable()();
  TextColumn get payload => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
