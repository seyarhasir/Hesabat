import 'package:drift/drift.dart';

import '../app_database.dart';

class LocalEntityQueries {
  final AppDatabase _db;

  const LocalEntityQueries(this._db);

  Stream<List<ProductsTableData>> watchProducts(String shopId) {
    return (_db.select(_db.productsTable)
          ..where((t) => t.shopId.equals(shopId))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Stream<List<CustomersTableData>> watchCustomers(String shopId) {
    return (_db.select(_db.customersTable)
          ..where((t) => t.shopId.equals(shopId))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Stream<List<SalesTableData>> watchSales(String shopId) {
    return (_db.select(_db.salesTable)
          ..where((t) => t.shopId.equals(shopId))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  Stream<List<DebtsTableData>> watchDebts(String shopId) {
    return (_db.select(_db.debtsTable)
          ..where((t) => t.shopId.equals(shopId))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }
}
