import '../../core/auth/auth_guard.dart';
import '../../core/auth/auth_state_notifier.dart';
import 'app_routes.dart';

String? guardedRedirect({
  required AuthViewState auth,
  required String location,
}) {
  final isSplash = location == AppRoutes.splash;
  final isAuth = location == AppRoutes.auth;
  final isProtected = !isSplash && !isAuth;

  if (AuthGuard.isLoading(auth)) {
    return (isSplash || isAuth) ? null : AppRoutes.splash;
  }

  if (AuthGuard.isUnauthenticated(auth) && isProtected) {
    return AppRoutes.auth;
  }

  if (AuthGuard.isUnauthenticated(auth) && isSplash) {
    return AppRoutes.auth;
  }

  if (AuthGuard.isAuthenticated(auth) && (isAuth || isSplash)) {
    return AppRoutes.home;
  }

  return null;
}
