import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/repositories/sync_queue_repository.dart';
import '../drift/app_database_provider.dart';
import 'drift_sync_queue_repository.dart';

final syncQueueRepositoryProvider = Provider<SyncQueueRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftSyncQueueRepository(db);
});
