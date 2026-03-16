import 'package:drift/drift.dart';

class ProductsTable extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text()();
  TextColumn get name => text()();
  RealColumn get price => real().withDefault(const Constant(0))();
  RealColumn get stockQuantity => real().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get updatedByDeviceId => text().nullable()();
  TextColumn get payload => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
