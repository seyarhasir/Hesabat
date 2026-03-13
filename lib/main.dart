import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/database/database_provider.dart';
import 'core/network/connectivity_service.dart';
import 'core/settings/app_locale_provider.dart';
import 'core/settings/number_system_provider.dart';
import 'core/settings/app_theme_mode_provider.dart';
import 'core/settings/calendar_system_provider.dart';
import 'core/sync/sync_service.dart';
import 'core/utils/exchange_rate_service.dart';
import 'core/utils/number_system_formatter.dart';
import 'core/utils/notification_service.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/auth_selection_screen.dart';
import 'features/auth/screens/phone_input_screen.dart';
import 'features/auth/screens/otp_verification_screen.dart';
import 'features/onboarding/screens/language_selection_screen.dart';
import 'features/onboarding/screens/shop_setup_screen.dart';
import 'features/onboarding/screens/city_district_screen.dart';
import 'features/onboarding/screens/currency_preference_screen.dart';
import 'features/onboarding/screens/first_product_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/sales/screens/barcode_scanner_screen.dart';
import 'features/sales/screens/sale_review_screen.dart';
import 'features/sales/screens/sale_confirmation_screen.dart';
import 'features/qarz/screens/customer_debt_detail_screen.dart';
import 'features/qarz/screens/record_payment_screen.dart';
import 'features/qarz/screens/add_customer_screen.dart';
import 'features/qarz/screens/add_qarz_screen.dart';
import 'features/inventory/screens/product_list_screen.dart';
import 'features/inventory/screens/add_edit_product_screen.dart';
import 'features/inventory/screens/stock_take_screen.dart';
import 'features/reports/screens/reports_home_screen.dart';
import 'features/reports/screens/daily_summary_screen.dart';
import 'features/reports/screens/sales_report_screen.dart';
import 'features/reports/screens/qarz_report_screen.dart';
import 'features/reports/screens/inventory_report_screen.dart';
import 'features/reports/screens/profit_report_screen.dart';
import 'features/reports/screens/customer_report_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/settings/screens/subscription_screen.dart';
import 'features/sync/screens/conflict_resolution_screen.dart';
import 'shared/theme/app_theme.dart';
import 'shared/l10n/generated/app_localizations.dart';

void main() async {
  print('HESABAT: main() started');
  // 1. Core Flutter engine bootstrap
  WidgetsFlutterBinding.ensureInitialized();
  print('HESABAT: Flutter initialized');

  // 2. Immediate rendering of the First Frame
  final container = ProviderContainer();
  print('HESABAT: ProviderContainer created');
  runApp(UncontrolledProviderScope(container: container, child: const HesabatApp()));
  print('HESABAT: runApp() called');

  // 3. Deferred initialization (delay by 1 second to ensure engine is free)
  Future.delayed(const Duration(seconds: 1), () {
    print('HESABAT: Starting background bootstrap...');
    _bootstrapApp(container);
  });
}

Future<void> _bootstrapApp(ProviderContainer container) async {
  print('HESABAT: Bootstrap task running');
  // 1. Core infrastructure (Supabase first as services depend on it)
  try {
    print('HESABAT: Initializing Supabase...');
    await Supabase.initialize(
      url: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://your-project.supabase.co'),
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'your-anon-key'),
    ).timeout(const Duration(seconds: 4));
    print('HESABAT: Supabase initialized');
  } catch (e) {
    print('HESABAT: Supabase init skipped/failed: $e');
  }

  try {
    print('HESABAT: Initializing Connectivity...');
    await ConnectivityService.instance.initialize();
    print('HESABAT: Connectivity initialized');
  } catch (e) {
    print('HESABAT: Connectivity init failed: $e');
  }

  try {
    print('HESABAT: Initializing Database...');
    final db = container.read(databaseProvider);
    await db.initializeDatabase().timeout(const Duration(seconds: 4));
    print('HESABAT: Database initialized');
    await SyncService.instance.initialize(db);
    print('HESABAT: Sync service initialized');
    await ExchangeRateService.instance.initialize(db);
    print('HESABAT: Exchange service initialized');
  } catch (e) {
    print('HESABAT: Database/Sync bootstrap failed: $e');
  }

  try {
    await container.read(appSettingsLocaleProvider.notifier).loadSavedLocale();
  } catch (e) {
    debugPrint('Locale bootstrap failed: $e');
  }

  try {
    await container.read(appNumberSystemProvider.notifier).loadSavedNumberSystem();
  } catch (e) {
    debugPrint('Number system bootstrap failed: $e');
  }

  try {
    await container.read(appThemeModeProvider.notifier).loadSavedThemeMode();
  } catch (e) {
    debugPrint('Theme bootstrap failed: $e');
  }

  try {
    await container.read(appCalendarSystemProvider.notifier).loadSavedCalendarSystem();
  } catch (e) {
    debugPrint('Calendar system bootstrap failed: $e');
  }

  try {
    await NotificationService.initialize();
    await NotificationService.scheduleDailySummaryAt9Pm();
  } catch (e) {
    debugPrint('Notification bootstrap failed: $e');
  }
}

