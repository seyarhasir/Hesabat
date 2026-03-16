import '../../../../domain/entities/customer_read_model.dart';
import '../../../../domain/entities/product_read_model.dart';
import '../app_database.dart';

class LocalReadModelMappers {
  static List<ProductReadModel> mapProducts(List<ProductsTableData> rows) {
    return rows
        .map(
          (r) => ProductReadModel(
            id: r.id,
            shopId: r.shopId,
            name: r.name,
            price: r.price,
            stockQuantity: r.stockQuantity,
            updatedAt: r.updatedAt,
          ),
        )
        .toList(growable: false);
  }

  static List<CustomerReadModel> mapCustomers(List<CustomersTableData> rows) {
    return rows
        .map(
          (r) => CustomerReadModel(
            id: r.id,
            shopId: r.shopId,
            name: r.name,
            phone: r.phone,
            totalOwed: r.totalOwed,
            updatedAt: r.updatedAt,
          ),
        )
        .toList(growable: false);
  }
}
