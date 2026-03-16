import 'dart:convert';

import '../../../core/storage/local_kv_store.dart';
import '../../../domain/usecases/run_pull_cycle.dart';

class LocalPullMaterializer {
  final LocalKvStore _kv;

  const LocalPullMaterializer(this._kv);

  static const _prefix = 'pull_cache';

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

      final key = '$_prefix::$table::$id';
      final existingRaw = await _kv.readString(key);
      final existing = _decodeMap(existingRaw);

      final shouldOverride = _shouldOverride(
        table: table,
        timestampColumn: timestampColumn,
        incoming: row,
        existing: existing,
      );

      if (shouldOverride) {
        await _kv.writeString(key, jsonEncode(row));
        applied += 1;
      } else {
        conflicts += 1;
      }
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

    // Financial rows are server-authoritative.
    if (_isFinancialTable(table)) return true;

    // Editable profile rows: LWW by timestamp, tie-break by device id.
    final incomingTs = _parseTs(incoming[timestampColumn]);
    final existingTs = _parseTs(existing[timestampColumn]);

    if (incomingTs == null) return false;
    if (existingTs == null) return true;

    if (incomingTs.isAfter(existingTs)) return true;
    if (incomingTs.isBefore(existingTs)) return false;

    final incomingDevice = _deviceIdOf(incoming);
    final existingDevice = _deviceIdOf(existing);
    if (incomingDevice == null || existingDevice == null) {
      return true;
    }

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
