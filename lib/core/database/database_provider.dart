import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

/// Single database instance shared across the app
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Convenience provider for the current shop ID.
/// In guest mode this returns a fixed demo shop ID.
/// When authenticated, this should be set from the user's actual shop.
final currentShopIdProvider = StateProvider<String>((ref) {
  return 'demo_shop';
});
