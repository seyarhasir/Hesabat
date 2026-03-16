import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/read_repository_providers.dart';
import 'watch_customers_for_shop.dart';
import 'watch_products_for_shop.dart';

final watchProductsForShopProvider = Provider<WatchProductsForShop>((ref) {
  final repository = ref.watch(productReadRepositoryProvider);
  return WatchProductsForShop(repository);
});

final watchCustomersForShopProvider = Provider<WatchCustomersForShop>((ref) {
  final repository = ref.watch(customerReadRepositoryProvider);
  return WatchCustomersForShop(repository);
});
