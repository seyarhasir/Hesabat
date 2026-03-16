import 'auth_state_notifier.dart';

class AuthGuard {
  static bool isLoading(AuthViewState state) {
    return state.status == AuthStatus.unknown ||
        state.status == AuthStatus.refreshing;
  }

  static bool isAuthenticated(AuthViewState state) {
    return state.status == AuthStatus.authenticated;
  }

  static bool isUnauthenticated(AuthViewState state) {
    return state.status == AuthStatus.unauthenticated ||
        state.status == AuthStatus.error;
  }
}
