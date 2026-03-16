import 'dart:math';

class RetryPolicy {
  final int maxAttempts;
  final Duration baseDelay;

  const RetryPolicy({
    this.maxAttempts = 3,
    this.baseDelay = const Duration(milliseconds: 300),
  });

  Duration backoffDelay(int attempt) {
    final exp = pow(2, attempt.clamp(0, 10));
    final jitterMs = Random().nextInt(200);
    return Duration(milliseconds: (baseDelay.inMilliseconds * exp).toInt() + jitterMs);
  }
}
