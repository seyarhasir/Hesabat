import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/domain/entities/customer_read_model.dart';
import 'package:hesabat/domain/entities/product_read_model.dart';
import 'package:hesabat/domain/repositories/customer_read_repository.dart';
import 'package:hesabat/domain/repositories/product_read_repository.dart';
import 'package:hesabat/domain/usecases/watch_customers_for_shop.dart';
import 'package:hesabat/domain/usecases/watch_products_for_shop.dart';

class _FakeProductReadRepository implements ProductReadRepository {
  @override
  Stream<List<ProductReadModel>> watchByShop(String shopId) {
    return Stream.value([
      ProductReadModel(
        id: 'p1',
        shopId: shopId,
        name: 'Tea',
        price: 10,
        stockQuantity: 2,
        updatedAt: null,
      ),
    ]);
  }
}

class _FakeCustomerReadRepository implements CustomerReadRepository {
  @override
  Stream<List<CustomerReadModel>> watchByShop(String shopId) {
    return Stream.value([
      CustomerReadModel(
        id: 'c1',
        shopId: shopId,
        name: 'Ali',
        phone: null,
        totalOwed: 12,
        updatedAt: null,
      ),
    ]);
  }
}

void main() {
  test('WatchProductsForShop delegates to repository', () async {
    final usecase = WatchProductsForShop(_FakeProductReadRepository());

    final rows = await usecase('shop-1').first;
    expect(rows.length, 1);
    expect(rows.single.shopId, 'shop-1');
  });

  test('WatchCustomersForShop delegates to repository', () async {
    final usecase = WatchCustomersForShop(_FakeCustomerReadRepository());

    final rows = await usecase('shop-1').first;
    expect(rows.length, 1);
    expect(rows.single.shopId, 'shop-1');
  });
}
