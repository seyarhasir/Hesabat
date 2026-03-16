import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';
import '../sync/sync_service.dart';

/// Single database instance shared across the app
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();

  // Initialize local DB bootstrap tasks and wire sync service to this DB instance.
  unawaited(db.initializeDatabase());
  unawaited(SyncService.instance.initialize(db));

  ref.onDispose(() => db.close());
  return db;
});

/// Convenience provider for the current shop ID.
/// In guest mode this returns a fixed demo shop ID.
/// When authenticated, this should be set from the user's actual shop.
final currentShopIdProvider = StateProvider<String>((ref) {
  return 'demo_shop';
});
