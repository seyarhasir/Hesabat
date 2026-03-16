import '../../data/local/drift/daos/local_entity_queries.dart';
import '../../data/local/drift/mappers/local_read_model_mappers.dart';
import '../../domain/entities/customer_read_model.dart';
import '../../domain/repositories/customer_read_repository.dart';

class CustomerReadRepositoryImpl implements CustomerReadRepository {
  final LocalEntityQueries _queries;

  const CustomerReadRepositoryImpl(this._queries);

  @override
  Stream<List<CustomerReadModel>> watchByShop(String shopId) {
    return _queries.watchCustomers(shopId).map(LocalReadModelMappers.mapCustomers);
  }
}
