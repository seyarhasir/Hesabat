import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../domain/entities/sync_push_failure.dart';
import '../../../../domain/entities/sync_queue_item.dart';

class SupabaseSyncPushClient {
  final SupabaseClient _supabase;

  const SupabaseSyncPushClient(this._supabase);

  Future<void> pushOperation({
    required String shopId,
    required SyncQueueItem item,
  }) async {
    try {
      await _applyEntityMutation(shopId: shopId, item: item);
      await _logResult(
        shopId: shopId,
        item: item,
        status: 'success',
        message: null,
      );
    } on PostgrestException catch (e) {
      final classified = _classifyPostgrestError(e);
      await _logResult(
        shopId: shopId,
        item: item,
        status: 'failed',
        message: classified.message,
      );
      throw classified;
    } on AuthException catch (e) {
      const type = SyncPushFailureType.blockedAuth;
      final message = 'Auth failure while pushing sync operation.';
      await _logResult(
        shopId: shopId,
        item: item,
        status: 'failed',
        message: e.message,
      );
      throw SyncPushException(type: type, message: message);
    } catch (e) {
      await _logResult(
        shopId: shopId,
        item: item,
        status: 'failed',
        message: e.toString(),
      );
      throw SyncPushException(
        type: SyncPushFailureType.retryable,
        message: e.toString(),
      );
    }
  }

  Future<void> _applyEntityMutation({
    required String shopId,
    required SyncQueueItem item,
  }) async {
    final table = _tableFor(item.entityType);

    if (item.operation == SyncOperation.delete) {
      await _supabase
          .from(table)
          .delete()
          .eq('id', item.entityId)
          .eq('shop_id', shopId);
      return;
    }

    final payload = <String, dynamic>{...item.payload};
    payload['id'] = payload['id'] ?? item.entityId;
    payload['shop_id'] = payload['shop_id'] ?? shopId;

    await _supabase.from(table).upsert(payload);
  }

  String _tableFor(String entityType) {
    switch (entityType) {
      case 'products':
      case 'product':
        return 'products';
      case 'customers':
      case 'customer':
        return 'customers';
      case 'sales':
      case 'sale':
        return 'sales';
      case 'sale_items':
      case 'sale_item':
        return 'sale_items';
      case 'debts':
      case 'debt':
        return 'debts';
      case 'debt_payments':
      case 'debt_payment':
        return 'debt_payments';
      default:
        throw SyncPushException(
          type: SyncPushFailureType.fatal,
          message: 'Unsupported entity type: $entityType',
        );
    }
  }

  SyncPushException _classifyPostgrestError(PostgrestException e) {
    final code = (e.code ?? '').toLowerCase();
    final details = (e.details ?? '').toString().toLowerCase();
    final message = (e.message).toLowerCase();
    final joined = '$code $details $message';

    if (_containsAny(joined, ['jwt', 'token', 'unauth', '401', 'auth'])) {
      return const SyncPushException(
        type: SyncPushFailureType.blockedAuth,
        message: 'Sync blocked due to authentication failure.',
      );
    }

    if (_containsAny(joined, ['42501', 'permission', 'rls', 'policy', 'forbidden'])) {
      return const SyncPushException(
        type: SyncPushFailureType.blockedRls,
        message: 'Sync blocked due to row-level security permissions.',
      );
    }

    if (_containsAny(joined, ['23505', '22p02', '23503', '23514'])) {
      return SyncPushException(
        type: SyncPushFailureType.fatal,
        message: e.message,
      );
    }

    return SyncPushException(
      type: SyncPushFailureType.retryable,
      message: e.message,
    );
  }

  bool _containsAny(String text, List<String> parts) {
    for (final part in parts) {
      if (text.contains(part)) return true;
    }
    return false;
  }

  Future<void> _logResult({
    required String shopId,
    required SyncQueueItem item,
    required String status,
    required String? message,
  }) async {
    try {
      await _supabase.from('sync_audit_logs').insert({
        'shop_id': shopId,
        'device_id': item.deviceId,
        'op_id': item.opId,
        'entity_type': item.entityType,
        'entity_id': item.entityId,
        'operation': item.operation.name,
        'status': status,
        'message': message,
        'metadata': {
          'attempt_count': item.attemptCount,
          'created_at_local': item.createdAt.toIso8601String(),
        },
      });
    } catch (_) {
      // Audit logging should not block sync operation flow.
    }
  }
}
