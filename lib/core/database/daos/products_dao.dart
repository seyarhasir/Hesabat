import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/products_table.dart';

part 'products_dao.g.dart';

/// Data Access Object for Products table
/// Handles CRUD operations, search, and inventory-related queries
@DriftAccessor(tables: [Products])
class ProductsDao extends DatabaseAccessor<AppDatabase> with _$ProductsDaoMixin {
  ProductsDao(super.db);

  // ─────────────────────────────────────────────────────────────────
  // CREATE
  // ─────────────────────────────────────────────────────────────────

  /// Insert a new product
  Future<int> insertProduct(ProductsCompanion product) {
    return into(db.products).insert(product);
  }

  /// Insert multiple products (batch operation for seeding)
  Future<void> insertMultipleProducts(List<ProductsCompanion> productsList) async {
    await batch((batch) {
      batch.insertAll(db.products, productsList);
    });
  }

  // ─────────────────────────────────────────────────────────────────
  // READ
  // ─────────────────────────────────────────────────────────────────

  /// Get all products for a shop
  Stream<List<Product>> watchAllProducts(String shopId) {
    return (select(db.products)
          ..where((p) => p.shopId.equals(shopId))
          ..orderBy([(p) => OrderingTerm.desc(p.updatedAt)]))
        .watch();
  }

  /// Get all products (one-time query)
  Future<List<Product>> getAllProducts(String shopId) {
    return (select(db.products)
          ..where((p) => p.shopId.equals(shopId))
          ..orderBy([(p) => OrderingTerm.desc(p.updatedAt)]))
        .get();
  }

