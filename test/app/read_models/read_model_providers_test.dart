import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/data/local/drift/app_database.dart';
import 'package:hesabat/data/local/drift/mappers/local_read_model_mappers.dart';

void main() {
  test('mapProducts converts local table rows to read models', () {
    final rows = [
      ProductsTableData(
        id: 'p1',
        shopId: 'shop-1',
        name: 'Tea',
        price: 12.5,
        stockQuantity: 3,
        updatedAt: DateTime.utc(2026, 3, 16),
        updatedByDeviceId: null,
        payload: '{}',
      ),
    ];

    final models = LocalReadModelMappers.mapProducts(rows);

    expect(models.length, 1);
    expect(models.single.id, 'p1');
    expect(models.single.name, 'Tea');
    expect(models.single.price, 12.5);
  });

  test('mapCustomers converts local table rows to read models', () {
    final rows = [
      CustomersTableData(
        id: 'c1',
        shopId: 'shop-1',
        name: 'Ali',
        phone: '+93700000000',
        totalOwed: 100,
        updatedAt: DateTime.utc(2026, 3, 16),
        updatedByDeviceId: null,
        payload: '{}',
      ),
    ];

    final models = LocalReadModelMappers.mapCustomers(rows);

    expect(models.length, 1);
    expect(models.single.id, 'c1');
    expect(models.single.name, 'Ali');
    expect(models.single.totalOwed, 100);
  });
}
