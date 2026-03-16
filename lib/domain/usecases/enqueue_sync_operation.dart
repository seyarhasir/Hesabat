import 'package:uuid/uuid.dart';

import '../entities/sync_queue_item.dart';
import '../repositories/sync_queue_repository.dart';

class EnqueueSyncOperation {
  final SyncQueueRepository _repository;

  const EnqueueSyncOperation(this._repository);

  Future<SyncQueueItem> call({
    required String deviceId,
    required String entityType,
    required String entityId,
    required SyncOperation operation,
    required Map<String, dynamic> payload,
  }) async {
    final item = SyncQueueItem(
      opId: const Uuid().v4(),
      deviceId: deviceId,
      entityType: entityType,
      entityId: entityId,
      operation: operation,
      payload: payload,
      createdAt: DateTime.now().toUtc(),
    );

    await _repository.enqueue(item);
    return item;
  }
}
