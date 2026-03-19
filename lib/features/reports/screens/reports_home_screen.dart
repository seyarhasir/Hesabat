import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/settings/calendar_system_provider.dart';
import '../providers/reports_provider.dart';
import '../../../shared/widgets/currency_display.dart';

class ReportsHomeScreen extends ConsumerStatefulWidget {
  const ReportsHomeScreen({super.key});

  @override
  ConsumerState<ReportsHomeScreen> createState() => _ReportsHomeScreenState();
}

class _ReportsHomeScreenState extends ConsumerState<ReportsHomeScreen> {
  bool _loading = true;
  double _todaySales = 0;
  double _todayCredit = 0;
  double _todayCollected = 0;
  double _todayProfitEstimate = 0;

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);
  String _na(String s) => NumberSystemFormatter.apply(s);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportsProvider.notifier).trackReportView('reports_home');
    });
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final sales = await db.salesDao.getSalesByDateRangeAllShops(start, end);

    double totalSales = 0;
    double totalCredit = 0;
    double totalCost = 0;

    for (final sale in sales) {
      totalSales += sale.totalAfn;
      if (sale.isCredit) totalCredit += sale.totalAfn;

      final items = await db.salesDao.getSaleItems(sale.id);
      for (final item in items) {
        final product = await db.productsDao.getProductById(item.productId ?? '');
        if (product?.costPrice != null) {
          totalCost += (product!.costPrice! * item.quantity);
        }
      }
    }

    final payments = await db.debtsDao.getPaymentsByDateRange(start, end);
    final collected = payments.fold<double>(0, (sum, p) => sum + p.amount);

    if (!mounted) return;
    setState(() {
      _todaySales = totalSales;
      _todayCredit = totalCredit;
      _todayCollected = collected;
      _todayProfitEstimate = totalSales - totalCost;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final reportsState = ref.watch(reportsProvider);
    final calendarSystem = ref.watch(appCalendarSystemProvider);
    final calendarType = calendarSystem == CalendarSystem.persian 
        ? CalendarType.persian 
        : CalendarType.gregorian;

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_tr('Reports', 'گزارش‌ها', 'راپورونه'))),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSummary,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: DefaultTextStyle(
                        style: theme.textTheme.bodyMedium ?? const TextStyle(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('${_tr('Sales', 'فروش', 'پلور')}: '),
                                CurrencyDisplay(amount: _todaySales),
                              ],
                            ),
                            Row(
                              children: [
                                Text('${_tr('New qarz', 'قرض جدید', 'نوی قرض')}: '),
                                CurrencyDisplay(amount: _todayCredit),
                              ],
                            ),
                            Row(
                              children: [
                                Text('${_tr('Collected qarz', 'قرض وصول شده', 'راټول شوی قرض')}: '),
                                CurrencyDisplay(amount: _todayCollected),
                              ],
                            ),
                            const SizedBox(height: 8),
                            DefaultTextStyle(
                              style: TextStyle(
                                color: _todayProfitEstimate >= 0 ? Colors.green : cs.error,
                                fontWeight: FontWeight.w600,
                              ),
                              child: Row(
                                children: [
                                  Text('${_tr('Estimated profit', 'سود تخمینی', 'اټکلي ګټه')}: '),
                                  CurrencyDisplay(amount: _todayProfitEstimate),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: _buildUsageAnalytics(reportsState),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _tr('Report categories', 'دسته‌بندی گزارش‌ها', 'د راپور کټګورۍ'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.5,
                      children: [
                        _reportCard(context, icon: Icons.today_rounded, title: _tr('Daily summary', 'خلاصه روزانه', 'ورځنی لنډیز'), route: '/reports/daily-summary'),
                        _reportCard(context, icon: Icons.bar_chart_rounded, title: _tr('Sales report', 'گزارش فروش', 'د پلور راپور'), route: '/reports/sales'),
                        _reportCard(context, icon: Icons.people_alt_rounded, title: _tr('Qarz report', 'گزارش قرض', 'د قرض راپور'), route: '/reports/qarz'),
                        _reportCard(context, icon: Icons.inventory_2_rounded, title: _tr('Inventory report', 'گزارش موجودی', 'د زېرمې راپور'), route: '/reports/inventory'),
                        _reportCard(context, icon: Icons.trending_up_rounded, title: _tr('Profit report', 'گزارش سود', 'د ګټې راپور'), route: '/reports/profit'),
                        _reportCard(context, icon: Icons.groups_rounded, title: _tr('Customer report', 'گزارش مشتریان', 'د پېرودونکو راپور'), route: '/reports/customers'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _reportCard(BuildContext context, {required IconData icon, required String title, required String route}) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outline.withOpacity(0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: cs.primary),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageAnalytics(ReportsState state) {
    final calendarSystem = ref.watch(appCalendarSystemProvider);
    final calendarType = calendarSystem == CalendarSystem.persian
        ? CalendarType.persian
        : CalendarType.gregorian;
    final entries = state.viewCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    String prettyName(String key) {
      switch (key) {
        case 'daily_summary':
          return _tr('Daily summary', 'خلاصه روزانه', 'ورځنی لنډیز');
        case 'sales':
          return _tr('Sales', 'فروش', 'پلور');
        case 'qarz':
          return _tr('Qarz', 'قرض', 'قرض');
        case 'inventory':
          return _tr('Inventory', 'موجودی', 'زېرمه');
        case 'profit':
          return _tr('Profit', 'سود', 'ګټه');
        case 'customers':
          return _tr('Customers', 'مشتریان', 'پېرودونکي');
        case 'reports_home':
          return _tr('Reports home', 'صفحه گزارش', 'د راپور کورپاڼه');
        default:
          return key;
      }
    }

    if (entries.isEmpty) {
      return Text(_tr('No report usage data yet', 'هنوز داده استفاده از گزارش وجود ندارد', 'لا د راپور کارونې معلومات نشته'));
    }

    final top = entries.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_tr('Report usage analytics', 'تحلیل استفاده گزارش', 'د راپور کارونې شننه'), style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        ...top.map((e) {
          final when = state.lastViewedAt[e.key];
          final whenText = when == null ? '-' : _na(DateFormatter.formatDateTime(when, calendar: calendarType, locale: _lang));
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text('${prettyName(e.key)}: ${_nf(e.value)} • $whenText'),
          );
        }),
      ],
    );
  }
}