class HesabatApp extends ConsumerWidget {
  const HesabatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appSettingsLocaleProvider);
    final numberSystem = ref.watch(appNumberSystemProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    NumberSystemFormatter.setSystem(numberSystem);

    return MaterialApp(
      title: 'Hesabat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        print('HESABAT: MaterialApp builder running (child exists: ${child != null})');
        final isRtl = locale.languageCode == 'fa' || locale.languageCode == 'ps';
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const Center(child: Text('Engine Error: No Child')),
        );
      },
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/auth':
            return MaterialPageRoute(builder: (_) => const AuthSelectionScreen());
          case '/auth/phone':
            return MaterialPageRoute(builder: (_) => const PhoneInputScreen());
          case '/auth/otp':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => OtpVerificationScreen(phone: args?['phone'] ?? ''),
            );
          case '/onboarding/language':
            return MaterialPageRoute(builder: (_) => const LanguageSelectionScreen());
          case '/onboarding/shop-setup':
            return MaterialPageRoute(builder: (_) => const ShopSetupScreen());
          case '/onboarding/city-district':
            return MaterialPageRoute(builder: (_) => const CityDistrictScreen());
          case '/onboarding/currency':
            return MaterialPageRoute(builder: (_) => const CurrencyPreferenceScreen());
          case '/onboarding/first-product':
            return MaterialPageRoute(builder: (_) => const FirstProductScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/sales/barcode':
            return MaterialPageRoute(builder: (_) => const BarcodeScannerScreen());
          case '/sales/review':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const SaleReviewScreen(),
            );
          case '/sales/confirmation':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const SaleConfirmationScreen(),
            );
          case '/qarz/detail':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const CustomerDebtDetailScreen(),
            );
          case '/qarz/record-payment':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const RecordPaymentScreen(),
            );
          case '/qarz/add-customer':
            return MaterialPageRoute(builder: (_) => const AddCustomerScreen());
          case '/qarz/add-debt':
            return MaterialPageRoute(builder: (_) => const AddQarzScreen());
          case '/inventory':
            return MaterialPageRoute(builder: (_) => const ProductListScreen());
          case '/inventory/add-product':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => AddEditProductScreen(
                initialBarcode: args?['barcode']?.toString(),
              ),
            );
          case '/inventory/stock-take':
            return MaterialPageRoute(builder: (_) => const StockTakeScreen());
          case '/reports':
            return MaterialPageRoute(builder: (_) => const ReportsHomeScreen());
          case '/reports/daily-summary':
            return MaterialPageRoute(builder: (_) => const DailySummaryScreen());
          case '/reports/sales':
            return MaterialPageRoute(builder: (_) => const SalesReportScreen());
          case '/reports/qarz':
            return MaterialPageRoute(builder: (_) => const QarzReportScreen());
          case '/reports/inventory':
            return MaterialPageRoute(builder: (_) => const InventoryReportScreen());
          case '/reports/profit':
            return MaterialPageRoute(builder: (_) => const ProfitReportScreen());
          case '/reports/customers':
            return MaterialPageRoute(builder: (_) => const CustomerReportScreen());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          case '/subscription':
            return MaterialPageRoute(builder: (_) => const SubscriptionScreen());
          case '/sync/conflicts':
            return MaterialPageRoute(builder: (_) => const ConflictResolutionScreen());
          default:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
      },
    );
  }
}
