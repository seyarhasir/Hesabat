import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../domain/entities/sync_pull_failure.dart';

class SupabaseSyncPullClient {
  final SupabaseClient _supabase;

  const SupabaseSyncPullClient(this._supabase);

  Future<List<Map<String, dynamic>>> fetchIncrementalRows({
    required String table,
    required String shopId,
    DateTime? since,
    String timestampColumn = 'updated_at',
    int limit = 200,
  }) async {
    try {
      var query = _supabase
          .from(table)
          .select()
          .eq('shop_id', shopId);

      if (since != null) {
        query = query.gt(timestampColumn, since.toIso8601String());
      }

      final rows = await query
          .order(timestampColumn, ascending: true)
          .limit(limit);
      return rows;
    } on PostgrestException catch (e) {
      throw _classifyPostgrestError(e);
    } on AuthException {
      throw const SyncPullException(
        type: SyncPullFailureType.blockedAuth,
        message: 'Sync pull blocked due to authentication failure.',
      );
    } catch (e) {
      throw SyncPullException(
        type: SyncPullFailureType.retryable,
        message: e.toString(),
      );
    }
  }

  SyncPullException _classifyPostgrestError(PostgrestException e) {
    final code = (e.code ?? '').toLowerCase();
    final details = (e.details ?? '').toString().toLowerCase();
    final message = e.message.toLowerCase();
    final joined = '$code $details $message';

    if (_containsAny(joined, ['jwt', 'token', 'unauth', '401', 'auth'])) {
      return const SyncPullException(
        type: SyncPullFailureType.blockedAuth,
        message: 'Sync pull blocked due to authentication failure.',
      );
    }

    if (_containsAny(joined, ['42501', 'permission', 'rls', 'policy', 'forbidden'])) {
      return const SyncPullException(
        type: SyncPullFailureType.blockedRls,
        message: 'Sync pull blocked due to row-level security permissions.',
      );
    }

    if (_containsAny(joined, ['22p02'])) {
      return SyncPullException(
        type: SyncPullFailureType.fatal,
        message: e.message,
      );
    }

    return SyncPullException(
      type: SyncPullFailureType.retryable,
      message: e.message,
    );
  }

  bool _containsAny(String text, List<String> parts) {
    for (final part in parts) {
      if (text.contains(part)) return true;
    }
    return false;
  }
}
