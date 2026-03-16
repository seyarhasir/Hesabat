import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'guest_mode_service.dart';
import '../settings/shop_profile_service.dart';

/// Authentication modes
enum AuthMode {
  guest,      // Demo mode - local only
  authenticated, // Full access - Supabase user
}

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'supabase_token';
  static const _refreshTokenKey = 'supabase_refresh_token';
  static const _localAuthPhoneKey = 'local_auth_phone';
  
  final SupabaseClient _supabase;
  
  AuthService(this._supabase);
  
  /// Get current auth mode
  Future<AuthMode> getCurrentMode() async {
    // Check if guest mode is active
    if (await GuestModeService.isGuestMode()) {
      return AuthMode.guest;
    }
    
    // Check if we have a valid Supabase session
    final session = _supabase.auth.currentSession;
    if (session != null) {
      return AuthMode.authenticated;
    }

    // Try to restore from storage
    final token = await _storage.read(key: _tokenKey);
    if (token != null) {
      try {
        await _supabase.auth.recoverSession(token);
        return AuthMode.authenticated;
      } catch (e) {
        await clearAuth();
      }
    }
    
    return AuthMode.guest; // Default to guest if nothing found
  }
  
  /// Sign in with phone and WhatsApp OTP (production mode)
  Future<bool> signInWithPhone(String phone) async {
    final candidates = _phoneCandidates(phone);

    // Step 1: ensure account exists and is active.
    // If the edge function is not deployed yet (404), allow moving to passcode step
    // and validate there via RPC fallback.
    try {
      final otpResponse = await _supabase.functions.invoke(
        'whatsapp-otp',
        body: {
          'action': 'prepare_login',
          'phone': candidates.first,
        },
      );

      final data = otpResponse.data;
      final success = data is Map ? data['success'] == true : false;
      if (otpResponse.status != 200 || !success) {
        final msg = data is Map && data['error'] != null
            ? data['error'].toString()
            : 'Account not found. Contact sales agent.';
        throw Exception(msg);
      }
    } on FunctionException catch (e) {
      // 404 means function is missing in current Supabase project.
      // We fall back to passcode verification RPC in the next step.
      if (e.status != 404) rethrow;
    }

    return true;
  }
  
  /// Verify WhatsApp OTP. Returns the shop profile if found, null otherwise.
  Future<ShopProfile?> verifyOtp(String phone, String otp) async {
    final candidates = _phoneCandidates(phone);
    final normalized = candidates.first;

    bool verified = false;

    try {
      final response = await _supabase.functions.invoke(
        'whatsapp-otp',
        body: {
          'action': 'verify_passcode',
          'phone': normalized,
          'passcode': otp,
        },
      );

      final data = response.data;
      verified = data is Map ? data['success'] == true : false;
      if (response.status != 200 || !verified) {
        // Fallback to DB verification even when function exists,
        // because function logic might be stale compared to current passcode flow.
        verified = await _verifyPasscodeViaRpc(candidates, otp);
        if (!verified) {
          final msg = data is Map && data['error'] != null
              ? data['error'].toString()
              : 'Invalid passcode';
          throw Exception(msg);
        }
      }
    } on FunctionException catch (e) {
      // Edge function missing: fallback to DB function verify_admin_passcode.
      if (e.status != 404) rethrow;
      verified = await _verifyPasscodeViaRpc(candidates, otp);
      if (!verified) {
        throw Exception('Invalid passcode');
      }
    }

    await _ensureSupabaseSession(normalized, otp);
    await _storage.write(key: _localAuthPhoneKey, value: normalized);

    // ISSUE-08 fix: Link admin_created_accounts → shop by looking up shop_id,
    // then update shops.owner_id so future queries by owner_id work.
    ShopProfile? profile;
    try {
      profile = await _linkAdminAccountAndFetchProfile(candidates);
    } catch (e) {
      print('HESABAT: Admin account link failed: $e');
    }

    // Fallback: try standard fetchFromCloud if admin link didn't find a profile
    if (profile == null) {
      try {
        profile = await ShopProfileService.fetchFromCloud(_supabase);
      } catch (e) {
        print('HESABAT: Profile restoration failed: $e');
      }
    }

    // Clear guest mode if active
    if (await GuestModeService.isGuestMode()) {
      await GuestModeService.deactivateGuestMode();
    }

    return profile;
  }

  /// ISSUE-08: Look up admin_created_accounts by phone to get shop_id,
  /// then update shops.owner_id to match the current auth user's UUID
  /// so all future queries by owner_id work correctly.
  Future<ShopProfile?> _linkAdminAccountAndFetchProfile(List<String> phoneCandidates) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    // Use the RPC which has SECURITY DEFINER to bypass RLS for admin table lookup
    // and correctly canonicalizes the phone number.
    for (final phone in phoneCandidates) {
      try {
        final relinkRes = await _supabase.rpc('relink_shop_by_phone', params: {
          'p_phone': phone,
        });

        if (relinkRes is Map && (relinkRes['status'] == 'linked' || relinkRes['status'] == 'already_linked')) {
          // Relink worked or was already done, fetch the profile
          return await ShopProfileService.fetchFromCloud(_supabase);
        }
      } catch (e) {
        print('HESABAT: Relink RPC failed for $phone: $e');
      }
    }

    return null;
  }

  Future<void> _ensureSupabaseSession(String normalizedPhone, String passcode) async {
    final existing = _supabase.auth.currentSession;
    if (existing != null) {
      await _storeSession();
      return;
    }

    final candidates = _phoneCandidates(normalizedPhone);
    final emails = _authEmailsFromPhoneCandidates(candidates);

    // 1) Try sign-in against all legacy/current email formats first.
    AuthException? lastSignInError;
    for (final email in emails) {
      try {
        await _supabase.auth.signInWithPassword(email: email, password: passcode);
        final signedInSession = _supabase.auth.currentSession;
        if (signedInSession != null) {
          await _storeSession();
          return;
        }
      } on AuthException catch (e) {
        lastSignInError = e;
      }
    }

    // 2) No existing account worked, create canonical cloud user.
    final primaryEmail = _emailFromPhone(normalizedPhone);
    try {
      final signUpRes = await _supabase.auth.signUp(
        email: primaryEmail,
        password: passcode,
        data: {'phone': normalizedPhone},
      );

      if (signUpRes.session != null) {
        await _storeSession();
        return;
      }

      // User was created but no session returned (usually email confirmation required).
      throw Exception('Cloud auth requires email confirmation. Disable Confirm email in Supabase Auth > Providers > Email, or confirm user $primaryEmail.');
    } on AuthException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('signups not allowed') || msg.contains('signup is disabled')) {
        throw Exception('Supabase Email sign-up is disabled. Enable Email provider signups in Auth settings.');
      }

      if (msg.contains('rate limit')) {
        throw Exception('Cloud auth failed: email rate limit exceeded. Create auth user $primaryEmail manually, then login again.');
      }

      if (msg.contains('already registered') || msg.contains('user already exists')) {
        throw Exception('Cloud user already exists for $primaryEmail with a different password. Delete that auth user and retry login.');
      }

      // Try one final sign-in in case signUp failed because user already exists.
      try {
        await _supabase.auth.signInWithPassword(email: primaryEmail, password: passcode);
      } on AuthException {
        final fallback = e.message.isNotEmpty
            ? e.message
            : (lastSignInError?.message ?? 'Unknown auth error');
        throw Exception('Cloud auth failed: $fallback');
      }
    }

    final session = _supabase.auth.currentSession;
    if (session == null) {
      throw Exception('Could not create cloud auth session. Please contact support.');
    }

    await _storeSession();
  }

  String _emailFromPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return 'acct_$digits@hesabat.app';
  }

  List<String> _authEmailsFromPhoneCandidates(List<String> phoneCandidates) {
    final out = <String>{};
    for (final phone in phoneCandidates) {
      final p = phone.trim();
      if (p.isEmpty) continue;
      final digits = p.replaceAll(RegExp(r'\D'), '');
      if (digits.isNotEmpty) {
        out.add('acct_$digits@hesabat.app');
        out.add('u$digits@hesabat.app');
        out.add('$digits@hesabat.app');
      }
      out.add('$p@hesabat.app');
    }
    return out.toList();
  }

  Future<bool> _verifyPasscodeViaRpc(List<String> candidates, String passcode) async {
    for (final candidate in candidates) {
      final result = await _supabase.rpc(
        'verify_admin_passcode',
        params: {
          'p_phone': candidate,
          'p_passcode': passcode,
        },
      );

      if (result == true) return true;
    }

    return false;
  }
  
  /// Activate guest mode (demo/testing)
  Future<void> activateGuestMode() async {
    await GuestModeService.activateGuestMode();
  }
  
  /// Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    await clearAuth();
  }
  
  /// Clear all auth data (shop profile is cleared separately by ShopProfileService)
  Future<void> clearAuth() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _localAuthPhoneKey);
    await GuestModeService.deactivateGuestMode();
  }
  
  /// Store session securely
  Future<void> _storeSession() async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      await _storage.write(key: _tokenKey, value: session.accessToken);
      await _storage.write(key: _refreshTokenKey, value: session.refreshToken!);
    }
  }
  
  List<String> _phoneCandidates(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return [raw.trim()];

    String normalized;
    if (digits.startsWith('93') && digits.length == 12) {
      normalized = '+$digits';
    } else if (digits.startsWith('0') && digits.length == 10) {
      normalized = '+93${digits.substring(1)}';
    } else if (digits.startsWith('7') && digits.length == 9) {
      normalized = '+93$digits';
    } else {
      normalized = digits.startsWith('+') ? digits : '+$digits';
    }

    final national = normalized.replaceFirst('+93', '');
    final with07 = national.length == 9 && national.startsWith('7') ? '0$national' : national;

    return {
      normalized,
      '+93$national',
      national,
      with07,
    }.where((e) => e.isNotEmpty).toList();
  }
  
  /// Check if user can perform action (for guest mode limits)
  Future<Map<String, dynamic>> checkGuestLimits() async {
    if (!await GuestModeService.isGuestMode()) {
      return {'isGuest': false, 'canProceed': true};
    }
    
    final limits = await GuestModeService.getRemainingLimits();
    return {
      'isGuest': true,
      'canProceed': true, // Will be checked per-action
      'limits': limits,
    };
  }
}
