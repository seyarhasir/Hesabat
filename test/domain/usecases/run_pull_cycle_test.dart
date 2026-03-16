import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/core/network/connectivity_service.dart';
import 'package:hesabat/data/local/sync/in_memory_sync_queue_repository.dart';
import 'package:hesabat/domain/entities/sync_pull_failure.dart';
import 'package:hesabat/domain/usecases/run_pull_cycle.dart';

void main() {
  test('skips pull when offline', () async {
    final repo = InMemorySyncQueueRepository();
    final connectivity = ConnectivityService(
      checkConnectivity: () async => [ConnectivityResult.none],
    );

    final usecase = RunPullCycle(repo, connectivity);

    final result = await usecase(
      shopId: 'shop-1',
      fetchRows: ({
        required table,
        required shopId,
        required since,
        required timestampColumn,
        required limit,
      }) async {
        fail('fetch should not run when offline');
      },
    );

    expect(result.outcome, PullCycleOutcome.skippedOffline);
    expect(result.pulledRows, 0);
  });

  test('updates lastPulledAt using latest timestamp across tables', () async {
    final repo = InMemorySyncQueueRepository();
    final connectivity = ConnectivityService(
      checkConnectivity: () async => [ConnectivityResult.wifi],
    );

    final usecase = RunPullCycle(repo, connectivity);

    final result = await usecase(
      shopId: 'shop-1',
      specs: const [
        PullSpec(table: 'products'),
        PullSpec(table: 'customers'),
      ],
      fetchRows: ({
        required table,
        required shopId,
        required since,
        required timestampColumn,
        required limit,
      }) async {
        if (table == 'products') {
          return [
            {
              'id': 'p1',
              'updated_at': '2026-03-10T10:00:00Z',
            },
          ];
        }

        return [
          {
            'id': 'c1',
            'updated_at': '2026-03-11T10:00:00Z',
          },
        ];
      },
    );

    expect(result.outcome, PullCycleOutcome.completed);
    expect(result.pulledRows, 2);

    final checkpoint = await repo.getCheckpoint();
    expect(checkpoint.lastPulledAt, DateTime.parse('2026-03-11T10:00:00Z'));
  });

  test('returns conflict outcome when pulled rows include conflict marker', () async {
    final repo = InMemorySyncQueueRepository();
    final connectivity = ConnectivityService(
      checkConnectivity: () async => [ConnectivityResult.mobile],
    );

    final usecase = RunPullCycle(repo, connectivity);

    final result = await usecase(
      shopId: 'shop-1',
      specs: const [PullSpec(table: 'products')],
      fetchRows: ({
        required table,
        required shopId,
        required since,
        required timestampColumn,
        required limit,
      }) async {
        return [
          {
            'id': 'p1',
            'updated_at': '2026-03-12T10:00:00Z',
            '_sync_conflict': true,
          },
        ];
      },
    );

    expect(result.outcome, PullCycleOutcome.conflict);
    expect(result.conflictRows, 1);
  });

  test('returns blockedAuth when fetch fails with auth block', () async {
    final repo = InMemorySyncQueueRepository();
    final connectivity = ConnectivityService(
      checkConnectivity: () async => [ConnectivityResult.wifi],
    );

    final usecase = RunPullCycle(repo, connectivity);

    final result = await usecase(
      shopId: 'shop-1',
      specs: const [PullSpec(table: 'products')],
      fetchRows: ({
        required table,
        required shopId,
        required since,
        required timestampColumn,
        required limit,
      }) async {
        throw const SyncPullException(
          type: SyncPullFailureType.blockedAuth,
          message: 'expired token',
        );
      },
    );

    expect(result.outcome, PullCycleOutcome.blockedAuth);
  });

  test('uses applyRows callback conflict counts when provided', () async {
    final repo = InMemorySyncQueueRepository();
    final connectivity = ConnectivityService(
      checkConnectivity: () async => [ConnectivityResult.wifi],
    );

    final usecase = RunPullCycle(repo, connectivity);

    final result = await usecase(
      shopId: 'shop-1',
      specs: const [PullSpec(table: 'products')],
      fetchRows: ({
        required table,
        required shopId,
        required since,
        required timestampColumn,
        required limit,
      }) async {
        return [
          {
            'id': 'p1',
            'updated_at': '2026-03-12T10:00:00Z',
          },
        ];
      },
      applyRows: ({
        required table,
        required rows,
        required timestampColumn,
      }) async {
        return const PullApplyResult(appliedRows: 0, conflictRows: 1);
      },
    );

    expect(result.conflictRows, 1);
    expect(result.outcome, PullCycleOutcome.conflict);
  });
}
