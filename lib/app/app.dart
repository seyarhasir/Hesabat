import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bootstrap/bootstrap.dart';
import '../core/settings/app_locale_provider.dart';
import '../core/settings/app_theme_mode_provider.dart';
import '../core/settings/calendar_system_provider.dart';
import '../core/settings/number_system_provider.dart';
import '../core/database/database_provider.dart';
import '../core/auth/auth_state_notifier.dart';
import '../core/storage/storage_providers.dart';
import '../core/utils/number_system_formatter.dart';
import 'router/app_router.dart';
import '../shared/l10n/generated/app_localizations.dart';
import '../shared/theme/app_theme.dart';

class HesabatApp extends ConsumerStatefulWidget {
  const HesabatApp({super.key});

  @override
  ConsumerState<HesabatApp> createState() => _HesabatAppState();
}

class _HesabatAppState extends ConsumerState<HesabatApp> {
  bool _settingsLoaded = false;

  @override
  void initState() {
    super.initState();

    ref.listenManual<AuthViewState>(
      authStateNotifierProvider,
      (_, next) {
        final shopId = next.shopId;
        if (next.status == AuthStatus.authenticated && shopId != null && shopId.isNotEmpty) {
          ref.read(currentShopIdProvider.notifier).state = shopId;
        }
      },
      fireImmediately: true,
    );

    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await Future.wait([
      ref.read(appSettingsLocaleProvider.notifier).loadSavedLocale(),
      ref.read(appThemeModeProvider.notifier).loadSavedThemeMode(),
      ref.read(appNumberSystemProvider.notifier).loadSavedNumberSystem(),
      ref.read(appCalendarSystemProvider.notifier).loadSavedCalendarSystem(),
    ]);

    final activeShopId = await ref.read(localKvStoreProvider).readString('active_shop_id');
    if (activeShopId != null && activeShopId.isNotEmpty) {
      ref.read(currentShopIdProvider.notifier).state = activeShopId;
    }

    if (!mounted) return;
    setState(() => _settingsLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    final bootstrap = ref.watch(bootstrapResultProvider);
    final locale = ref.watch(appSettingsLocaleProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final numberSystem = ref.watch(appNumberSystemProvider);

    NumberSystemFormatter.setSystem(numberSystem);

    if (!bootstrap.success) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _BootstrapErrorScreen(
          message: bootstrap.failure?.message ?? 'Bootstrap failed',
          details: bootstrap.failure?.details,
        ),
      );
    }

    if (!_settingsLoaded) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Hesabat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}

class _BootstrapErrorScreen extends StatelessWidget {
  final String message;
  final String? details;

  const _BootstrapErrorScreen({
    required this.message,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: theme.colorScheme.error,
                size: 56,
              ),
              const SizedBox(height: 16),
              Text(
                'Startup Error',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (details != null && details!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  details!,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
