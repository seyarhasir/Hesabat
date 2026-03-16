import '../entities/sync_checkpoint.dart';
import '../entities/sync_queue_item.dart';

abstract class SyncQueueRepository {
  Future<void> enqueue(SyncQueueItem item);

  Future<List<SyncQueueItem>> getPending({
    int limit = 100,
  });

  Future<void> markAttempt({
    required String opId,
    required String error,
  });

  Future<void> markSuccess({
    required String opId,
  });

  Future<SyncCheckpoint> getCheckpoint();

  Future<void> setCheckpoint(SyncCheckpoint checkpoint);
}
