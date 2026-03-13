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

class QarzReportScreen extends ConsumerStatefulWidget {
  const QarzReportScreen({super.key});

  @override
  ConsumerState<QarzReportScreen> createState() => _QarzReportScreenState();
}

class _QarzReportScreenState extends ConsumerState<QarzReportScreen> {
  bool _loading = true;
  double _totalOutstanding = 0;
  int _openCount = 0;
  int _overdueCount = 0;
  List<_CustomerDebt> _customerDebts = const [];
  List<_AtRiskCustomer> _atRiskCustomers = const [];
  List<double> _monthlyNewDebts = const [];
  List<double> _monthlyCollections = const [];
  List<double> _collectionRateTrend = const [];
  List<String> _monthLabels = const [];

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportsProvider.notifier).trackReportView('qarz');
    });
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);

    final debts = await db.debtsDao.getDebtsByShopId(shopId);
    final customers = await db.customersDao.getCustomersByShopId(shopId);
    final customerMap = {for (final c in customers) c.id: c};

    final openDebts = debts.where((d) => d.status != 'paid').toList();
    final totalOutstanding = openDebts.fold<double>(0, (sum, d) => sum + d.amountRemaining);
    final overdueCount = openDebts.where((d) => DateTime.now().difference(d.createdAt).inDays > 30).length;
    final allPayments = await db.debtsDao.getPaymentsByDateRange(DateTime(2000), DateTime.now().add(const Duration(days: 1)));
    final payments = allPayments.where((p) => p.shopId == shopId).toList();

    final Map<String, double> byCustomer = {};
    final Map<String, int> overdueByCustomer = {};
    final Map<String, DateTime> oldestOverdueByCustomer = {};
    for (final debt in openDebts) {
      byCustomer[debt.customerId] = (byCustomer[debt.customerId] ?? 0) + debt.amountRemaining;
      final overdueDays = DateTime.now().difference(debt.createdAt).inDays;
      if (overdueDays > 30) {
        overdueByCustomer[debt.customerId] = (overdueByCustomer[debt.customerId] ?? 0) + 1;
        final existingOldest = oldestOverdueByCustomer[debt.customerId];
        if (existingOldest == null || debt.createdAt.isBefore(existingOldest)) {
          oldestOverdueByCustomer[debt.customerId] = debt.createdAt;
        }
      }
    }

    final rows = byCustomer.entries
        .map((e) => _CustomerDebt(
            customerName: customerMap[e.key]?.name ?? _tr('Customer', 'مشتری', 'پېرودونکی'),
              amount: e.value,
            ))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final riskRows = byCustomer.entries
        .where((e) => overdueByCustomer[e.key] != null)
        .map((e) {
          final overdueItems = overdueByCustomer[e.key] ?? 0;
          final oldest = oldestOverdueByCustomer[e.key];
          final maxOverdueDays = oldest == null ? 0 : DateTime.now().difference(oldest).inDays;
          return _AtRiskCustomer(
            customerName: customerMap[e.key]?.name ?? _tr('Customer', 'مشتری', 'پېرودونکی'),
            totalAmount: e.value,
            overdueItems: overdueItems,
            maxOverdueDays: maxOverdueDays,
          );
        })
        .toList()
      ..sort((a, b) {
        final byDays = b.maxOverdueDays.compareTo(a.maxOverdueDays);
        if (byDays != 0) return byDays;
        return b.totalAmount.compareTo(a.totalAmount);
      });

    final now = DateTime.now();
    final monthStarts = List.generate(6, (i) {
      final dt = DateTime(now.year, now.month - (5 - i), 1);
      return DateTime(dt.year, dt.month, 1);
    });

    final calendarSystem = ref.read(appCalendarSystemProvider);
    final calendarType = calendarSystem == CalendarSystem.persian 
        ? CalendarType.persian 
        : CalendarType.gregorian;
    final monthLabels = monthStarts.map((m) =>
      calendarType == CalendarType.persian
        ? DateFormatter.getMonthNameForDate(m, calendar: calendarType, locale: _lang)
        : DateFormat('MMM', _lang).format(m)
    ).toList();
    final monthlyNewDebts = <double>[];
    final monthlyCollections = <double>[];
    final collectionRateTrend = <double>[];

    for (var i = 0; i < monthStarts.length; i++) {
      final start = monthStarts[i];
      final end = i == monthStarts.length - 1 ? DateTime(now.year, now.month + 1, 1) : monthStarts[i + 1];

      final monthDebts = debts.where((d) => !d.createdAt.isBefore(start) && d.createdAt.isBefore(end)).toList();
      final monthPayments = payments.where((p) => !p.createdAt.isBefore(start) && p.createdAt.isBefore(end)).toList();

      final newDebtAmount = monthDebts.fold<double>(0, (sum, d) => sum + d.amountOriginal);
      final collectedAmount = monthPayments.fold<double>(0, (sum, p) => sum + p.amount);
      final rate = newDebtAmount <= 0 ? 0.0 : ((collectedAmount / newDebtAmount) * 100).clamp(0, 200).toDouble();

      monthlyNewDebts.add(newDebtAmount);
      monthlyCollections.add(collectedAmount);
      collectionRateTrend.add(rate);
    }

    if (!mounted) return;
    setState(() {
      _totalOutstanding = totalOutstanding;
      _openCount = openDebts.length;
      _overdueCount = overdueCount;
      _customerDebts = rows.take(10).toList();
      _atRiskCustomers = riskRows.take(5).toList();
      _monthlyNewDebts = monthlyNewDebts;
      _monthlyCollections = monthlyCollections;
      _collectionRateTrend = collectionRateTrend;
      _monthLabels = monthLabels;
      _loading = false;
    });

    ref.read(reportsProvider.notifier).cacheReportData('qarz_summary', {
      'outstanding': _totalOutstanding,
      'open': _openCount,
      'overdue': _overdueCount,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGeneratingPdf = ref.watch(reportsProvider.select((s) => s.isGenerating['qarz_pdf'] ?? false));

    return Scaffold(
      appBar: AppBar(title: Text(_tr('Qarz Report', 'گزارش قرض', 'د قرض راپور'))),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_tr('Total owed to you', 'کل بدهی به شما', 'ټول پور چې تاسې ته پاتې دی'), style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('${_nf(_totalOutstanding)} ${_tr('AFN', '؋', '؋')}', style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 8),
                          Text(_tr('Open debts: ${_nf(_openCount)}', 'تعداد بدهی باز: ${_nf(_openCount)}', 'خلاص پورونه: ${_nf(_openCount)}')),
                          Text(_tr('Overdue 30+ days: ${_nf(_overdueCount)}', 'معوق ۳۰+ روز: ${_nf(_overdueCount)}', 'تر ۳۰+ ورځو ځنډېدلي: ${_nf(_overdueCount)}')),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(_tr('Top debtors', 'بیشترین بدهکاران', 'تر ټولو ډېر پوروړي'), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (_customerDebts.isEmpty)
                    Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(_tr('No data available', 'داده‌ای وجود ندارد', 'هیڅ معلومات نشته'))))
                  else
                    ..._customerDebts.map((row) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.person_outline_rounded),
                            title: Text(row.customerName),
                            trailing: Text('${_nf(row.amount)} ${_tr('AFN', '؋', '؋')}'),
                          ),
                        )),
                  const SizedBox(height: 12),
                  _buildDebtVsPaymentChart(context),
                  const SizedBox(height: 12),
                  _buildCollectionRateChart(context),
                  const SizedBox(height: 12),
                  Text(_tr('At-risk customers', 'مشتریان پرخطر', 'له خطر سره مخ پېرودونکي'), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (_atRiskCustomers.isEmpty)
                    Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(_tr('No high-risk customers', 'مشتری پرخطر وجود ندارد', 'لوړ خطر پېرودونکی نشته'))))
                  else
                    ..._atRiskCustomers.map((row) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                            title: Text(row.customerName),
                            subtitle: Text(_tr(
                              '${_nf(row.overdueItems)} overdue debts • ${_nf(row.maxOverdueDays)} days max',
                              '${_nf(row.overdueItems)} بدهی معوق • حداکثر ${_nf(row.maxOverdueDays)} روز',
                              '${_nf(row.overdueItems)} ځنډېدلي پورونه • تر ټولو زیات ${_nf(row.maxOverdueDays)} ورځې',
                            )),
                            trailing: Text('${_nf(row.totalAmount)} ${_tr('AFN', '؋', '؋')}'),
                          ),
                        )),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: isGeneratingPdf ? null : _exportPdf,
                      icon: const Icon(Icons.picture_as_pdf_rounded),
                      label: Text(isGeneratingPdf ? _tr('Generating...', 'در حال تولید...', 'جوړېږي...') : _tr('Download PDF', 'دانلود PDF', 'PDF ښکته کړئ')),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _exportPdf() async {
    final calendarSystem = ref.read(appCalendarSystemProvider);
    final calendarType = calendarSystem == CalendarSystem.persian ? CalendarType.persian : CalendarType.gregorian;
    try {
      final file = await ref.read(reportsProvider.notifier).runReportGeneration('qarz_pdf', () async {
        return PdfGenerator.generateQarzReportPdf(
          totalOutstanding: _totalOutstanding,
          openDebts: _openCount,
          overdueDebts: _overdueCount,
          topDebtors: _customerDebts.map((e) => MapEntry(e.customerName, e.amount)).toList(),
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

  Widget _buildDebtVsPaymentChart(BuildContext context) {
    final theme = Theme.of(context);
    final isRtl = Directionality.of(context).name == 'rtl';
    final labels = isRtl ? _monthLabels.reversed.toList() : _monthLabels;
    final debts = isRtl ? _monthlyNewDebts.reversed.toList() : _monthlyNewDebts;
    final payments = isRtl ? _monthlyCollections.reversed.toList() : _monthlyCollections;

    final maxDebt = debts.isEmpty ? 0 : debts.reduce((a, b) => a > b ? a : b);
    final maxPay = payments.isEmpty ? 0 : payments.reduce((a, b) => a > b ? a : b);
    final maxY = (maxDebt > maxPay ? maxDebt : maxPay);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_tr('New debts vs payments', 'بدهی جدید در برابر پرداخت‌ها', 'نوی پورونه د تادیو پر وړاندې'), style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 210,
              child: RepaintBoundary(
                child: BarChart(
                  BarChartData(
                    maxY: (maxY <= 0 ? 1 : maxY * 1.2),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
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
                    barGroups: List.generate(labels.length, (i) {
                      return BarChartGroupData(
                        x: i,
                        barsSpace: 4,
                        barRods: [
                          BarChartRodData(toY: i < debts.length ? debts[i] : 0, width: 10, color: Colors.orange, borderRadius: BorderRadius.circular(4)),
                          BarChartRodData(toY: i < payments.length ? payments[i] : 0, width: 10, color: Colors.green, borderRadius: BorderRadius.circular(4)),
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

  Widget _buildCollectionRateChart(BuildContext context) {
    final theme = Theme.of(context);
    final isRtl = Directionality.of(context).name == 'rtl';
    final labels = isRtl ? _monthLabels.reversed.toList() : _monthLabels;
    final trend = isRtl ? _collectionRateTrend.reversed.toList() : _collectionRateTrend;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_tr('Collection rate trend', 'روند نرخ وصول', 'د راټولولو کچې بهیر'), style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: RepaintBoundary(
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 100,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
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
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(trend.length, (i) => FlSpot(i.toDouble(), trend[i].clamp(0, 100))),
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        dotData: const FlDotData(show: true),
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
}

class _CustomerDebt {
  final String customerName;
  final double amount;

  _CustomerDebt({required this.customerName, required this.amount});
}

class _AtRiskCustomer {
  final String customerName;
  final double totalAmount;
  final int overdueItems;
  final int maxOverdueDays;

  _AtRiskCustomer({
    required this.customerName,
    required this.totalAmount,
    required this.overdueItems,
    required this.maxOverdueDays,
  });
}
