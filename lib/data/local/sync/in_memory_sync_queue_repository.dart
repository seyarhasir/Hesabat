import '../../../domain/entities/sync_checkpoint.dart';
import '../../../domain/entities/sync_queue_item.dart';
import '../../../domain/repositories/sync_queue_repository.dart';

class InMemorySyncQueueRepository implements SyncQueueRepository {
  final List<SyncQueueItem> _items = [];
  SyncCheckpoint _checkpoint = const SyncCheckpoint();

  @override
  Future<void> enqueue(SyncQueueItem item) async {
    _items.add(item);
    _items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  Future<List<SyncQueueItem>> getPending({int limit = 100}) async {
    final pending = _items.where((e) => e.lastError != '__SUCCESS__').toList();
    pending.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    if (pending.length <= limit) return pending;
    return pending.sublist(0, limit);
  }

  @override
  Future<void> markAttempt({required String opId, required String error}) async {
    final index = _items.indexWhere((e) => e.opId == opId);
    if (index < 0) return;

    final current = _items[index];
    _items[index] = current.copyWith(
      attemptCount: current.attemptCount + 1,
      lastError: error,
    );
  }

  @override
  Future<void> markSuccess({required String opId}) async {
    final index = _items.indexWhere((e) => e.opId == opId);
    if (index < 0) return;

    final current = _items[index];
    _items[index] = current.copyWith(lastError: '__SUCCESS__');
  }

  @override
  Future<SyncCheckpoint> getCheckpoint() async {
    return _checkpoint;
  }

  @override
  Future<void> setCheckpoint(SyncCheckpoint checkpoint) async {
    _checkpoint = checkpoint;
  }
}
