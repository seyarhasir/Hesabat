import 'package:supabase_flutter/supabase_flutter.dart';

enum RelinkStatus {
  linked,
  alreadyLinked,
  notFound,
  inactiveAccount,
  forbidden,
  error,
}

class RelinkResult {
  final RelinkStatus status;
  final String? shopId;

  const RelinkResult({
    required this.status,
    this.shopId,
  });
}

RelinkResult parseRelinkResponse(Object? result) {
  if (result == null) {
    return const RelinkResult(status: RelinkStatus.notFound);
  }

  if (result is String) {
    if (result.isNotEmpty) {
      return RelinkResult(status: RelinkStatus.linked, shopId: result);
    }
    return const RelinkResult(status: RelinkStatus.notFound);
  }

  if (result is Map) {
    final map = result.map((k, v) => MapEntry(k.toString(), v));
    final statusRaw = map['status']?.toString();
    final shopId = map['shop_id']?.toString();

    switch (statusRaw) {
      case 'linked':
        return RelinkResult(status: RelinkStatus.linked, shopId: shopId);
      case 'already_linked':
        return RelinkResult(status: RelinkStatus.alreadyLinked, shopId: shopId);
      case 'not_found':
        return const RelinkResult(status: RelinkStatus.notFound);
      case 'inactive_account':
        return const RelinkResult(status: RelinkStatus.inactiveAccount);
      case 'forbidden':
        return const RelinkResult(status: RelinkStatus.forbidden);
      case 'error':
        return const RelinkResult(status: RelinkStatus.error);
      default:
        return const RelinkResult(status: RelinkStatus.error);
    }
  }

  return const RelinkResult(status: RelinkStatus.error);
}

class AuthRpcClient {
  AuthRpcClient(this._supabase);

  final SupabaseClient _supabase;

  Future<bool> adminAccountExists(String phone) async {
    final result = await _supabase.rpc(
      'admin_account_exists',
      params: {'p_phone': phone},
    );

    return result == true;
  }

  Future<void> markFirstLogin(String phone) async {
    await _supabase.rpc(
      'mark_first_login',
      params: {'p_phone': phone},
    );
  }

  Future<bool> verifyPasscode({
    required String phone,
    required String passcode,
  }) async {
    final result = await _supabase.rpc(
      'verify_admin_passcode',
      params: {
        'p_phone': phone,
        'p_passcode': passcode,
      },
    );

    return result == true;
  }

  Future<RelinkResult> relinkShopByPhone(String phone) async {
    final result = await _supabase.rpc(
      'relink_shop_by_phone',
      params: {'p_phone': phone},
    );

    return parseRelinkResponse(result);
  }

  Future<String?> fetchShopContextByOwner() async {
    final data = await _supabase.rpc('fetch_shop_context');
    if (data is! Map) return null;

    final id = data['shop_id']?.toString();
    if (id == null || id.isEmpty) return null;

    return id;
  }

  Future<void> registerDevice({
    required String shopId,
    required String deviceId,
    required String platform,
    String? appVersion,
  }) async {
    final nowIso = DateTime.now().toIso8601String();
    await _supabase.from('devices').upsert(
      {
        'shop_id': shopId,
        'device_id': deviceId,
        'platform': platform,
        'app_version': appVersion,
        'is_active': true,
        'last_seen_at': nowIso,
        'updated_at': nowIso,
      },
      onConflict: 'shop_id,device_id',
    );
  }
}
