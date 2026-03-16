import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/core/network/connectivity_service.dart';
import 'package:hesabat/core/network/retry_policy.dart';
import 'package:hesabat/data/local/sync/in_memory_sync_queue_repository.dart';
import 'package:hesabat/domain/entities/sync_push_failure.dart';
import 'package:hesabat/domain/entities/sync_queue_item.dart';
import 'package:hesabat/domain/usecases/run_sync_cycle.dart';

void main() {
  test('skips cycle when offline', () async {
    final repo = InMemorySyncQueueRepository();

    await repo.enqueue(
      SyncQueueItem(
        opId: 'op-1',
        deviceId: 'device-1',
        entityType: 'sales',
        entityId: 's-1',
        operation: SyncOperation.insert,
        payload: const {'a': 1},
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    );

    final connectivity = ConnectivityService(
      checkConnectivity: () async => [ConnectivityResult.none],
    );

    final usecase = RunSyncCycle(
      repo,
      connectivity,
      const RetryPolicy(maxAttempts: 2),
      sleep: (_) async {},
    );

    final result = await usecase(
      pushOperation: (_) async {
        fail('push should not be called while offline');
      },
    );

    expect(result.skippedOffline, isTrue);
    expect(result.processed, 0);
    final pending = await repo.getPending();
    expect(pending.length, 1);
  });

  test('marks item success and updates checkpoint when push succeeds', () async {
    final repo = InMemorySyncQueueRepository();

    await repo.enqueue(
      SyncQueueItem(
        opId: 'op-2',
        deviceId: 'device-1',
        entityType: 'sales',
        entityId: 's-2',
        operation: SyncOperation.update,
        payload: const {'a': 2},
        createdAt: DateTime.utc(2026, 1, 2),
      ),
    );

    final connectivity = ConnectivityService(
      checkConnectivity: () async => [ConnectivityResult.wifi],
    );

    final expectedNow = DateTime.utc(2026, 1, 3);
    final usecase = RunSyncCycle(
      repo,
      connectivity,
      const RetryPolicy(maxAttempts: 2),
      sleep: (_) async {},
      nowUtc: () => expectedNow,
    );

    final result = await usecase(
      pushOperation: (_) async {},
    );

    expect(result.skippedOffline, isFalse);
    expect(result.processed, 1);
    expect(result.succeeded, 1);
    expect(result.failed, 0);

    final pending = await repo.getPending();
    expect(pending, isEmpty);

    final checkpoint = await repo.getCheckpoint();
    expect(checkpoint.lastPushedAt, expectedNow);
  });

  test('retries and marks attempt metadata when push keeps failing', () async {
    final repo = InMemorySyncQueueRepository();

    await repo.enqueue(
      SyncQueueItem(
        opId: 'op-3',
        deviceId: 'device-1',
        entityType: 'customers',
        entityId: 'c-1',
        operation: SyncOperation.insert,
        payload: const {'name': 'X'},
        createdAt: DateTime.utc(2026, 1, 4),
      ),
    );

    final connectivity = ConnectivityService(
      checkConnectivity: () async => [ConnectivityResult.mobile],
    );

    final usecase = RunSyncCycle(
      repo,
      connectivity,
      const RetryPolicy(maxAttempts: 3),
      sleep: (_) async {},
    );

    final result = await usecase(
      pushOperation: (_) async {
        throw Exception('server unavailable');
      },
    );

    expect(result.processed, 1);
    expect(result.succeeded, 0);
    expect(result.failed, 1);

    final pending = await repo.getPending();
    expect(pending.single.attemptCount, 3);
    expect(pending.single.lastError, contains('server unavailable'));
  });

  test('returns blockedAuth outcome and stops cycle when auth is invalid', () async {
    final repo = InMemorySyncQueueRepository();

    await repo.enqueue(
      SyncQueueItem(
        opId: 'op-4',
        deviceId: 'device-1',
        entityType: 'customers',
        entityId: 'c-2',
        operation: SyncOperation.insert,
        payload: const {'name': 'Y'},
        createdAt: DateTime.utc(2026, 1, 5),
      ),
    );

    final connectivity = ConnectivityService(
      checkConnectivity: () async => [ConnectivityResult.mobile],
    );

    final usecase = RunSyncCycle(
      repo,
      connectivity,
      const RetryPolicy(maxAttempts: 5),
      sleep: (_) async {},
    );

    final result = await usecase(
      pushOperation: (_) async {
        throw const SyncPushException(
          type: SyncPushFailureType.blockedAuth,
          message: 'token expired',
        );
      },
    );

    expect(result.outcome, SyncCycleOutcome.blockedAuth);
    expect(result.failed, 1);

    final pending = await repo.getPending();
    expect(pending.single.attemptCount, 1);
    expect(pending.single.lastError, 'token expired');
  });

  test('returns blockedRls outcome and stops cycle when RLS denies write', () async {
    final repo = InMemorySyncQueueRepository();

    await repo.enqueue(
      SyncQueueItem(
        opId: 'op-5',
        deviceId: 'device-1',
        entityType: 'products',
        entityId: 'p-1',
        operation: SyncOperation.update,
        payload: const {'name': 'P'},
        createdAt: DateTime.utc(2026, 1, 6),
      ),
    );

    final connectivity = ConnectivityService(
      checkConnectivity: () async => [ConnectivityResult.wifi],
    );

    final usecase = RunSyncCycle(
      repo,
      connectivity,
      const RetryPolicy(maxAttempts: 5),
      sleep: (_) async {},
    );

    final result = await usecase(
      pushOperation: (_) async {
        throw const SyncPushException(
          type: SyncPushFailureType.blockedRls,
          message: 'policy denied',
        );
      },
    );

    expect(result.outcome, SyncCycleOutcome.blockedRls);
    expect(result.failed, 1);

    final pending = await repo.getPending();
    expect(pending.single.attemptCount, 1);
    expect(pending.single.lastError, 'policy denied');
  });
}
