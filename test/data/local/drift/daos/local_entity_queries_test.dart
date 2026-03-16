import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/data/local/drift/app_database.dart';
import 'package:hesabat/data/local/drift/daos/local_entity_queries.dart';

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

  test('watchProducts returns rows scoped by shop', () async {
    await db.into(db.productsTable).insert(
          ProductsTableCompanion.insert(
            id: 'p1',
            shopId: 'shop-1',
            name: 'Tea',
            payload: '{}',
          ),
        );

    await db.into(db.productsTable).insert(
          ProductsTableCompanion.insert(
            id: 'p2',
            shopId: 'shop-2',
            name: 'Sugar',
            payload: '{}',
          ),
        );

    final rows = await queries.watchProducts('shop-1').first;

    expect(rows.length, 1);
    expect(rows.single.id, 'p1');
  });
}
