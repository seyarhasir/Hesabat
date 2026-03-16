import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/drift/daos/local_entity_queries_provider.dart';
import '../../domain/repositories/customer_read_repository.dart';
import '../../domain/repositories/product_read_repository.dart';
import 'customer_read_repository_impl.dart';
import 'product_read_repository_impl.dart';

final productReadRepositoryProvider = Provider<ProductReadRepository>((ref) {
  final queries = ref.watch(localEntityQueriesProvider);
  return ProductReadRepositoryImpl(queries);
});

final customerReadRepositoryProvider = Provider<CustomerReadRepository>((ref) {
  final queries = ref.watch(localEntityQueriesProvider);
  return CustomerReadRepositoryImpl(queries);
});
