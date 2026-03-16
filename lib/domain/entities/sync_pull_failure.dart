enum SyncPullFailureType {
  retryable,
  blockedAuth,
  blockedRls,
  fatal,
}

class SyncPullException implements Exception {
  final SyncPullFailureType type;
  final String message;

  const SyncPullException({
    required this.type,
    required this.message,
  });

  @override
  String toString() => 'SyncPullException(type: $type, message: $message)';
}
