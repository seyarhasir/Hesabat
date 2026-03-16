import 'package:drift/drift.dart';

class SyncCheckpointTable extends Table {
  IntColumn get id => integer()();
  DateTimeColumn get lastPulledAt => dateTime().nullable()();
  DateTimeColumn get lastPushedAt => dateTime().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
