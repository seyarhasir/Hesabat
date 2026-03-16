class SyncCheckpoint {
  final DateTime? lastPulledAt;
  final DateTime? lastPushedAt;

  const SyncCheckpoint({
    this.lastPulledAt,
    this.lastPushedAt,
  });

  SyncCheckpoint copyWith({
    DateTime? lastPulledAt,
    DateTime? lastPushedAt,
  }) {
    return SyncCheckpoint(
      lastPulledAt: lastPulledAt ?? this.lastPulledAt,
      lastPushedAt: lastPushedAt ?? this.lastPushedAt,
    );
  }
}
