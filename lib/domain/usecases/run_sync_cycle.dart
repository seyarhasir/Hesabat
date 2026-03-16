import '../../core/network/connectivity_service.dart';
import '../../core/network/retry_policy.dart';
import '../entities/sync_checkpoint.dart';
import '../entities/sync_push_failure.dart';
import '../entities/sync_queue_item.dart';
import '../repositories/sync_queue_repository.dart';

typedef SyncPushOperation = Future<void> Function(SyncQueueItem item);

typedef SleepFn = Future<void> Function(Duration duration);

typedef UtcNowFn = DateTime Function();

enum SyncCycleOutcome {
  completed,
  skippedOffline,
  blockedAuth,
  blockedRls,
}

class RunSyncCycleResult {
  final int processed;
  final int succeeded;
  final int failed;
  final SyncCycleOutcome outcome;

  const RunSyncCycleResult({
    required this.processed,
    required this.succeeded,
    required this.failed,
    required this.outcome,
  });

  bool get skippedOffline => outcome == SyncCycleOutcome.skippedOffline;
}

class RunSyncCycle {
  final SyncQueueRepository _repository;
  final ConnectivityService _connectivity;
  final RetryPolicy _retryPolicy;
  final SleepFn _sleep;
  final UtcNowFn _nowUtc;

  RunSyncCycle(
    this._repository,
    this._connectivity,
    this._retryPolicy, {
    SleepFn? sleep,
    UtcNowFn? nowUtc,
  })  : _sleep = sleep ?? Future.delayed,
        _nowUtc = nowUtc ?? (() => DateTime.now().toUtc());

  Future<RunSyncCycleResult> call({
    required SyncPushOperation pushOperation,
    int batchLimit = 100,
  }) async {
    final isOnline = await _connectivity.isOnlineNow();
    if (!isOnline) {
      return const RunSyncCycleResult(
        processed: 0,
        succeeded: 0,
        failed: 0,
        outcome: SyncCycleOutcome.skippedOffline,
      );
    }

    final pending = await _repository.getPending(limit: batchLimit);

    var succeeded = 0;
    var failed = 0;

    for (final item in pending) {
      var didSucceed = false;
      SyncCycleOutcome? blockedOutcome;

      for (var attempt = 0; attempt < _retryPolicy.maxAttempts; attempt++) {
        try {
          await pushOperation(item);
          didSucceed = true;
          break;
        } catch (e) {
          if (e is SyncPushException) {
            await _repository.markAttempt(opId: item.opId, error: e.message);

            if (e.type == SyncPushFailureType.blockedAuth) {
              blockedOutcome = SyncCycleOutcome.blockedAuth;
              break;
            }

            if (e.type == SyncPushFailureType.blockedRls) {
              blockedOutcome = SyncCycleOutcome.blockedRls;
              break;
            }

            if (e.type == SyncPushFailureType.fatal) {
              break;
            }
          } else {
            await _repository.markAttempt(opId: item.opId, error: e.toString());
          }

          if (attempt < _retryPolicy.maxAttempts - 1) {
            await _sleep(_retryPolicy.backoffDelay(attempt));
          }
        }
      }

      if (blockedOutcome != null) {
        failed += 1;
        return RunSyncCycleResult(
          processed: succeeded + failed,
          succeeded: succeeded,
          failed: failed,
          outcome: blockedOutcome,
        );
      }

      if (didSucceed) {
        await _repository.markSuccess(opId: item.opId);
        succeeded += 1;
      } else {
        failed += 1;
      }
    }

    if (succeeded > 0) {
      final current = await _repository.getCheckpoint();
      final next = SyncCheckpoint(
        lastPulledAt: current.lastPulledAt,
        lastPushedAt: _nowUtc(),
      );
      await _repository.setCheckpoint(next);
    }

    return RunSyncCycleResult(
      processed: pending.length,
      succeeded: succeeded,
      failed: failed,
      outcome: SyncCycleOutcome.completed,
    );
  }
}
