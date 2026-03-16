import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/app/actions/product_write_actions.dart';
import 'package:hesabat/core/storage/local_kv_store.dart';
import 'package:hesabat/core/storage/storage_providers.dart';
import 'package:hesabat/data/local/drift/app_database.dart';
import 'package:hesabat/data/local/drift/app_database_provider.dart';

class _FakeLocalKvStore extends LocalKvStore {
  final Map<String, String> _values;

  _FakeLocalKvStore(this._values);

  @override
  Future<String?> readString(String key) async => _values[key];

  @override
  Future<void> writeString(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('addOrUpdateProduct writes local row and enqueues sync operation', () async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        localKvStoreProvider.overrideWithValue(
          _FakeLocalKvStore({
            'active_shop_id': 'shop-1',
            'active_device_id': 'device-1',
          }),
        ),
      ],
    );
    addTearDown(container.dispose);

    final ok = await container.read(productWriteActionsProvider).addOrUpdateProduct(
          name: 'Tea',
          price: 12.5,
          stockQuantity: 3,
        );

    expect(ok, isTrue);

    final products = await db.select(db.productsTable).get();
    expect(products.length, 1);
    expect(products.single.name, 'Tea');

    final queued = await db.select(db.syncQueueTable).get();
    expect(queued.length, 1);
    expect(queued.single.entityType, 'products');
    expect(queued.single.operation, 'insert');
  });

  test('deleteProduct removes local row and enqueues delete operation', () async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        localKvStoreProvider.overrideWithValue(
          _FakeLocalKvStore({
            'active_shop_id': 'shop-1',
            'active_device_id': 'device-1',
          }),
        ),
      ],
    );
    addTearDown(container.dispose);

    final actions = container.read(productWriteActionsProvider);
    await actions.addOrUpdateProduct(name: 'Tea', price: 12.5, stockQuantity: 3);

    final product = (await db.select(db.productsTable).get()).single;
    final ok = await actions.deleteProduct(productId: product.id);

    expect(ok, isTrue);
    expect(await db.select(db.productsTable).get(), isEmpty);

    final queued = await db.select(db.syncQueueTable).get();
    expect(queued.last.entityType, 'products');
    expect(queued.last.operation, 'delete');
    expect(queued.last.entityId, product.id);
  });
}
