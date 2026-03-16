enum SyncPushFailureType {
  retryable,
  blockedAuth,
  blockedRls,
  fatal,
}

class SyncPushException implements Exception {
  final SyncPushFailureType type;
  final String message;

  const SyncPushException({
    required this.type,
    required this.message,
  });

  @override
  String toString() => 'SyncPushException(type: $type, message: $message)';
}
