import '../../core/network/connectivity_service.dart';
import '../entities/sync_checkpoint.dart';
import '../entities/sync_pull_failure.dart';
import '../repositories/sync_queue_repository.dart';

class PullSpec {
  final String table;
  final String timestampColumn;

  const PullSpec({required this.table, this.timestampColumn = 'updated_at'});
}

typedef FetchPullRows = Future<List<Map<String, dynamic>>> Function({
  required String table,
  required String shopId,
  required DateTime? since,
  required String timestampColumn,
  required int limit,
});

class PullApplyResult {
  final int appliedRows;
  final int conflictRows;

  const PullApplyResult({
    required this.appliedRows,
    required this.conflictRows,
  });
}

typedef ApplyPulledRows = Future<PullApplyResult> Function({
  required String table,
  required List<Map<String, dynamic>> rows,
  required String timestampColumn,
});

enum PullCycleOutcome {
  completed,
  skippedOffline,
  blockedAuth,
  blockedRls,
  conflict,
}

class RunPullCycleResult {
  final int pulledRows;
  final int conflictRows;
  final PullCycleOutcome outcome;

  const RunPullCycleResult({
    required this.pulledRows,
    required this.conflictRows,
    required this.outcome,
  });
}

class RunPullCycle {
  final SyncQueueRepository _repository;
  final ConnectivityService _connectivity;

  const RunPullCycle(this._repository, this._connectivity);

  Future<RunPullCycleResult> call({
    required String shopId,
    required FetchPullRows fetchRows,
    ApplyPulledRows? applyRows,
    List<PullSpec> specs = const [
      PullSpec(table: 'products'),
      PullSpec(table: 'customers'),
      PullSpec(table: 'sales'),
      PullSpec(table: 'debts'),
      PullSpec(table: 'debt_payments', timestampColumn: 'created_at'),
    ],
    int perTableLimit = 200,
  }) async {
    final isOnline = await _connectivity.isOnlineNow();
    if (!isOnline) {
      return const RunPullCycleResult(
        pulledRows: 0,
        conflictRows: 0,
        outcome: PullCycleOutcome.skippedOffline,
      );
    }

    final checkpoint = await _repository.getCheckpoint();
    DateTime? latest = checkpoint.lastPulledAt;
    var totalRows = 0;
    var conflictRows = 0;

    try {
      for (final spec in specs) {
        final rows = await fetchRows(
          table: spec.table,
          shopId: shopId,
          since: checkpoint.lastPulledAt,
          timestampColumn: spec.timestampColumn,
          limit: perTableLimit,
        );

        totalRows += rows.length;

        if (applyRows != null) {
          final applyResult = await applyRows(
            table: spec.table,
            rows: rows,
            timestampColumn: spec.timestampColumn,
          );
          conflictRows += applyResult.conflictRows;
        } else {
          for (final row in rows) {
            if (row['_sync_conflict'] == true) {
              conflictRows += 1;
            }
          }
        }

        for (final row in rows) {
          final ts = row[spec.timestampColumn];
          final parsed = _parseTs(ts);
          if (parsed != null && (latest == null || parsed.isAfter(latest))) {
            latest = parsed;
          }
        }
      }
    } on SyncPullException catch (e) {
      if (e.type == SyncPullFailureType.blockedAuth) {
        return RunPullCycleResult(
          pulledRows: totalRows,
          conflictRows: conflictRows,
          outcome: PullCycleOutcome.blockedAuth,
        );
      }
      if (e.type == SyncPullFailureType.blockedRls) {
        return RunPullCycleResult(
          pulledRows: totalRows,
          conflictRows: conflictRows,
          outcome: PullCycleOutcome.blockedRls,
        );
      }
      rethrow;
    }

    if (latest != null && (checkpoint.lastPulledAt == null || latest!.isAfter(checkpoint.lastPulledAt!))) {
      await _repository.setCheckpoint(
        SyncCheckpoint(
          lastPulledAt: latest,
          lastPushedAt: checkpoint.lastPushedAt,
        ),
      );
    }

    return RunPullCycleResult(
      pulledRows: totalRows,
      conflictRows: conflictRows,
      outcome: conflictRows > 0 ? PullCycleOutcome.conflict : PullCycleOutcome.completed,
    );
  }

  DateTime? _parseTs(Object? value) {
    if (value is DateTime) return value.toUtc();
    if (value is String) return DateTime.tryParse(value)?.toUtc();
    return null;
  }
}
