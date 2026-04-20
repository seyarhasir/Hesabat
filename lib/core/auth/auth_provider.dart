import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';
import '../settings/shop_profile_service.dart';

/// Auth state
@immutable
class AuthState {
  final AuthMode mode;
  final bool isLoading;
  final String? error;
  final Map<String, int>? guestLimits;
  
  const AuthState({
    this.mode = AuthMode.guest,
    this.isLoading = false,
    this.error,
    this.guestLimits,
  });
  
  AuthState copyWith({
    AuthMode? mode,
    bool? isLoading,
    String? error,
    Map<String, int>? guestLimits,
  }) {
    return AuthState(
      mode: mode ?? this.mode,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      guestLimits: guestLimits ?? this.guestLimits,
    );
  }
  
  bool get isAuthenticated => mode == AuthMode.authenticated;
  bool get isGuest => mode == AuthMode.guest;
}

/// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  
  AuthNotifier(this._authService) : super(const AuthState()) {
    _init();
  }
  
  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    try {
      final mode = await _authService.getCurrentMode();
      Map<String, int>? limits;
      if (mode == AuthMode.guest) {
        final limitData = await _authService.checkGuestLimits();
        limits = limitData['limits'] as Map<String, int>?;
      }
      state = AuthState(mode: mode, guestLimits: limits);
    } catch (e) {
      state = AuthState(error: _friendlyError(e));
    }
  }
  
  /// Sign in with phone (production mode)
  Future<bool> signIn(String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _authService.signInWithPhone(phone);
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _friendlyError(e));
      return false;
    }
  }
  
  /// Verify OTP. Returns the shop profile fetched after auth, or null.
  Future<ShopProfile?> verifyOtp(String phone, String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final profile = await _authService.verifyOtp(phone, otp);
      state = const AuthState(mode: AuthMode.authenticated);
      return profile;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _friendlyError(e));
      return null;
    }
  }
  
  /// Activate guest mode
  Future<void> activateGuestMode() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.activateGuestMode();
      final limits = await _authService.checkGuestLimits();
      state = AuthState(
        mode: AuthMode.guest,
        guestLimits: limits['limits'] as Map<String, int>?,
      );
    } catch (e) {
      state = AuthState(error: _friendlyError(e));
    }
  }
  
  /// Sign out
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.signOut();
      state = const AuthState(mode: AuthMode.guest);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _friendlyError(e));
    }
  }
  
  /// Refresh guest limits
  Future<void> refreshGuestLimits() async {
    if (state.isGuest) {
      final limits = await _authService.checkGuestLimits();
      state = state.copyWith(guestLimits: limits['limits'] as Map<String, int>?);
    }
  }
  
  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  String _friendlyError(Object error) {
    final raw = error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '').trim();
    final lower = raw.toLowerCase();

    if (lower.contains('user already registered') ||
        lower.contains('user already exists') ||
        lower.contains('already registered')) {
      return 'Passcode verified, but cloud login is out of sync. Please contact admin support.';
    }

    return raw;
  }
}

/// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final supabase = Supabase.instance.client;
  return AuthNotifier(AuthService(supabase));
});
