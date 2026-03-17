import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../core/utils/pdf_generator.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/settings/calendar_system_provider.dart';
import '../providers/reports_provider.dart';

enum ProfitRange { today, week, month }

class ProfitReportScreen extends ConsumerStatefulWidget {
  const ProfitReportScreen({super.key});

  @override
  ConsumerState<ProfitReportScreen> createState() => _ProfitReportScreenState();
}

class _ProfitReportScreenState extends ConsumerState<ProfitReportScreen> {
  bool _loading = true;
  ProfitRange _range = ProfitRange.today;
  double _revenue = 0;
  double _cost = 0;
  List<String> _trendLabels = const [];
  List<double> _trendProfit = const [];

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportsProvider.notifier).trackReportView('profit');
    });
    _load();
  }

  DateTimeRange _rangeWindow() {
    final now = DateTime.now();
    switch (_range) {
      case ProfitRange.today:
        final start = DateTime(now.year, now.month, now.day);
        return DateTimeRange(start: start, end: start.add(const Duration(days: 1)));
      case ProfitRange.week:
        final weekday = now.weekday;
        final start = DateTime(now.year, now.month, now.day).subtract(Duration(days: weekday - 1));
        return DateTimeRange(start: start, end: start.add(const Duration(days: 7)));
      case ProfitRange.month:
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 1);
        return DateTimeRange(start: start, end: end);
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final db = ref.read(databaseProvider);
    final window = _rangeWindow();
    ref.read(reportsProvider.notifier).setDateRange('profit', window);

    final sales = await db.salesDao.getSalesByDateRangeAllShops(window.start, window.end);

    double revenue = 0;
    double cost = 0;

    for (final sale in sales) {
      revenue += sale.totalAfn;
      final items = await db.salesDao.getSaleItems(sale.id);
      for (final item in items) {
        final product = await db.productsDao.getProductById(item.productId ?? '');
        if (product?.costPrice != null) {
          cost += (product!.costPrice! * item.quantity);
        }
      }
    }

    final now = DateTime.now();
    final monthStarts = List.generate(6, (i) {
      final dt = DateTime(now.year, now.month - (5 - i), 1);
      return DateTime(dt.year, dt.month, 1);
    });

    final calendarSystem = ref.read(appCalendarSystemProvider);
    final calendarType = calendarSystem == CalendarSystem.persian 
        ? CalendarType.persian 
        : CalendarType.gregorian;
    final trendLabels = monthStarts.map((m) =>
      calendarType == CalendarType.persian
        ? DateFormatter.getMonthNameForDate(m, calendar: calendarType, locale: _lang)
        : DateFormat('MMM', _lang).format(m)
    ).toList();
    final trendProfit = <double>[];

    for (var i = 0; i < monthStarts.length; i++) {
      final start = monthStarts[i];
      final end = i == monthStarts.length - 1 ? DateTime(now.year, now.month + 1, 1) : monthStarts[i + 1];
      final monthlySales = await db.salesDao.getSalesByDateRangeAllShops(start, end);

      double monthlyRevenue = 0;
      double monthlyCost = 0;
      for (final sale in monthlySales) {
        monthlyRevenue += sale.totalAfn;
        final items = await db.salesDao.getSaleItems(sale.id);
        for (final item in items) {
          final product = await db.productsDao.getProductById(item.productId ?? '');
          if (product?.costPrice != null) {
            monthlyCost += (product!.costPrice! * item.quantity);
          }
        }
      }
      trendProfit.add(monthlyRevenue - monthlyCost);
    }

    if (!mounted) return;
    setState(() {
      _revenue = revenue;
      _cost = cost;
      _trendLabels = trendLabels;
      _trendProfit = trendProfit;
      _loading = false;
    });

    ref.read(reportsProvider.notifier).cacheReportData('profit_summary', {
      'revenue': _revenue,
      'cost': _cost,
      'profit': _revenue - _cost,
    });
  }

  @override
  Widget build(BuildContext context) {
    final profit = _revenue - _cost;
    final margin = _revenue > 0 ? (profit / _revenue) * 100 : 0.0;
    final isGeneratingPdf = ref.watch(reportsProvider.select((s) => s.isGenerating['profit_pdf'] ?? false));

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('Profit Report', 'گزارش سود', 'د ګټې راپور')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loading ? null : _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(_tr('Today', 'امروز', 'نن')),
                        selected: _range == ProfitRange.today,
                        onSelected: (_) {
                          setState(() => _range = ProfitRange.today);
                          _load();
                        },
                      ),
                      ChoiceChip(
                        label: Text(_tr('Week', 'هفته', 'اونۍ')),
                        selected: _range == ProfitRange.week,
                        onSelected: (_) {
                          setState(() => _range = ProfitRange.week);
                          _load();
                        },
                      ),
                      ChoiceChip(
                        label: Text(_tr('Month', 'ماه', 'میاشت')),
                        selected: _range == ProfitRange.month,
                        onSelected: (_) {
                          setState(() => _range = ProfitRange.month);
                          _load();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.trending_up_rounded),
                      title: Text(_tr('Total revenue', 'درآمد کل', 'ټول عاید')),
                      trailing: Text('${_nf(_revenue)} ${_tr('AFN', '؋', '؋')}'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.shopping_bag_outlined),
                      title: Text(_tr('Total cost', 'بهای تمام‌شده', 'ټول لګښت')),
                      trailing: Text('${_nf(_cost)} ${_tr('AFN', '؋', '؋')}'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.account_balance_wallet_rounded),
                      title: Text(_tr('Estimated profit', 'سود تخمینی', 'اټکلي ګټه')),
                      trailing: Text(
                        '${_nf(profit)} ${_tr('AFN', '؋', '؋')}',
                        style: TextStyle(color: profit >= 0 ? Colors.green : Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.percent_rounded),
                      title: Text(_tr('Profit margin', 'حاشیه سود', 'د ګټې حاشیه')),
                      trailing: Text('${_nf(margin, d: 1)}%'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTrendChart(context),
                  const SizedBox(height: 12),
                ],
              ),
            ),
    );
  }

  Widget _buildTrendChart(BuildContext context) {
    final theme = Theme.of(context);
    final isRtl = Directionality.of(context).name == 'rtl';
    final labels = isRtl ? _trendLabels.reversed.toList() : _trendLabels;
    final trend = isRtl ? _trendProfit.reversed.toList() : _trendProfit;
    final maxY = trend.isEmpty ? 1 : trend.fold<double>(0, (m, v) => v.abs() > m ? v.abs() : m);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_tr('Profit trend (6 months)', 'روند سود (۶ ماه)', 'د ګټې بهیر (۶ میاشتې)'), style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            SizedBox(
              height: 210,
              child: RepaintBoundary(
                child: LineChart(
                  LineChartData(
                    minY: -(maxY <= 0 ? 1.0 : (maxY * 1.2).toDouble()),
                    maxY: (maxY <= 0 ? 1.0 : (maxY * 1.2).toDouble()),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            final i = value.toInt();
                            if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(labels[i], style: theme.textTheme.labelSmall),
                            );
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        barWidth: 3,
                        color: theme.colorScheme.primary,
                        spots: List.generate(
                          trend.length,
                          (i) => FlSpot(i.toDouble(), trend[i]),
                        ),
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: true, color: theme.colorScheme.primary.withValues(alpha: 0.14)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportPdf() async {
    final profit = _revenue - _cost;
    final margin = _revenue > 0 ? (profit / _revenue) * 100 : 0.0;
    final calendarSystem = ref.read(appCalendarSystemProvider);
    final calendarType = calendarSystem == CalendarSystem.persian ? CalendarType.persian : CalendarType.gregorian;

    try {
      final file = await ref.read(reportsProvider.notifier).runReportGeneration('profit_pdf', () async {
        return PdfGenerator.generateProfitReportPdf(
          revenue: _revenue,
          cost: _cost,
          profit: profit,
          profitMarginPct: margin,
          trend: List.generate(
            _trendLabels.length,
            (i) => MapEntry(_trendLabels[i], i < _trendProfit.length ? _trendProfit[i] : 0.0),
          ),
          calendar: calendarType,
          locale: _lang,
        );
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('PDF saved: ${file.path}', 'PDF ذخیره شد: ${file.path}', 'PDF خوندي شو: ${file.path}'))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('Failed to generate PDF: $e', 'تولید PDF ناموفق بود: $e', 'د PDF جوړول ناکام شو: $e'))),
      );
    }
  }
}
