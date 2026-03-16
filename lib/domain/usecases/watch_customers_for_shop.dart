import '../entities/customer_read_model.dart';
import '../repositories/customer_read_repository.dart';

class WatchCustomersForShop {
  final CustomerReadRepository _repository;

  const WatchCustomersForShop(this._repository);

  Stream<List<CustomerReadModel>> call(String shopId) {
    return _repository.watchByShop(shopId);
  }
}
