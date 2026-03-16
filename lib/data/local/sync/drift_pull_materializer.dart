import 'dart:convert';

import 'package:drift/drift.dart';

import '../drift/app_database.dart';
import '../../../domain/usecases/run_pull_cycle.dart';

class DriftPullMaterializer {
  final AppDatabase _db;

  const DriftPullMaterializer(this._db);

  Future<PullApplyResult> applyRows({
    required String table,
    required List<Map<String, dynamic>> rows,
    required String timestampColumn,
  }) async {
    var applied = 0;
    var conflicts = 0;

    for (final row in rows) {
      final id = row['id']?.toString();
      if (id == null || id.isEmpty) {
        continue;
      }

      final existingMap = await _loadExistingRow(table: table, id: id);

      final shouldOverride = _shouldOverride(
        table: table,
        timestampColumn: timestampColumn,
        incoming: row,
        existing: existingMap,
      );

      if (!shouldOverride) {
        conflicts += 1;
        continue;
      }

      await _upsertRow(
        table: table,
        id: id,
        row: row,
        timestampColumn: timestampColumn,
      );

      applied += 1;
    }

    return PullApplyResult(appliedRows: applied, conflictRows: conflicts);
  }

  bool _shouldOverride({
    required String table,
    required String timestampColumn,
    required Map<String, dynamic> incoming,
    required Map<String, dynamic>? existing,
  }) {
    if (existing == null) return true;

    if (_isFinancialTable(table)) return true;

    final incomingTs = _parseTs(incoming[timestampColumn]);
    final existingTs = _parseTs(existing[timestampColumn]);

    if (incomingTs == null) return false;
    if (existingTs == null) return true;

    if (incomingTs.isAfter(existingTs)) return true;
    if (incomingTs.isBefore(existingTs)) return false;

    final incomingDevice = _deviceIdOf(incoming);
    final existingDevice = _deviceIdOf(existing);
    if (incomingDevice == null || existingDevice == null) return true;

    return incomingDevice.compareTo(existingDevice) >= 0;
  }

  bool _isFinancialTable(String table) {
    switch (table) {
      case 'sales':
      case 'sale_items':
      case 'debts':
      case 'debt_payments':
        return true;
      default:
        return false;
    }
  }

  String? _deviceIdOf(Map<String, dynamic> row) {
    return row['device_id']?.toString() ?? row['updated_by_device_id']?.toString();
  }

  DateTime? _parseTs(Object? value) {
    if (value is DateTime) return value.toUtc();
    if (value is String) return DateTime.tryParse(value)?.toUtc();
    return null;
  }

  Future<Map<String, dynamic>?> _loadExistingRow({
    required String table,
    required String id,
  }) async {
    switch (table) {
      case 'products':
        final row = await (_db.select(_db.productsTable)
              ..where((t) => t.id.equals(id))
              ..limit(1))
            .getSingleOrNull();
        return row == null ? null : _decodeMap(row.payload);
      case 'customers':
        final row = await (_db.select(_db.customersTable)
              ..where((t) => t.id.equals(id))
              ..limit(1))
            .getSingleOrNull();
        return row == null ? null : _decodeMap(row.payload);
      case 'sales':
        final row = await (_db.select(_db.salesTable)
              ..where((t) => t.id.equals(id))
              ..limit(1))
            .getSingleOrNull();
        return row == null ? null : _decodeMap(row.payload);
      case 'debts':
        final row = await (_db.select(_db.debtsTable)
              ..where((t) => t.id.equals(id))
              ..limit(1))
            .getSingleOrNull();
        return row == null ? null : _decodeMap(row.payload);
      default:
        final row = await (_db.select(_db.pullCacheTable)
              ..where((t) => t.entityTable.equals(table))
              ..where((t) => t.rowId.equals(id))
              ..limit(1))
            .getSingleOrNull();
        return row == null ? null : _decodeMap(row.payload);
    }
  }

  Future<void> _upsertRow({
    required String table,
    required String id,
    required Map<String, dynamic> row,
    required String timestampColumn,
  }) async {
    final payload = jsonEncode(row);
    final updatedAt = _parseTs(row[timestampColumn]);
    final deviceId = _deviceIdOf(row);
    final shopId = row['shop_id']?.toString() ?? '';

    switch (table) {
      case 'products':
        await _db.into(_db.productsTable).insertOnConflictUpdate(
              ProductsTableCompanion.insert(
                id: id,
                shopId: shopId,
                name: row['name']?.toString() ?? '',
                price: Value(_toDouble(row['price'])),
                stockQuantity: Value(_toDouble(row['stock_quantity'])),
                updatedAt: Value(updatedAt),
                updatedByDeviceId: Value(deviceId),
                payload: payload,
              ),
            );
        return;
      case 'customers':
        await _db.into(_db.customersTable).insertOnConflictUpdate(
              CustomersTableCompanion.insert(
                id: id,
                shopId: shopId,
                name: row['name']?.toString() ?? '',
                phone: Value(row['phone']?.toString()),
                totalOwed: Value(_toDouble(row['total_owed'])),
                updatedAt: Value(updatedAt),
                updatedByDeviceId: Value(deviceId),
                payload: payload,
              ),
            );
        return;
      case 'sales':
        await _db.into(_db.salesTable).insertOnConflictUpdate(
              SalesTableCompanion.insert(
                id: id,
                shopId: shopId,
                totalAmount: Value(_toDouble(row['total_amount'])),
                isCredit: Value(_toBool(row['is_credit'])),
                updatedAt: Value(updatedAt),
                updatedByDeviceId: Value(deviceId),
                payload: payload,
              ),
            );
        return;
      case 'debts':
        await _db.into(_db.debtsTable).insertOnConflictUpdate(
              DebtsTableCompanion.insert(
                id: id,
                shopId: shopId,
                amountOriginal: Value(_toDouble(row['amount_original'])),
                amountPaid: Value(_toDouble(row['amount_paid'])),
                status: Value(row['status']?.toString() ?? 'open'),
                updatedAt: Value(updatedAt),
                updatedByDeviceId: Value(deviceId),
                payload: payload,
              ),
            );
        return;
      default:
        await _db.into(_db.pullCacheTable).insertOnConflictUpdate(
              PullCacheTableCompanion.insert(
                entityTable: table,
                rowId: id,
                payload: payload,
                updatedAt: Value(updatedAt),
                updatedByDeviceId: Value(deviceId),
              ),
            );
    }
  }

  double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  bool _toBool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }

  Map<String, dynamic>? _decodeMap(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) {
        return decoded.map((k, v) => MapEntry(k.toString(), v));
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
