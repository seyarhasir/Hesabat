import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/entities/customers_table.dart';
import 'tables/entities/debts_table.dart';
import 'tables/entities/products_table.dart';
import 'tables/entities/sales_table.dart';
import 'tables/sync/pull_cache_table.dart';
import 'tables/sync/sync_checkpoint_table.dart';
import 'tables/sync/sync_queue_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    SyncQueueTable,
    SyncCheckpointTable,
    PullCacheTable,
    ProductsTable,
    CustomersTable,
    SalesTable,
    DebtsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'hesabat_v2.sqlite');
}
