import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/app/router/app_routes.dart';
import 'package:hesabat/app/router/route_guards.dart';
import 'package:hesabat/core/auth/auth_state_notifier.dart';

void main() {
  group('guardedRedirect', () {
    test('unauthenticated user is redirected from protected route', () {
      const state = AuthViewState.unauthenticated();

      final redirect = guardedRedirect(
        auth: state,
        location: AppRoutes.home,
      );

      expect(redirect, AppRoutes.auth);
    });

    test('authenticated user is redirected from auth route to home', () {
      const state = AuthViewState(status: AuthStatus.authenticated);

      final redirect = guardedRedirect(
        auth: state,
        location: AppRoutes.auth,
      );

      expect(redirect, AppRoutes.home);
    });

    test('loading state is redirected to splash', () {
      const state = AuthViewState.unknown();

      final redirect = guardedRedirect(
        auth: state,
        location: AppRoutes.home,
      );

      expect(redirect, AppRoutes.splash);
    });

    test('loading state on auth stays on auth', () {
      const state = AuthViewState(status: AuthStatus.refreshing);

      final redirect = guardedRedirect(
        auth: state,
        location: AppRoutes.auth,
      );

      expect(redirect, isNull);
    });

    test('unauthenticated user on splash is redirected to auth', () {
      const state = AuthViewState.unauthenticated();

      final redirect = guardedRedirect(
        auth: state,
        location: AppRoutes.splash,
      );

      expect(redirect, AppRoutes.auth);
    });

    test('unauthenticated user on legacy route is redirected to auth', () {
      const state = AuthViewState.unauthenticated();

      final redirect = guardedRedirect(
        auth: state,
        location: '/settings',
      );

      expect(redirect, AppRoutes.auth);
    });
  });
}
