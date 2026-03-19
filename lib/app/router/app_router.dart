import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../legacy/legacy_frontend_host.dart';
import '../screens/auth_screen.dart';
import '../screens/splash_screen.dart';
import '../../core/auth/auth_state_notifier.dart';
import 'app_routes.dart';
import 'route_guards.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefreshNotifier(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authStateNotifierProvider);
      return guardedRedirect(
        auth: auth,
        location: state.matchedLocation,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: AppRoutes.home,
        ),
      ),
      GoRoute(
        path: AppRoutes.products,
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: AppRoutes.products,
        ),
      ),
      GoRoute(
        path: AppRoutes.customers,
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: AppRoutes.customers,
        ),
      ),
      GoRoute(
        path: '/inventory',
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: '/inventory',
        ),
      ),
      GoRoute(
        path: '/sales',
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: '/sales',
        ),
      ),
      GoRoute(
        path: '/qarz',
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: '/qarz',
        ),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: '/reports',
        ),
      ),
      GoRoute(
        path: '/reports/daily-summary',
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: '/reports/daily-summary',
        ),
      ),
      GoRoute(
        path: '/reports/sales',
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: '/reports/sales',
        ),
      ),
      GoRoute(
        path: '/reports/qarz',
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: '/reports/qarz',
        ),
      ),
      GoRoute(
        path: '/reports/inventory',
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: '/reports/inventory',
        ),
      ),
      GoRoute(
        path: '/reports/profit',
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: '/reports/profit',
        ),
      ),
      GoRoute(
        path: '/reports/customers',
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: '/reports/customers',
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: '/settings',
        ),
      ),
      GoRoute(
        path: '/settings/help-faq',
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: '/settings/help-faq',
        ),
      ),
      GoRoute(
        path: '/subscription',
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: '/subscription',
        ),
      ),
      GoRoute(
        path: '/sync/conflicts',
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: '/sync/conflicts',
        ),
      ),
      GoRoute(
        path: '/more',
        builder: (context, state) => const LegacyFrontendHost(
          initialRoute: '/more',
        ),
      ),
    ],
  );
});

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(this.ref) {
    _sub = ref.listen<AuthViewState>(
      authStateNotifierProvider,
      (_, __) => notifyListeners(),
      fireImmediately: true,
    );
  }

  final Ref ref;
  late final ProviderSubscription<AuthViewState> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
