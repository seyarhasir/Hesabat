enum SyncOperation {
  insert,
  update,
  delete,
}

class SyncQueueItem {
  final String opId;
  final String deviceId;
  final String entityType;
  final String entityId;
  final SyncOperation operation;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int attemptCount;
  final String? lastError;

  const SyncQueueItem({
    required this.opId,
    required this.deviceId,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.createdAt,
    this.attemptCount = 0,
    this.lastError,
  });

  SyncQueueItem copyWith({
    int? attemptCount,
    String? lastError,
  }) {
    return SyncQueueItem(
      opId: opId,
      deviceId: deviceId,
      entityType: entityType,
      entityId: entityId,
      operation: operation,
      payload: payload,
      createdAt: createdAt,
      attemptCount: attemptCount ?? this.attemptCount,
      lastError: lastError ?? this.lastError,
    );
  }
}
