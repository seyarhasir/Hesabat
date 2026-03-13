import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/customers_table.dart';

part 'customers_dao.g.dart';

@DriftAccessor(tables: [Customers])
class CustomersDao extends DatabaseAccessor<AppDatabase> with _$CustomersDaoMixin {
  CustomersDao(super.db);

  Future<List<Customer>> getAllCustomers() => select(customers).get();

  Future<List<Customer>> getCustomersByShopId(String shopId) =>
      (select(customers)..where((c) => c.shopId.equals(shopId))).get();

  Future<Customer?> getCustomerById(String id) =>
      (select(customers)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<int> insertCustomer(CustomersCompanion customer) =>
      into(customers).insert(customer);

  Future<bool> updateCustomer(CustomersCompanion customer) =>
      update(customers).replace(customer);

  Future<int> deleteCustomer(String id) =>
      (delete(customers)..where((c) => c.id.equals(id))).go();

  Stream<List<Customer>> watchCustomersByShopId(String shopId) =>
      (select(customers)..where((c) => c.shopId.equals(shopId))).watch();

  Future<List<Customer>> searchCustomers(String query, String shopId) {
    final likeQuery = '%$query%';
    return (select(customers)
          ..where((c) =>
              c.shopId.equals(shopId) &
              (c.name.like(likeQuery) | c.phone.like(likeQuery))))
        .get();
  }

  Future<List<Customer>> getCustomersWithDebt(String shopId) =>
      (select(customers)
        ..where((c) => c.shopId.equals(shopId) & c.totalOwed.isBiggerThanValue(0))
        ..orderBy([(c) => OrderingTerm.desc(c.totalOwed)]))
          .get();

  Future<int> updateTotalOwed(String customerId, double newTotal) =>
      (update(customers)..where((c) => c.id.equals(customerId))).write(
        CustomersCompanion(
          totalOwed: Value(newTotal),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<int> updateLastInteraction(String customerId) =>
      (update(customers)..where((c) => c.id.equals(customerId))).write(
        CustomersCompanion(
          lastInteractionAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<int> updateSyncStatus(String id, String status) =>
      (update(customers)..where((c) => c.id.equals(id))).write(
        CustomersCompanion(syncStatus: Value(status)),
      );

  Future<int> markAsSynced(String id) =>
      (update(customers)..where((c) => c.id.equals(id))).write(
        CustomersCompanion(
          syncStatus: const Value('synced'),
          syncedAt: Value(DateTime.now()),
        ),
      );
}
