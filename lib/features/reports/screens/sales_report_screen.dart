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
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/currency_display.dart';

enum SalesReportRange { daily, weekly, monthly, custom }

class SalesReportScreen extends ConsumerStatefulWidget {
  const SalesReportScreen({super.key});

  @override
  ConsumerState<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends ConsumerState<SalesReportScreen> {
  SalesReportRange _selectedRange = SalesReportRange.daily;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool _isLoading = true;

  double _totalRevenue = 0;
  int _transactionCount = 0;
  double _averageSale = 0;
  double _cashSales = 0;
  double _creditSales = 0;
  double _mixedSales = 0;
  List<MapEntry<String, int>> _topProducts = const [];
  List<double> _last7DaysSales = List<double>.filled(7, 0);

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);
  String _na(String s) => NumberSystemFormatter.apply(s);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportsProvider.notifier).trackReportView('sales');
    });
    _applyRangeAndLoad(SalesReportRange.daily);
  }

  Future<void> _applyRangeAndLoad(SalesReportRange range) async {
    final now = DateTime.now();
    late DateTime start;
    late DateTime end;

    switch (range) {
      case SalesReportRange.daily:
        start = DateTime(now.year, now.month, now.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case SalesReportRange.weekly:
        final weekday = now.weekday; // Mon=1..Sun=7
        start = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: weekday - 1));
        end = DateTime(start.year, start.month, start.day, 23, 59, 59)
            .add(const Duration(days: 6));
        break;
      case SalesReportRange.monthly:
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case SalesReportRange.custom:
        start = DateTime(_startDate.year, _startDate.month, _startDate.day);
        end = DateTime(_endDate.year, _endDate.month, _endDate.day, 23, 59, 59);
        break;
    }

    setState(() {
      _selectedRange = range;
      _startDate = start;
      _endDate = end;
      _isLoading = true;
    });

    ref.read(reportsProvider.notifier).setDateRange(
          'sales',
          DateTimeRange(start: start, end: end),
        );

    await _loadReport();
  }

  Future<void> _loadReport() async {
    final db = ref.read(databaseProvider);

    final sales = await db.salesDao.getSalesByDateRangeAllShops(_startDate, _endDate);

    double total = 0;
    int count = 0;
    double cash = 0;
    double credit = 0;
    double mixed = 0;
    final Map<String, int> productCounts = {};

    for (final sale in sales) {
      final amount = sale.totalAfn;
      total += amount;
      count++;

      final items = await db.salesDao.getSaleItems(sale.id);
      for (final item in items) {
        final name = item.productNameSnapshot;
        productCounts[name] = (productCounts[name] ?? 0) + item.quantity.toInt();
      }

      switch (sale.paymentMethod) {
        case 'cash':
          cash += amount;
          break;
        case 'credit':
          credit += amount;
          break;
        case 'mixed':
          mixed += amount;
          break;
      }
    }

    final sortedProducts = productCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final now = DateTime.now();
    final List<double> last7 = [];
    for (var i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      final daySales = await db.salesDao.getSalesByDateRangeAllShops(dayStart, dayEnd);
      final dayTotal = daySales.fold<double>(0, (sum, s) => sum + s.totalAfn);
      last7.add(dayTotal);
    }

    if (!mounted) return;
    setState(() {
      _totalRevenue = total;
      _transactionCount = count;
      _averageSale = count > 0 ? total / count : 0;
      _cashSales = cash;
      _creditSales = credit;
      _mixedSales = mixed;
      _topProducts = sortedProducts.take(3).toList();
      _last7DaysSales = last7;
      _isLoading = false;
    });

    ref.read(reportsProvider.notifier).cacheReportData('sales_summary', {
      'revenue': _totalRevenue,
      'transactions': _transactionCount,
      'average': _averageSale,
      'cash': _cashSales,
      'credit': _creditSales,
      'mixed': _mixedSales,
    });
  }

  Future<void> _pickCustomDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked == null) return;

    setState(() {
      _startDate = picked.start;
      _endDate = picked.end;
    });

    await _applyRangeAndLoad(SalesReportRange.custom);
  }

  String _formatCurrency(double value) => _na(NumberFormat('#,##0.##').format(value));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGeneratingPdf = ref.watch(reportsProvider.select((s) => s.isGenerating['sales_pdf'] ?? false));

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('Sales Report', 'گزارش فروش', 'د پلور راپور')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _isLoading ? null : _loadReport,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadReport,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildRangeSelector(theme),
                  const SizedBox(height: 12),
                  if (_selectedRange == SalesReportRange.custom)
                    _buildCustomRangeCard(theme),
                  const SizedBox(height: 12),
                  _buildSalesChart(theme),
                  const SizedBox(height: 12),
                  _buildSummaryGrid(theme),
                  const SizedBox(height: 12),
                  _buildPaymentSplitChart(theme),
                  const SizedBox(height: 12),
                  _buildPaymentBreakdown(theme),
                  const SizedBox(height: 12),
                  _buildTopProducts(theme),
                  const SizedBox(height: 12),
                ],
              ),
            ),
    );
  }

  Widget _buildRangeSelector(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _rangeChip(_tr('Today', 'امروز', 'نن'), SalesReportRange.daily),
            _rangeChip(_tr('Week', 'هفته', 'اونۍ'), SalesReportRange.weekly),
            _rangeChip(_tr('Month', 'ماه', 'میاشت'), SalesReportRange.monthly),
            _rangeChip(_tr('Custom', 'سفارشی', 'ځانګړی'), SalesReportRange.custom, onTap: _pickCustomDateRange),
          ],
        ),
      ),
    );
  }

  Widget _rangeChip(String label, SalesReportRange range, {Future<void> Function()? onTap}) {
    final selected = _selectedRange == range;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) async {
        if (range == SalesReportRange.custom) {
          await (onTap?.call() ?? _pickCustomDateRange());
        } else {
          await _applyRangeAndLoad(range);
        }
      },
    );
  }

  Widget _buildCustomRangeCard(ThemeData theme) {
    final calendarSystem = ref.watch(appCalendarSystemProvider);
    final calendarType = calendarSystem == CalendarSystem.persian 
        ? CalendarType.persian 
        : CalendarType.gregorian;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.date_range_rounded),
        title: Text(_tr('Custom date range', 'بازه زمانی سفارشی', 'ځانګړې نېټې موده')),
        subtitle: Text('${_na(DateFormatter.formatDate(_startDate, calendar: calendarType, locale: _lang))} → ${_na(DateFormatter.formatDate(_endDate, calendar: calendarType, locale: _lang))}'),
        trailing: const Icon(Icons.edit_calendar_rounded),
        onTap: _pickCustomDateRange,
      ),
    );
  }

  Widget _buildSalesChart(ThemeData theme) {
    final isRtl = Directionality.of(context).name == 'rtl';
    final chartSales = isRtl ? _last7DaysSales.reversed.toList() : _last7DaysSales;
    final maxY = chartSales.isEmpty
        ? 1.0
        : (chartSales.reduce((a, b) => a > b ? a : b) * 1.2).clamp(1.0, double.infinity);

    final now = DateTime.now();
    final labelsRaw = List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return DateFormat('E').format(day);
    });
    final labels = isRtl ? labelsRaw.reversed.toList() : labelsRaw;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_tr('Sales chart (last ${_nf(7)} days)', 'نمودار فروش (۷ روز گذشته)', 'د پلور چارټ (وروستۍ ۷ ورځې)'), style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: RepaintBoundary(
                child: BarChart(
                  BarChartData(
                    maxY: maxY,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(labels[i], style: theme.textTheme.bodySmall),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(7, (index) {
                      final y = index < chartSales.length ? chartSales[index] : 0.0;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: y,
                            width: 16,
                            color: AppColors.chart1,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryGrid(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _metricCard(
                title: _tr('Total sales', 'کل فروش', 'ټول پلور'),
                valueWidget: CurrencyDisplay(
                  amount: _totalRevenue,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                icon: Icons.payments_rounded,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _metricCard(
                title: _tr('Invoices', 'تعداد فاکتور', 'بلونه'),
                value: _nf(_transactionCount),
                icon: Icons.receipt_long_rounded,
                color: AppColors.chart1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _metricCard(
                title: _tr('Average', 'میانگین', 'اوسط'),
                valueWidget: CurrencyDisplay(
                  amount: _averageSale,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                icon: Icons.analytics_rounded,
                color: AppColors.chart2,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _metricCard(
                title: _tr('Cash / Qarz', 'نقد / قرض', 'نغد / قرض'),
                value: '${_salePercent(_cashSales)} / ${_salePercent(_creditSales)}',
                icon: Icons.filter_alt_rounded,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentBreakdown(ThemeData theme) {
    final total = _cashSales + _creditSales + _mixedSales;
    final cashPct = total == 0 ? 0.0 : (_cashSales / total) * 100;
    final creditPct = total == 0 ? 0.0 : (_creditSales / total) * 100;
    final mixedPct = total == 0 ? 0.0 : (_mixedSales / total) * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_tr('Payment breakdown', 'تفکیک روش پرداخت', 'د تادیې وېش'), style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            _breakdownRow(_tr('Cash', 'نقد', 'نغد'), _cashSales, cashPct, AppColors.success),
            _breakdownRow(_tr('Qarz', 'قرض', 'قرض'), _creditSales, creditPct, AppColors.danger),
            _breakdownRow(_tr('Split', 'ترکیبی', 'ګډ'), _mixedSales, mixedPct, AppColors.chart2),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSplitChart(ThemeData theme) {
    final total = _cashSales + _creditSales + _mixedSales;

    if (total <= 0) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Text(_tr('No payment data to chart', 'داده‌ای برای نمودار پرداخت وجود ندارد', 'د تادیې چارټ لپاره معلومات نشته')),
        ),
      );
    }

    final sections = <PieChartSectionData>[
      PieChartSectionData(
        value: _cashSales,
        color: AppColors.success,
        title: '${_nf(((_cashSales / total) * 100))}%',
        radius: 56,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      PieChartSectionData(
        value: _creditSales,
        color: AppColors.danger,
        title: '${_nf(((_creditSales / total) * 100))}%',
        radius: 56,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      PieChartSectionData(
        value: _mixedSales,
        color: AppColors.chart2,
        title: '${_nf(((_mixedSales / total) * 100))}%',
        radius: 56,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_tr('Payment method split', 'سهم روش‌های پرداخت', 'د تادیې طریقو وېش'), style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 190,
              child: RepaintBoundary(
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    sectionsSpace: 2,
                    centerSpaceRadius: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _legendItem(_tr('Cash', 'نقد', 'نغد'), AppColors.success),
                _legendItem(_tr('Qarz', 'قرض', 'قرض'), AppColors.danger),
                _legendItem(_tr('Split', 'ترکیبی', 'ګډ'), AppColors.chart2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }

  Widget _breakdownRow(String label, double amount, double pct, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          CurrencyDisplay(
            amount: amount,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 52,
            child: Text('${_nf(pct, d: 1)}%', textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProducts(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_tr('Top products', 'پرفروش‌ترین', 'تر ټولو ډېر پلورل شوي توکي'), style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            if (_topProducts.isEmpty)
              Text(_tr('No data to display', 'داده‌ای برای نمایش وجود ندارد', 'د ښودلو لپاره معلومات نشته'))
            else
              ..._topProducts.asMap().entries.map((entry) {
                final rank = entry.key + 1;
                final p = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text('${_nf(rank)}. ', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text(p.key, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      Text(_tr('${_nf(p.value)} times', '${_nf(p.value)} بار', '${_nf(p.value)} ځله')),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  String _salePercent(double value) {
    final total = _cashSales + _creditSales + _mixedSales;
    if (total == 0) return '${_nf(0)}%';
    return '${_nf(((value / total) * 100))}%';
  }

  Future<void> _exportPdf() async {
    final calendarSystem = ref.read(appCalendarSystemProvider);
    final calendarType = calendarSystem == CalendarSystem.persian ? CalendarType.persian : CalendarType.gregorian;
    try {
      final file = await ref.read(reportsProvider.notifier).runReportGeneration('sales_pdf', () async {
        return PdfGenerator.generateSalesReportPdf(
          startDate: _startDate,
          endDate: _endDate,
          totalRevenue: _totalRevenue,
          transactionCount: _transactionCount,
          averageSale: _averageSale,
          cashSales: _cashSales,
          creditSales: _creditSales,
          mixedSales: _mixedSales,
          topProducts: _topProducts,
          calendar: calendarType,
          locale: _lang,
        );
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _tr(
              'PDF saved: ${file.path}',
              'PDF ذخیره شد: ${file.path}',
              'PDF خوندي شو: ${file.path}',
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('Failed to generate PDF: $e', 'تولید PDF ناموفق بود: $e', 'د PDF جوړول ناکام شو: $e'))),
      );
    }
  }

  Widget _metricCard({
    required String title,
    String? value,
    Widget? valueWidget,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 2),
                  if (valueWidget != null)
                    valueWidget
                  else
                    Text(
                      value ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
