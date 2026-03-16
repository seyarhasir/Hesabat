import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/data/local/drift/app_database.dart';
import 'package:hesabat/data/local/drift/daos/local_entity_queries.dart';
import 'package:hesabat/data/repositories/customer_read_repository_impl.dart';
import 'package:hesabat/data/repositories/product_read_repository_impl.dart';

void main() {
  late AppDatabase db;
  late LocalEntityQueries queries;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    queries = LocalEntityQueries(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('product repository streams mapped products for shop', () async {
    final repo = ProductReadRepositoryImpl(queries);

    await db.into(db.productsTable).insert(
          ProductsTableCompanion.insert(
            id: 'p1',
            shopId: 'shop-1',
            name: 'Tea',
            price: const drift.Value(12.5),
            stockQuantity: const drift.Value(4),
            payload: '{}',
          ),
        );

    final rows = await repo.watchByShop('shop-1').first;
    expect(rows.length, 1);
    expect(rows.single.name, 'Tea');
  });

  test('customer repository streams mapped customers for shop', () async {
    final repo = CustomerReadRepositoryImpl(queries);

    await db.into(db.customersTable).insert(
          CustomersTableCompanion.insert(
            id: 'c1',
            shopId: 'shop-1',
            name: 'Ali',
            totalOwed: const drift.Value(25),
            payload: '{}',
          ),
        );

    final rows = await repo.watchByShop('shop-1').first;
    expect(rows.length, 1);
    expect(rows.single.name, 'Ali');
  });
}