  /// Get product by ID
  Future<Product?> getProductById(String id) {
    return (select(db.products)..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  /// Get product by barcode
  Future<Product?> getProductByBarcode(String shopId, String barcode) {
    return (select(db.products)
          ..where((p) => p.shopId.equals(shopId) & p.barcode.equals(barcode)))
        .getSingleOrNull();
  }

  /// Search products by name (case-insensitive, partial match)
  /// Searches in Dari, Pashto, and English names
  Future<List<Product>> searchProducts(String shopId, String query) {
    final lowerQuery = query.toLowerCase();
    return (select(db.products)
          ..where((p) =>
              p.shopId.equals(shopId) &
              (p.nameDari.lower().like('%$lowerQuery%') |
                  p.namePashto.lower().like('%$lowerQuery%') |
                  p.nameEn.lower().like('%$lowerQuery%') |
                  p.barcode.equals(query))))
        .get();
  }

  /// Get products by category
  Stream<List<Product>> watchProductsByCategory(String shopId, String categoryId) {
    return (select(db.products)
          ..where((p) => p.shopId.equals(shopId) & p.categoryId.equals(categoryId))
          ..orderBy([(p) => OrderingTerm.desc(p.updatedAt)]))
        .watch();
  }

  /// Get low stock products (below min_stock_alert)
  Stream<List<Product>> watchLowStockProducts(String shopId) {
    return (select(db.products)
          ..where((p) => p.shopId.equals(shopId) & p.stockQuantity.isSmallerThan(p.minStockAlert))
          ..orderBy([(p) => OrderingTerm.asc(p.stockQuantity)]))
        .watch();
  }

  /// Get recently sold products (for quick access)
  /// Returns products that appear in recent sales
  Future<List<Product>> getRecentProducts(String shopId, {int limit = 20}) async {
    // This query joins with sales to find recently sold products
    final query = customSelect(
      '''
      SELECT p.* FROM products p
      INNER JOIN sale_items si ON p.id = si.product_id
      INNER JOIN sales s ON si.sale_id = s.id
      WHERE p.shop_id = ? AND s.shop_id = ?
      GROUP BY p.id
      ORDER BY MAX(s.created_at) DESC
      LIMIT ?
      ''',
      variables: [Variable.withString(shopId), Variable.withString(shopId), Variable.withInt(limit)],
      readsFrom: {db.products, db.saleItems, db.sales},
    );

    final rows = await query.get();
    final futures = rows.map((row) => db.products.mapFromRow(row)).toList();
    return await Future.wait(futures);
  }

  /// Get products with expiry dates (for pharmacy/bakery)
  Stream<List<Product>> watchExpiringProducts(String shopId, {int daysThreshold = 30}) {
    final thresholdDate = DateTime.now().add(Duration(days: daysThreshold));
    return (select(db.products)
          ..where((p) =>
              p.shopId.equals(shopId) &
              p.expiryDate.isNotNull() &
              p.expiryDate.isSmallerThanValue(thresholdDate))
          ..orderBy([(p) => OrderingTerm.asc(p.expiryDate)]))
        .watch();
  }

  Future<double> getInventoryValue(String shopId) async {
    final result = await customSelect(
      '''
      SELECT SUM(stock_quantity * COALESCE(cost_price, price, 0.0)) as total_value
      FROM products
      WHERE shop_id = ? AND is_active = 1
      ''',
      variables: [Variable.withString(shopId)],
      readsFrom: {db.products},
    ).getSingle();

    return result.read<double?>('total_value') ?? 0.0;
  }

  // ─────────────────────────────────────────────────────────────────
  // UPDATE
  // ─────────────────────────────────────────────────────────────────

  /// Update a product
  Future<bool> updateProduct(String id, ProductsCompanion product) {
    return update(db.products).replace(product.copyWith(id: Value(id)));
  }

  /// Update stock quantity
  Future<int> updateStock(String id, double newQuantity) {
    return (update(db.products)..where((p) => p.id.equals(id)))
        .write(ProductsCompanion(stockQuantity: Value(newQuantity)));
  }

  /// Increment stock (for receiving new inventory)
  Future<int> incrementStock(String id, double amount) async {
    final product = await getProductById(id);
    if (product == null) return 0;
    
    return updateStock(id, product.stockQuantity + amount);
  }

  /// Decrement stock (for sales)
  Future<int> decrementStock(String id, double amount) async {
    final product = await getProductById(id);
    if (product == null) return 0;
    
    final newQuantity = product.stockQuantity - amount;
    return updateStock(id, newQuantity < 0 ? 0 : newQuantity);
  }

  /// Update sync status
  Future<int> updateSyncStatus(String id, String status) {
    return (update(db.products)..where((p) => p.id.equals(id)))
        .write(ProductsCompanion(syncStatus: Value(status)));
  }

  /// Mark multiple products as synced
  Future<void> markAsSynced(List<String> ids) async {
    await batch((batch) {
      for (final id in ids) {
        batch.update(
          db.products,
          ProductsCompanion(syncStatus: const Value('synced')),
          where: (p) => p.id.equals(id),
        );
      }
    });
  }

  // ─────────────────────────────────────────────────────────────────
  // DELETE
  // ─────────────────────────────────────────────────────────────────

  /// Delete a product (soft delete - set is_active to false)
  Future<int> softDeleteProduct(String id) {
    return (update(db.products)..where((p) => p.id.equals(id)))
        .write(const ProductsCompanion(isActive: Value(false)));
  }

  /// Hard delete a product (use with caution)
  Future<int> hardDeleteProduct(String id) {
    return (delete(db.products)..where((p) => p.id.equals(id))).go();
  }

  /// Delete all products for a shop (useful for demo reset)
  Future<int> deleteAllProducts(String shopId) {
    return (delete(db.products)..where((p) => p.shopId.equals(shopId))).go();
  }

  // ─────────────────────────────────────────────────────────────────
  // COUNT & STATISTICS
  // ─────────────────────────────────────────────────────────────────

  /// Count total products
  Future<int> countProducts(String shopId) async {
    final result = await (selectOnly(db.products)
          ..addColumns([db.products.id.count()])
          ..where(db.products.shopId.equals(shopId)))
        .getSingle();
    return result.read<int>(db.products.id.count()) ?? 0;
  }

  /// Count low stock products
  Future<int> countLowStock(String shopId) async {
    final result = await (selectOnly(db.products)
          ..addColumns([db.products.id.count()])
          ..where(db.products.shopId.equals(shopId) & db.products.stockQuantity.isSmallerThan(db.products.minStockAlert)))
        .getSingle();
    return result.read<int>(db.products.id.count()) ?? 0;
  }
}
