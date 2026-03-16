import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/auth/guest_mode_service.dart';
import '../../core/settings/shop_profile_service.dart';
import '../../core/storage/local_kv_store.dart';
import '../../core/storage/secure_store.dart';
import '../../domain/entities/auth_flow_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../remote/supabase/rpc/auth_rpc_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  static const _shopIdKey = 'active_shop_id';
  static const _phoneKey = 'active_phone';
  static const _deviceIdKey = 'active_device_id';

  final SupabaseClient _supabase;
  final AuthRpcClient _rpc;
  final SecureStore _secureStore;
  final LocalKvStore _localKvStore;

  AuthRepositoryImpl({
    required SupabaseClient supabase,
    required AuthRpcClient rpc,
    required SecureStore secureStore,
    required LocalKvStore localKvStore,
  })  : _supabase = supabase,
        _rpc = rpc,
        _secureStore = secureStore,
        _localKvStore = localKvStore;

  @override
  Future<AuthFlowResult> signInWithPasscode({
    required String phone,
    required String passcode,
  }) async {
    final normalizedPhone = _normalizePhone(phone);

    final verified = await _rpc.verifyPasscode(
      phone: normalizedPhone,
      passcode: passcode,
    );

    if (!verified) {
      return const AuthFlowResult.failure(
        AuthFailure(
          type: AuthFailureType.invalidPasscode,
          message: 'Passcode verification failed.',
        ),
      );
    }

    final email = _emailFromPhone(normalizedPhone);

    final sessionError = await _establishSession(
      email: email,
      normalizedPhone: normalizedPhone,
      passcode: passcode,
    );

    if (_supabase.auth.currentSession == null) {
      return AuthFlowResult.failure(
        AuthFailure(
          type: AuthFailureType.unknown,
          message: sessionError ??
              'Could not establish authenticated session. Ensure Supabase Auth email confirmation is disabled and auth user password matches the passcode.',
        ),
      );
    }

    final relink = await _rpc.relinkShopByPhone(normalizedPhone);

    switch (relink.status) {
      case RelinkStatus.linked:
      case RelinkStatus.alreadyLinked:
        break;
      case RelinkStatus.notFound:
        return const AuthFlowResult.failure(
          AuthFailure(
            type: AuthFailureType.accountNotFound,
            message: 'No admin account found for this phone.',
          ),
        );
      case RelinkStatus.inactiveAccount:
        return const AuthFlowResult.failure(
          AuthFailure(
            type: AuthFailureType.inactiveAccount,
            message: 'Account is inactive. Contact support.',
          ),
        );
      case RelinkStatus.forbidden:
        return const AuthFlowResult.failure(
          AuthFailure(
            type: AuthFailureType.relinkFailed,
            message: 'Relink is forbidden for current session.',
          ),
        );
      case RelinkStatus.error:
        return const AuthFlowResult.failure(
          AuthFailure(
            type: AuthFailureType.relinkFailed,
            message: 'Relink failed due to unexpected server response.',
          ),
        );
    }

    await _rpc.markFirstLogin(normalizedPhone);

    final shopId = relink.shopId ?? await _rpc.fetchShopContextByOwner();
    if (shopId == null) {
      return const AuthFlowResult.failure(
        AuthFailure(
          type: AuthFailureType.missingShopContext,
          message: 'Authenticated but no shop context found.',
        ),
      );
    }

    final deviceId = await _getOrCreateDeviceId();
    await _rpc.registerDevice(
      shopId: shopId,
      deviceId: deviceId,
      platform: _platformName(),
      appVersion: null,
    );

    await _secureStore.write(_phoneKey, normalizedPhone);
    await _localKvStore.writeString(_deviceIdKey, deviceId);
    await _localKvStore.writeString(_shopIdKey, shopId);
    await GuestModeService.deactivateGuestMode();

    try {
      await ShopProfileService.fetchByShopId(_supabase, shopId);
    } catch (_) {
      // Non-fatal; settings screen will attempt fallback fetch.
    }

    return AuthFlowResult.success(shopId: shopId);
  }

  @override
  Future<void> atomicSignOut() async {
    await _supabase.auth.signOut();
    await _secureStore.clear();
    await _localKvStore.remove(_shopIdKey);
  }

  String _emailFromPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return 'acct_$digits@hesabat.app';
  }

  String _normalizePhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('93') && digits.length == 12) return '+$digits';
    if (digits.startsWith('0') && digits.length == 10) {
      return '+93${digits.substring(1)}';
    }
    if (digits.startsWith('7') && digits.length == 9) return '+93$digits';
    return raw.trim();
  }

  Future<String> _getOrCreateDeviceId() async {
    final existing = await _localKvStore.readString(_deviceIdKey);
    if (existing != null && existing.isNotEmpty) return existing;

    final created = const Uuid().v4();
    await _localKvStore.writeString(_deviceIdKey, created);
    return created;
  }

  String _platformName() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return 'desktop';
      case TargetPlatform.fuchsia:
        return 'unknown';
    }
  }

  Future<String?> _establishSession({
    required String email,
    required String normalizedPhone,
    required String passcode,
  }) async {
    final candidates = <String>{
      _authPassword(normalizedPhone, passcode),
      passcode,
    };
    String? lastError;

    for (final password in candidates) {
      try {
        await _supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
      } on AuthException catch (e) {
        lastError = e.message;
        try {
          await _supabase.auth.signUp(
            email: email,
            password: password,
            data: {'phone': normalizedPhone},
          );
        } on AuthException catch (e2) {
          lastError = e2.message;
          // Try next candidate.
        } catch (e2) {
          lastError = e2.toString();
          // Try next candidate.
        }
      } catch (e) {
        lastError = e.toString();
      }

      if (_supabase.auth.currentSession != null) {
        return null;
      }
    }

    return lastError;
  }

  String _authPassword(String normalizedPhone, String passcode) {
    final digits = normalizedPhone.replaceAll(RegExp(r'\D'), '');
    return 'hsb_${digits}_$passcode';
  }
}
