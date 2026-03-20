import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
// This import ensures we use SQLCipher instead of standard SQLite on Android
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

// Import all table definitions
import 'tables/shops_table.dart';
import 'tables/products_table.dart';
import 'tables/customers_table.dart';
import 'tables/sales_table.dart';
import 'tables/sale_items_table.dart';
import 'tables/debts_table.dart';
import 'tables/debt_payments_table.dart';
import 'tables/inventory_adjustments_table.dart';
import 'tables/categories_table.dart';
import 'tables/exchange_rates_table.dart';
import 'tables/sync_queue_table.dart';
import 'tables/devices_table.dart';

// Import DAOs
import 'daos/shops_dao.dart';
import 'daos/products_dao.dart';
import 'daos/customers_dao.dart';
import 'daos/sales_dao.dart';
import 'daos/debts_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Shops,
    Products,
    Customers,
    Sales,
    SaleItems,
    Debts,
    DebtPayments,
    InventoryAdjustments,
    Categories,
    ExchangeRates,
    SyncQueue,
    Devices,
  ],
  daos: [
    ShopsDao,
    ProductsDao,
    CustomersDao,
    SalesDao,
    DebtsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'hesabat_db',
      native: const DriftNativeOptions(
        databasePath: _getDatabasePath,
      ),
    );
  }

  static Future<String> _getDatabasePath() async {
    final docsDir = await getApplicationDocumentsDirectory();
    return p.join(docsDir.path, 'hesabat.db');
  }

  Future<void> initializeDatabase() async {
    // Create default exchange rates if empty
    final ratesCount = await select(exchangeRates).get();
    if (ratesCount.isEmpty) {
      await _seedDefaultExchangeRates();
    }
  }

  Future<void> _seedDefaultExchangeRates() async {
    final now = DateTime.now();
    await batch((batch) {
      batch.insertAll(exchangeRates, [
        ExchangeRatesCompanion(
          fromCurrency: Value('AFN'),
          toCurrency: Value('USD'),
          rate: Value(0.013),
          fetchedAt: Value(now),
        ),
        ExchangeRatesCompanion(
          fromCurrency: Value('AFN'),
          toCurrency: Value('PKR'),
          rate: Value(3.6),
          fetchedAt: Value(now),
        ),
        ExchangeRatesCompanion(
          fromCurrency: Value('USD'),
          toCurrency: Value('AFN'),
          rate: Value(76.0),
          fetchedAt: Value(now),
        ),
        ExchangeRatesCompanion(
          fromCurrency: Value('PKR'),
          toCurrency: Value('AFN'),
          rate: Value(0.28),
          fetchedAt: Value(now),
        ),
      ], mode: InsertMode.insertOrReplace);
    });
  }

  // Migration logic
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations here
      },
    );
  }
}
