import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sales_table.dart';
import '../tables/sale_items_table.dart';

part 'sales_dao.g.dart';

@DriftAccessor(tables: [Sales, SaleItems])
class SalesDao extends DatabaseAccessor<AppDatabase> with _$SalesDaoMixin {
  SalesDao(super.db);

  Future<List<Sale>> getAllSales() => select(sales).get();

  Future<List<Sale>> getSalesByShopId(String shopId) =>
      (select(sales)..where((s) => s.shopId.equals(shopId))).get();

  Future<Sale?> getSaleById(String id) =>
      (select(sales)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<int> insertSale(SalesCompanion sale) => into(sales).insert(sale);

  Future<bool> updateSale(SalesCompanion sale) => update(sales).replace(sale);

  Future<int> deleteSale(String id) =>
      (delete(sales)..where((s) => s.id.equals(id))).go();

  Stream<List<Sale>> watchSalesByShopId(String shopId) =>
      (select(sales)..where((s) => s.shopId.equals(shopId))).watch();

  Future<List<Sale>> getSalesByDateRange(
    String shopId,
    DateTime start,
    DateTime end,
  ) =>
      (select(sales)
        ..where((s) =>
            s.shopId.equals(shopId) &
            s.createdAt.isBetweenValues(start, end)))
          .get();

  Future<List<Sale>> getSalesByDateRangeAllShops(
    DateTime start,
    DateTime end,
  ) =>
      (select(sales)
        ..where((s) => s.createdAt.isBetweenValues(start, end)))
          .get();

  Future<List<Sale>> getSalesByCustomer(String customerId) =>
      (select(sales)..where((s) => s.customerId.equals(customerId))).get();

  Future<List<Sale>> getCreditSales(String shopId) =>
      (select(sales)
        ..where((s) => s.shopId.equals(shopId) & s.isCredit.equals(true)))
          .get();

  // Sale Items
  Future<List<SaleItem>> getSaleItems(String saleId) =>
      (select(saleItems)..where((si) => si.saleId.equals(saleId))).get();

  Future<int> insertSaleItem(SaleItemsCompanion item) =>
      into(saleItems).insert(item);

  Future<void> insertSaleItems(List<SaleItemsCompanion> items) async {
    await batch((batch) {
      batch.insertAll(saleItems, items);
    });
  }

  // Complete sale transaction
  Future<String> recordCompleteSale(
    SalesCompanion sale,
    List<SaleItemsCompanion> items,
  ) async {
    return await transaction(() async {
      final saleId = await into(sales).insert(sale);
      final saleIdStr = saleId.toString();
      
      final itemsWithSaleId = items.map((item) => 
        item.copyWith(saleId: Value(saleIdStr))
      ).toList();
      
      await batch((batch) {
        batch.insertAll(saleItems, itemsWithSaleId);
      });
      
      return saleIdStr;
    });
  }

  Future<double> getTotalSalesForDay(String shopId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = await customSelect(
      'SELECT SUM(total_amount) as total FROM sales WHERE shop_id = ? AND created_at >= ? AND created_at < ?',
      variables: [
        Variable.withString(shopId),
        Variable.withDateTime(startOfDay),
        Variable.withDateTime(endOfDay),
      ],
    ).getSingleOrNull();

    return result?.data['total'] as double? ?? 0.0;
  }

  Future<int> updateSyncStatus(String id, String status) =>
      (update(sales)..where((s) => s.id.equals(id))).write(
        SalesCompanion(syncStatus: Value(status)),
      );

  Future<int> markAsSynced(String id) =>
      (update(sales)..where((s) => s.id.equals(id))).write(
        SalesCompanion(
          syncStatus: const Value('synced'),
          syncedAt: Value(DateTime.now()),
        ),
      );
}
