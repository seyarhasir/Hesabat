import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/data/local/drift/app_database.dart';
import 'package:hesabat/data/local/sync/drift_pull_materializer.dart';

void main() {
  late AppDatabase db;
  late DriftPullMaterializer materializer;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    materializer = DriftPullMaterializer(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('persists product rows into products table', () async {
    final result = await materializer.applyRows(
      table: 'products',
      timestampColumn: 'updated_at',
      rows: const [
        {
          'id': 'p1',
          'shop_id': 'shop-1',
          'updated_at': '2026-03-13T10:00:00Z',
          'name': 'Tea',
        },
      ],
    );

    expect(result.appliedRows, 1);
    expect(result.conflictRows, 0);

    final cached = await (db.select(db.productsTable)
          ..where((t) => t.id.equals('p1'))
          ..limit(1))
        .getSingleOrNull();

    expect(cached, isNotNull);
    expect(cached!.id, 'p1');
    expect(cached.shopId, 'shop-1');
  });

  test('uses pull cache fallback for unsupported tables', () async {
    final result = await materializer.applyRows(
      table: 'inventory_adjustments',
      timestampColumn: 'updated_at',
      rows: const [
        {
          'id': 'ia1',
          'updated_at': '2026-03-13T10:00:00Z',
          'delta': 2,
        },
      ],
    );

    expect(result.appliedRows, 1);
    expect(result.conflictRows, 0);

    final cached = await (db.select(db.pullCacheTable)
          ..where((t) => t.entityTable.equals('inventory_adjustments'))
          ..where((t) => t.rowId.equals('ia1'))
          ..limit(1))
        .getSingleOrNull();

    expect(cached, isNotNull);
    expect(cached!.entityTable, 'inventory_adjustments');
    expect(cached.rowId, 'ia1');
  });
}
