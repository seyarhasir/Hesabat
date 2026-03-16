import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/core/storage/local_kv_store.dart';
import 'package:hesabat/data/local/sync/local_pull_materializer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('stores new rows when cache is empty', () async {
    final kv = LocalKvStore();
    final materializer = LocalPullMaterializer(kv);

    final result = await materializer.applyRows(
      table: 'products',
      timestampColumn: 'updated_at',
      rows: const [
        {
          'id': 'p1',
          'updated_at': '2026-03-10T10:00:00Z',
          'name': 'Tea',
        },
      ],
    );

    expect(result.appliedRows, 1);
    expect(result.conflictRows, 0);
  });

  test('keeps newer local editable row and reports conflict', () async {
    final kv = LocalKvStore();
    final materializer = LocalPullMaterializer(kv);

    await materializer.applyRows(
      table: 'products',
      timestampColumn: 'updated_at',
      rows: const [
        {
          'id': 'p1',
          'updated_at': '2026-03-12T10:00:00Z',
          'name': 'Tea local newer',
          'device_id': 'dev-z',
        },
      ],
    );

    final result = await materializer.applyRows(
      table: 'products',
      timestampColumn: 'updated_at',
      rows: const [
        {
          'id': 'p1',
          'updated_at': '2026-03-11T10:00:00Z',
          'name': 'Tea remote older',
          'device_id': 'dev-a',
        },
      ],
    );

    expect(result.appliedRows, 0);
    expect(result.conflictRows, 1);
  });

  test('overrides local for financial tables (server authoritative)', () async {
    final kv = LocalKvStore();
    final materializer = LocalPullMaterializer(kv);

    await materializer.applyRows(
      table: 'sales',
      timestampColumn: 'updated_at',
      rows: const [
        {
          'id': 's1',
          'updated_at': '2026-03-12T10:00:00Z',
          'total_amount': 500,
        },
      ],
    );

    final result = await materializer.applyRows(
      table: 'sales',
      timestampColumn: 'updated_at',
      rows: const [
        {
          'id': 's1',
          'updated_at': '2026-03-11T10:00:00Z',
          'total_amount': 400,
        },
      ],
    );

    expect(result.appliedRows, 1);
    expect(result.conflictRows, 0);
  });
}
