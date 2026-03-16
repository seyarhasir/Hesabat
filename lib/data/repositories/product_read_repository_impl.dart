import '../../data/local/drift/daos/local_entity_queries.dart';
import '../../data/local/drift/mappers/local_read_model_mappers.dart';
import '../../domain/entities/product_read_model.dart';
import '../../domain/repositories/product_read_repository.dart';

class ProductReadRepositoryImpl implements ProductReadRepository {
  final LocalEntityQueries _queries;

  const ProductReadRepositoryImpl(this._queries);

  @override
  Stream<List<ProductReadModel>> watchByShop(String shopId) {
    return _queries.watchProducts(shopId).map(LocalReadModelMappers.mapProducts);
  }
}
