import '../entities/customer_read_model.dart';

abstract class CustomerReadRepository {
  Stream<List<CustomerReadModel>> watchByShop(String shopId);
}
