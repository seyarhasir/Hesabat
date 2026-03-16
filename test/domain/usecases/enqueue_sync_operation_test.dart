import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/domain/entities/sync_checkpoint.dart';
import 'package:hesabat/domain/entities/sync_queue_item.dart';
import 'package:hesabat/domain/repositories/sync_queue_repository.dart';
import 'package:hesabat/domain/usecases/enqueue_sync_operation.dart';

class _FakeSyncQueueRepository implements SyncQueueRepository {
  final List<SyncQueueItem> items = [];

  @override
  Future<void> enqueue(SyncQueueItem item) async {
    items.add(item);
  }

  @override
  Future<List<SyncQueueItem>> getPending({int limit = 100}) async => items;

  @override
  Future<SyncCheckpoint> getCheckpoint() async => const SyncCheckpoint();

  @override
  Future<void> markAttempt({required String opId, required String error}) async {}

  @override
  Future<void> markSuccess({required String opId}) async {}

  @override
  Future<void> setCheckpoint(SyncCheckpoint checkpoint) async {}
}

void main() {
  test('creates queue item and enqueues it', () async {
    final fake = _FakeSyncQueueRepository();
    final usecase = EnqueueSyncOperation(fake);

    final result = await usecase(
      deviceId: 'dev-1',
      entityType: 'products',
      entityId: 'p-1',
      operation: SyncOperation.insert,
      payload: const {'name': 'Tea'},
    );

    expect(result.opId, isNotEmpty);
    expect(fake.items.length, 1);
    expect(fake.items.single.entityId, 'p-1');
  });
}
