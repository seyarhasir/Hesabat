import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/network_providers.dart';
import '../../core/storage/storage_providers.dart';
import '../../data/local/drift/app_database_provider.dart';
import '../../data/local/sync/drift_pull_materializer.dart';
import '../../data/local/sync/sync_queue_repository_provider.dart';
import '../../data/remote/supabase/supabase_client_provider.dart';
import '../../data/remote/supabase/sync/supabase_sync_pull_client.dart';
import '../../data/remote/supabase/sync/supabase_sync_push_client.dart';
import 'enqueue_sync_operation.dart';
import 'run_pull_cycle.dart';
import 'run_sync_cycle.dart';

final enqueueSyncOperationProvider = Provider<EnqueueSyncOperation>((ref) {
  final repo = ref.read(syncQueueRepositoryProvider);
  return EnqueueSyncOperation(repo);
});

final runSyncCycleProvider = Provider<RunSyncCycle>((ref) {
  final repo = ref.read(syncQueueRepositoryProvider);
  final connectivity = ref.read(connectivityServiceProvider);
  final retryPolicy = ref.read(retryPolicyProvider);
  return RunSyncCycle(repo, connectivity, retryPolicy);
});

final runPullCycleProvider = Provider<RunPullCycle>((ref) {
  final repo = ref.read(syncQueueRepositoryProvider);
  final connectivity = ref.read(connectivityServiceProvider);
  return RunPullCycle(repo, connectivity);
});

typedef RunPendingSync = Future<RunSyncCycleResult> Function({int batchLimit});
typedef RunPendingPull = Future<RunPullCycleResult> Function({
  int perTableLimit,
});

final runPendingSyncProvider = Provider<RunPendingSync>((ref) {
  final runSyncCycle = ref.read(runSyncCycleProvider);
  final localKv = ref.read(localKvStoreProvider);
  final supabase = ref.read(supabaseClientProvider);
  final pushClient = SupabaseSyncPushClient(supabase);

  return ({int batchLimit = 100}) async {
    final shopId = await localKv.readString('active_shop_id');
    if (shopId == null || shopId.isEmpty) {
      return const RunSyncCycleResult(
        processed: 0,
        succeeded: 0,
        failed: 0,
        outcome: SyncCycleOutcome.blockedAuth,
      );
    }

    return runSyncCycle(
      batchLimit: batchLimit,
      pushOperation: (item) => pushClient.pushOperation(
        shopId: shopId,
        item: item,
      ),
    );
  };
});

final runPendingPullProvider = Provider<RunPendingPull>((ref) {
  final runPullCycle = ref.read(runPullCycleProvider);
  final localKv = ref.read(localKvStoreProvider);
  final db = ref.read(appDatabaseProvider);
  final supabase = ref.read(supabaseClientProvider);
  final pullClient = SupabaseSyncPullClient(supabase);
  final materializer = DriftPullMaterializer(db);

  return ({int perTableLimit = 200}) async {
    final shopId = await localKv.readString('active_shop_id');
    if (shopId == null || shopId.isEmpty) {
      return const RunPullCycleResult(
        pulledRows: 0,
        conflictRows: 0,
        outcome: PullCycleOutcome.blockedAuth,
      );
    }

    return runPullCycle(
      shopId: shopId,
      perTableLimit: perTableLimit,
      fetchRows: ({
        required table,
        required shopId,
        required since,
        required timestampColumn,
        required limit,
      }) {
        return pullClient.fetchIncrementalRows(
          table: table,
          shopId: shopId,
          since: since,
          timestampColumn: timestampColumn,
          limit: limit,
        );
      },
      applyRows: ({
        required table,
        required rows,
        required timestampColumn,
      }) {
        return materializer.applyRows(
          table: table,
          rows: rows,
          timestampColumn: timestampColumn,
        );
      },
    );
  };
});
