import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/storage_providers.dart';
import '../../domain/entities/customer_read_model.dart';
import '../../domain/entities/product_read_model.dart';
import '../../domain/usecases/read_usecase_providers.dart';

final activeShopIdProvider = FutureProvider<String?>((ref) async {
  final localKv = ref.read(localKvStoreProvider);
  return localKv.readString('active_shop_id');
});

final productsReadModelsProvider = StreamProvider<List<ProductReadModel>>((ref) {
  final watchProducts = ref.watch(watchProductsForShopProvider);
  final shopIdAsync = ref.watch(activeShopIdProvider);

  return shopIdAsync.when(
    data: (shopId) {
      if (shopId == null || shopId.isEmpty) {
        return Stream.value(const <ProductReadModel>[]);
      }
      return (() async* {
        yield const <ProductReadModel>[];
        yield* watchProducts(shopId);
      })();
    },
    loading: () => Stream.value(const <ProductReadModel>[]),
    error: (_, __) => Stream.value(const <ProductReadModel>[]),
  );
});

final customersReadModelsProvider = StreamProvider<List<CustomerReadModel>>((ref) {
  final watchCustomers = ref.watch(watchCustomersForShopProvider);
  final shopIdAsync = ref.watch(activeShopIdProvider);

  return shopIdAsync.when(
    data: (shopId) {
      if (shopId == null || shopId.isEmpty) {
        return Stream.value(const <CustomerReadModel>[]);
      }
      return (() async* {
        yield const <CustomerReadModel>[];
        yield* watchCustomers(shopId);
      })();
    },
    loading: () => Stream.value(const <CustomerReadModel>[]),
    error: (_, __) => Stream.value(const <CustomerReadModel>[]),
  );
});
