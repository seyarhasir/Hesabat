import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/data/local/drift/app_database.dart';
import 'package:hesabat/data/local/sync/drift_sync_queue_repository.dart';
import 'package:hesabat/domain/entities/sync_checkpoint.dart';
import 'package:hesabat/domain/entities/sync_queue_item.dart';

void main() {
  late AppDatabase db;
  late DriftSyncQueueRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = DriftSyncQueueRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('enqueue + getPending returns stored operations ordered by time', () async {
    final older = SyncQueueItem(
      opId: 'op-1',
      deviceId: 'device-1',
      entityType: 'sale',
      entityId: 's-1',
      operation: SyncOperation.insert,
      payload: const {'k': 'v1'},
      createdAt: DateTime.utc(2025, 1, 1, 10),
    );

    final newer = SyncQueueItem(
      opId: 'op-2',
      deviceId: 'device-1',
      entityType: 'sale',
      entityId: 's-2',
      operation: SyncOperation.update,
      payload: const {'k': 'v2'},
      createdAt: DateTime.utc(2025, 1, 1, 11),
    );

    await repository.enqueue(newer);
    await repository.enqueue(older);

    final pending = await repository.getPending();

    expect(pending.length, 2);
    expect(pending.first.opId, 'op-1');
    expect(pending.last.opId, 'op-2');
    expect(pending.first.payload['k'], 'v1');
    expect(pending.last.operation, SyncOperation.update);
  });

  test('markAttempt increments counter and stores error', () async {
    final item = SyncQueueItem(
      opId: 'op-3',
      deviceId: 'device-1',
      entityType: 'customer',
      entityId: 'c-1',
      operation: SyncOperation.insert,
      payload: const {'name': 'A'},
      createdAt: DateTime.utc(2025, 1, 2),
    );

    await repository.enqueue(item);
    await repository.markAttempt(opId: 'op-3', error: 'network timeout');

    final pending = await repository.getPending();
    expect(pending.single.attemptCount, 1);
    expect(pending.single.lastError, 'network timeout');
  });

  test('markSuccess removes item from pending list', () async {
    final item = SyncQueueItem(
      opId: 'op-4',
      deviceId: 'device-1',
      entityType: 'inventory',
      entityId: 'i-1',
      operation: SyncOperation.delete,
      payload: const {'id': 'i-1'},
      createdAt: DateTime.utc(2025, 1, 3),
    );

    await repository.enqueue(item);
    await repository.markSuccess(opId: 'op-4');

    final pending = await repository.getPending();
    expect(pending, isEmpty);
  });

  test('checkpoint roundtrip persists latest values', () async {
    const empty = SyncCheckpoint();
    final initial = await repository.getCheckpoint();
    expect(initial, empty);

    final checkpoint = SyncCheckpoint(
      lastPulledAt: DateTime.utc(2025, 2, 1),
      lastPushedAt: DateTime.utc(2025, 2, 2),
    );

    await repository.setCheckpoint(checkpoint);

    final loaded = await repository.getCheckpoint();
    expect(
      loaded.lastPulledAt!.isAtSameMomentAs(checkpoint.lastPulledAt!),
      isTrue,
    );
    expect(
      loaded.lastPushedAt!.isAtSameMomentAs(checkpoint.lastPushedAt!),
      isTrue,
    );
  });
}
