import '../entities/product_read_model.dart';
import '../repositories/product_read_repository.dart';

class WatchProductsForShop {
  final ProductReadRepository _repository;

  const WatchProductsForShop(this._repository);

  Stream<List<ProductReadModel>> call(String shopId) {
    return _repository.watchByShop(shopId);
  }
}
