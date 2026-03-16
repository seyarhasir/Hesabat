import '../entities/product_read_model.dart';

abstract class ProductReadRepository {
  Stream<List<ProductReadModel>> watchByShop(String shopId);
}
