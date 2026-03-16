import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../network/connectivity_service.dart';
import 'sync_service.dart';

enum SyncUiStatus { idle, syncing, offline, error, conflict }

class SyncState {
  final SyncUiStatus status;
  final int pendingCount;
  final int conflictCount;
  final int processed;
  final int total;
  final String? errorMessage;

  const SyncState({
    this.status = SyncUiStatus.idle,
    this.pendingCount = 0,
    this.conflictCount = 0,
    this.processed = 0,
    this.total = 0,
    this.errorMessage,
  });

  SyncState copyWith({
    SyncUiStatus? status,
    int? pendingCount,
    int? conflictCount,
    int? processed,
    int? total,
    String? errorMessage,
  }) {
    return SyncState(
      status: status ?? this.status,
      pendingCount: pendingCount ?? this.pendingCount,
      conflictCount: conflictCount ?? this.conflictCount,
      processed: processed ?? this.processed,
      total: total ?? this.total,
      errorMessage: errorMessage,
    );
  }
}

class SyncNotifier extends StateNotifier<SyncState> {
  SyncNotifier(this._service) : super(const SyncState());

  final SyncService _service;

  StreamSubscription<bool>? _connectivitySub;
  Timer? _pollTimer;
  Timer? _retryTimer;
  int _retryStep = 0;

  static const _retryDurations = [
    Duration(seconds: 30),
    Duration(minutes: 2),
    Duration(minutes: 10),
    Duration(hours: 1),
  ];

  Future<void> initialize() async {
    await _refreshPending();

    if (ConnectivityService.instance.isOnline) {
      await syncNow(force: true);
    }

    _connectivitySub = ConnectivityService.instance.onlineStream.listen((online) async {
      if (online) {
        await syncNow(force: true);
      } else {
        state = state.copyWith(status: SyncUiStatus.offline);
      }
    });

    _pollTimer = Timer.periodic(const Duration(seconds: 20), (_) async {
      await _refreshPending();
      if (ConnectivityService.instance.isOnline && state.pendingCount > 0 && state.status != SyncUiStatus.syncing) {
        await syncNow(force: true);
      }
    });
  }

  Future<void> _refreshPending() async {
    final count = await _service.pendingCount();
    final conflicts = await _service.conflictCount();

    final status = !ConnectivityService.instance.isOnline
        ? SyncUiStatus.offline
        : conflicts > 0
            ? SyncUiStatus.conflict
            : (count > 0 ? state.status : SyncUiStatus.idle);

    state = state.copyWith(
      pendingCount: count,
      conflictCount: conflicts,
      status: status,
    );
  }

  Future<void> syncNow({bool force = false}) async {
    if (!ConnectivityService.instance.isOnline) {
      state = state.copyWith(status: SyncUiStatus.offline);
      return;
    }

    if (!force && state.status == SyncUiStatus.syncing) return;

    state = state.copyWith(status: SyncUiStatus.syncing, processed: 0, total: 0, errorMessage: null);

    try {
      await _service.syncPending(
        batchSize: 500,
        onProgress: (p) {
          state = state.copyWith(processed: p.processed, total: p.total);
        },
      );

      await _service.pullFromCloud();

      _retryStep = 0;
      _retryTimer?.cancel();
      await _refreshPending();
      state = state.copyWith(status: state.conflictCount > 0 ? SyncUiStatus.conflict : SyncUiStatus.idle);
    } catch (e) {
      final message = e.toString();
      final isConflict = message.toLowerCase().contains('conflict');
      state = state.copyWith(
        status: isConflict ? SyncUiStatus.conflict : SyncUiStatus.error,
        errorMessage: message,
      );
      _scheduleRetry();
    }
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    final idx = _retryStep < _retryDurations.length ? _retryStep : _retryDurations.length - 1;
    final delay = _retryDurations[idx];
    _retryStep++;

    _retryTimer = Timer(delay, () {
      syncNow(force: true);
    });
  }

  Future<List<SyncQueueItem>> loadConflicts() {
    return _service.getUnresolvedConflicts();
  }

  Future<List<SyncConflictDetails>> loadConflictDetails() {
    return _service.getUnresolvedConflictDetails();
  }

  Future<void> resolveConflict(String queueId, ConflictResolutionChoice choice) async {
    await _service.resolveConflict(queueId: queueId, choice: choice);
    await _refreshPending();
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _pollTimer?.cancel();
    _retryTimer?.cancel();
    super.dispose();
  }
}

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  final notifier = SyncNotifier(SyncService.instance);
  unawaited(notifier.initialize());
  return notifier;
});
