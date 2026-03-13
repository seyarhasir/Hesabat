import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_layout.dart';
import '../../../shared/widgets/app_stat_card.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../providers/reports_provider.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/settings/calendar_system_provider.dart';

class DailySummaryScreen extends ConsumerStatefulWidget {
  const DailySummaryScreen({super.key});

  @override
  ConsumerState<DailySummaryScreen> createState() => _DailySummaryScreenState();
}

class _DailySummaryScreenState extends ConsumerState<DailySummaryScreen> {
  Map<String, dynamic>? _summary;
  bool _isLoading = true;

  String get _lang => Localizations.localeOf(context).languageCode;
  bool get _isEn => _lang == 'en';
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);
  
  String _nf(num value, {int decimalDigits = 0}) => NumberSystemFormatter.formatFixed(value, fractionDigits: decimalDigits);
  String _na(String value) => NumberSystemFormatter.apply(value);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportsProvider.notifier).trackReportView('daily_summary');
    });
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    final db = ref.read(databaseProvider);
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // Get today's sales (all shops for demo, or filter by current shop)
    final sales = await db.salesDao.getSalesByDateRangeAllShops(startOfDay, endOfDay);
    
    // Calculate totals
    double totalSales = 0;
    double cashReceived = 0;
    double creditSales = 0;
    double qarzCollected = 0;
    Map<String, int> productCounts = {};

    for (final sale in sales) {
      totalSales += sale.totalAfn;
      
      if (sale.isCredit) {
        creditSales += sale.totalAfn;
      } else {
        cashReceived += sale.totalAfn;
      }

      // Get sale items for top products
      final items = await db.salesDao.getSaleItems(sale.id);
      for (final item in items) {
        final productName = item.productNameSnapshot;
        productCounts[productName] = (productCounts[productName] ?? 0) + item.quantity.toInt();
      }
    }

    // Get today's debt payments
    final payments = await db.debtsDao.getPaymentsByDateRange(startOfDay, endOfDay);
    for (final payment in payments) {
      qarzCollected += payment.amount;
    }

    // Get top 3 products
    final sortedProducts = productCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topProducts = sortedProducts.take(3).toList();

    // Calculate profit estimate (if cost prices available)
    double totalCost = 0;
    for (final sale in sales) {
      final items = await db.salesDao.getSaleItems(sale.id);
      for (final item in items) {
        // Try to get cost price from product
        final product = await db.productsDao.getProductById(item.productId ?? '');
        if (product != null && product.costPrice != null) {
          totalCost += (product.costPrice! * item.quantity);
        }
      }
    }
    final netProfit = totalSales - totalCost;

    setState(() {
      _summary = {
        'totalSales': totalSales,
        'cashReceived': cashReceived,
        'creditSales': creditSales,
        'qarzCollected': qarzCollected,
        'transactionCount': sales.length,
        'topProducts': topProducts,
        'netProfit': netProfit,
        'hasCostData': totalCost > 0,
      };
      _isLoading = false;
    });

    ref.read(reportsProvider.notifier).cacheReportData('daily_summary', _summary);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final calendarSystem = ref.watch(appCalendarSystemProvider);
    final calendarType = calendarSystem == CalendarSystem.persian 
        ? CalendarType.persian 
        : CalendarType.gregorian;

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('Daily Summary', 'خلاصه روزانه', 'د ورځني لنډیز')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadSummary();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _summary == null
              ? AppEmptyState(
                title: _tr('No data available', 'داده‌ای موجود نیست', 'هیڅ معلومات شتون نلري'),
                description: _tr('Start recording sales to see your summary here.', 'برای مشاهده خلاصه، فروش ثبت کنید.', 'د لنډیز لیدو لپاره د پلور ثبت پیل کړئ.'),
                  icon: Icons.bar_chart_rounded,
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header
                      Text(
                        _na(DateFormatter.formatDate(DateTime.now(), calendar: calendarType, locale: _lang)),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: cs.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sectionGap),

                      // Total Sales Card
                      AppStatCard(
                        title: _tr('Total Sales', 'کل فروش', 'ټول پلور'),
                        value: _nf(_summary!['totalSales']),
                        subtitle: _tr('${_na(_summary!['transactionCount'].toString())} transactions today', '${_na(_summary!['transactionCount'].toString())} تراکنش امروز', '${_na(_summary!['transactionCount'].toString())} نننۍ راکړې ورکړې'),
                        icon: Icons.trending_up_rounded,
                        color: AppColors.success,
                      ),
                      const SizedBox(height: AppSpacing.m),

                      // Payment Breakdown
                      Row(
                        children: [
                          Expanded(
                            child: AppStatCard(
                              title: _tr('Cash', 'نقد', 'نغد'),
                              value: _nf(_summary!['cashReceived']),
                              color: AppColors.success,
                              isCompact: true,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.m),
                          Expanded(
                            child: AppStatCard(
                              title: _tr('Credit (Qarz)', 'قرض', 'قرض'),
                              value: _nf(_summary!['creditSales']),
                              color: AppColors.warning,
                              isCompact: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.m),

                      // Qarz Collected
                      AppStatCard(
                        title: _tr('Qarz Collected Today', 'قرض وصول‌شده امروز', 'نن راټول شوی پور'),
                        value: _nf(_summary!['qarzCollected']),
                        subtitle: _tr('Debt payments received', 'دریافت‌های بدهی', 'د پور ترلاسه شوې تادیات'),
                        icon: Icons.account_balance_wallet_rounded,
                        color: AppColors.chart1,
                      ),
                      const SizedBox(height: AppSpacing.sectionGap),

                      // Net Profit
                      if (_summary!['hasCostData']) ...[
                        Text(
                          _tr('Performance', 'عملکرد', 'کارکرد'),
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.m),
                        _buildProfitCard(context),
                        const SizedBox(height: AppSpacing.sectionGap),
                      ],

                      // Top Products
                      Text(
                        _tr('Top Selling Products', 'پرفروش‌ترین محصولات', 'ترټولو ډیر پلورل شوي توکي'),
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppSpacing.m),
                      _buildTopProductsList(context),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfitCard(BuildContext context) {
    final profit = _summary!['netProfit'] as double;
    final isPositive = profit >= 0;

    return AppStatCard(
      title: isPositive ? _tr('Net Profit', 'سود خالص', 'خلاصه ګټه') : _tr('Net Loss', 'زیان خالص', 'خلاصه تاوان'),
      value: _nf(profit.abs()),
      icon: isPositive ? Icons.analytics_rounded : Icons.trending_down_rounded,
      color: isPositive ? AppColors.success : AppColors.danger,
      subtitle: isPositive ? _tr('Your shop is performing well!', 'دکان شما عملکرد خوبی دارد!', 'ستاسو دوکان ښه فعالیت کوي!') : _tr('Expenses exceed sales today.', 'مصارف امروز از فروش بیشتر است.', 'نن مصرفونه له پلور څخه ډیر دي.'),
    );
  }

  Widget _buildTopProductsList(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final topProducts = _summary!['topProducts'] as List<MapEntry<String, int>>;

    if (topProducts.isEmpty) {
      return AppEmptyState(
        title: _tr('No sales recorded', 'فروشی ثبت نشده', 'هیڅ پلور نه دی ثبت شوی'),
        icon: Icons.inventory_2_outlined,
        isLarge: false,
      );
    }

    return Column(
      children: topProducts.asMap().entries.map((entry) {
        final index = entry.key;
        final product = entry.value;
        final rank = index + 1;

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.s),
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: AppRadius.medium,
            border: Border.all(color: cs.outline.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getRankColor(rank).withOpacity(0.1),
                  borderRadius: AppRadius.small,
                ),
                child: Center(
                  child: Text(
                    '#${_nf(rank)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getRankColor(rank),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Text(
                  product.key,
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                _tr('${_na(product.value.toString())} sold', '${_na(product.value.toString())} فروخته شد', '${_na(product.value.toString())} وپلورل شو'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey;
    }
  }
}
