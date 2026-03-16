import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/data/local/sync/in_memory_sync_queue_repository.dart';
import 'package:hesabat/domain/entities/sync_queue_item.dart';

void main() {
  test('enqueue keeps FIFO order by createdAt', () async {
    final repo = InMemorySyncQueueRepository();

    final older = SyncQueueItem(
      opId: '1',
      deviceId: 'd1',
      entityType: 'products',
      entityId: 'p1',
      operation: SyncOperation.insert,
      payload: const {'x': 1},
      createdAt: DateTime.utc(2025, 1, 1, 10),
    );

    final newer = SyncQueueItem(
      opId: '2',
      deviceId: 'd1',
      entityType: 'products',
      entityId: 'p2',
      operation: SyncOperation.insert,
      payload: const {'x': 2},
      createdAt: DateTime.utc(2025, 1, 1, 11),
    );

    await repo.enqueue(newer);
    await repo.enqueue(older);

    final pending = await repo.getPending();
    expect(pending.map((e) => e.opId).toList(), ['1', '2']);
  });

  test('markAttempt increments count and stores error', () async {
    final repo = InMemorySyncQueueRepository();

    final item = SyncQueueItem(
      opId: '1',
      deviceId: 'd1',
      entityType: 'sales',
      entityId: 's1',
      operation: SyncOperation.update,
      payload: const {'a': 1},
      createdAt: DateTime.utc(2025, 1, 1),
    );

    await repo.enqueue(item);
    await repo.markAttempt(opId: '1', error: 'network');

    final pending = await repo.getPending();
    expect(pending.single.attemptCount, 1);
    expect(pending.single.lastError, 'network');
  });
}
