import 'package:flutter/material.dart';
import '../../core/database/app_database.dart';

import '../../features/home/screens/home_screen.dart' as home;
import '../../features/inventory/screens/add_edit_product_screen.dart' as inventory_add;
import '../../features/inventory/screens/product_list_screen.dart' as inventory_list;
import '../../features/inventory/screens/stock_take_screen.dart' as inventory_stock;
import '../../features/more/screens/more_screen.dart' as more;
import '../../features/qarz/screens/add_customer_screen.dart' as qarz_add_customer;
import '../../features/qarz/screens/add_qarz_screen.dart' as qarz_add;
import '../../features/qarz/screens/customer_debt_detail_screen.dart' as qarz_detail;
import '../../features/qarz/screens/customers_screen.dart' as qarz_customers;
import '../../features/qarz/screens/qarz_dashboard_screen.dart' as qarz;
import '../../features/qarz/screens/record_payment_screen.dart' as qarz_payment;
import '../../features/reports/screens/customer_report_screen.dart' as reports_customer;
import '../../features/reports/screens/daily_summary_screen.dart' as reports_daily;
import '../../features/reports/screens/inventory_report_screen.dart' as reports_inventory;
import '../../features/reports/screens/profit_report_screen.dart' as reports_profit;
import '../../features/reports/screens/qarz_report_screen.dart' as reports_qarz;
import '../../features/reports/screens/reports_home_screen.dart' as reports_home;
import '../../features/reports/screens/sales_report_screen.dart' as reports_sales;
import '../../features/sales/screens/barcode_scanner_screen.dart' as sales_barcode;
import '../../features/sales/screens/sale_confirmation_screen.dart' as sales_confirmation;
import '../../features/sales/screens/sale_review_screen.dart' as sales_review;
import '../../features/sales/screens/sale_details_screen.dart' as sales_details;
import '../../features/sales/screens/sale_screen.dart' as sales;
import '../../features/settings/screens/settings_screen.dart' as app_settings;
import '../../features/settings/screens/subscription_screen.dart' as subscription;
import '../../features/settings/screens/data_export_screen.dart' as data_export;
import '../../features/settings/screens/help_faq_screen.dart' as help_faq;
import '../../features/sync/screens/conflict_resolution_screen.dart' as sync_conflicts;
import '../screens/auth_screen.dart';

class LegacyFrontendHost extends StatelessWidget {
  final String initialRoute;

  const LegacyFrontendHost({
    super.key,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: initialRoute,
      onGenerateInitialRoutes: (_, __) {
        return [_buildRoute(const RouteSettings())];
      },
      onGenerateRoute: _buildRoute,
    );
  }

  Route<void> _buildRoute(RouteSettings routeSettings) {
    final rawName = routeSettings.name;
    final name = (rawName == null || rawName == '/' || rawName.isEmpty)
        ? initialRoute
        : rawName;

    Widget page;
    switch (name) {
      case '/home':
        page = const home.HomeScreen();
        break;
      case '/more':
        page = const more.MoreScreen();
        break;

      case '/inventory':
      case '/products':
        page = const inventory_list.ProductListScreen();
        break;
      case '/inventory/add-product':
        final args = routeSettings.arguments;
        String? initialBarcode;
        if (args is Map<String, dynamic>) {
          initialBarcode = args['initialBarcode']?.toString() ??
              args['barcode']?.toString();
        } else if (args is String) {
          initialBarcode = args;
        }
        page = inventory_add.AddEditProductScreen(
          initialBarcode: initialBarcode,
        );
        break;
      case '/inventory/stock-take':
        page = const inventory_stock.StockTakeScreen();
        break;

      case '/sales':
        page = const sales.SaleScreen();
        break;
      case '/sales/barcode':
        page = const sales_barcode.BarcodeScannerScreen();
        break;
      case '/sales/review':
        page = const sales_review.SaleReviewScreen();
        break;
      case '/sales/confirmation':
        page = const sales_confirmation.SaleConfirmationScreen();
        break;
      case '/sales/details':
        final args = routeSettings.arguments;
        if (args is Sale) {
          page = sales_details.SaleDetailsScreen(sale: args);
        } else {
          page = const _UnknownLegacyRouteScreen(routeName: '/sales/details');
        }
        break;

      case '/qarz':
        page = const qarz.QarzDashboardScreen();
        break;
      case '/customers':
        page = const qarz_customers.CustomersScreen();
        break;
      case '/qarz/add-customer':
        page = const qarz_add_customer.AddCustomerScreen();
        break;
      case '/qarz/add-debt':
        page = const qarz_add.AddQarzScreen();
        break;
      case '/qarz/detail':
        page = const qarz_detail.CustomerDebtDetailScreen();
        break;
      case '/qarz/record-payment':
        page = const qarz_payment.RecordPaymentScreen();
        break;

      case '/reports':
        page = const reports_home.ReportsHomeScreen();
        break;
      case '/reports/daily-summary':
        page = const reports_daily.DailySummaryScreen();
        break;
      case '/reports/sales':
        page = const reports_sales.SalesReportScreen();
        break;
      case '/reports/qarz':
        page = const reports_qarz.QarzReportScreen();
        break;
      case '/reports/inventory':
        page = const reports_inventory.InventoryReportScreen();
        break;
      case '/reports/profit':
        page = const reports_profit.ProfitReportScreen();
        break;
      case '/reports/customers':
        page = const reports_customer.CustomerReportScreen();
        break;

      case '/settings':
        page = const app_settings.SettingsScreen();
        break;
      case '/settings/export':
        page = const data_export.DataExportScreen();
        break;
      case '/settings/help-faq':
        page = const help_faq.HelpFaqScreen();
        break;
      case '/subscription':
        page = const subscription.SubscriptionScreen();
        break;
      case '/sync/conflicts':
        page = const sync_conflicts.ConflictResolutionScreen();
        break;

      case '/auth':
      case '/auth/phone':
      case '/auth/otp':
        page = const AuthScreen();
        break;

      default:
        page = _UnknownLegacyRouteScreen(routeName: name);
        break;
    }

    return MaterialPageRoute<void>(
      settings: RouteSettings(name: name, arguments: routeSettings.arguments),
      builder: (_) => page,
    );
  }
}

class _UnknownLegacyRouteScreen extends StatelessWidget {
  final String routeName;

  const _UnknownLegacyRouteScreen({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route not found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Unknown route: $routeName'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home',
                  (_) => false,
                ),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
