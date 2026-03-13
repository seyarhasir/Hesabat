import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'guest_mode_service.dart';

/// Authentication modes
enum AuthMode {
  guest,      // Demo mode - local only
  authenticated, // Full access - Supabase user
}

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'supabase_token';
  static const _refreshTokenKey = 'supabase_refresh_token';
  
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
    try {
      // First, check if user exists in admin-created accounts
      final response = await _supabase
          .from('admin_created_accounts')
          .select()
          .eq('phone', phone)
          .eq('is_active', true)
          .single();
      
      if (response == null) {
        throw Exception('Account not found. Please contact sales agent.');
      }
      
      // Generate and send WhatsApp OTP
      final otpResponse = await _supabase.functions.invoke(
        'whatsapp-otp',
        body: {
          'action': 'generate',
          'phone': phone,
          'deviceId': await _getDeviceId(),
        },
      );
      
      if (otpResponse.status != 200) {
        throw Exception('Failed to generate OTP');
      }
      
      return true;
    } catch (e) {
      debugPrint('Sign in error: $e');
      return false;
    }
  }
  
  /// Verify WhatsApp OTP
  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      final response = await _supabase.functions.invoke(
        'whatsapp-otp',
        body: {
          'action': 'verify',
          'phone': phone,
          'otp': otp,
        },
      );
      
      if (response.status != 200) {
        throw Exception('Invalid OTP');
      }
      
      // OTP verified - now sign in with Supabase
      // The user should already exist in auth.users (created by admin)
      await _supabase.auth.signInWithPassword(
        email: '$phone@hesabat.app', // Phone-based email
        password: otp, // Use OTP as temporary password
      );
      
      // Store session
      await _storeSession();
      
      // Clear guest mode if active
      if (await GuestModeService.isGuestMode()) {
        await GuestModeService.deactivateGuestMode();
      }
      
      return true;
    } catch (e) {
      debugPrint('OTP verification error: $e');
      return false;
    }
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
  
  /// Clear all auth data
  Future<void> clearAuth() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
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
  
  /// Get device ID for tracking
  Future<String> _getDeviceId() async {
    // In real implementation, use device_info_plus
    return 'device_${DateTime.now().millisecondsSinceEpoch}';
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
