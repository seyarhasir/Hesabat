import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../core/utils/pdf_generator.dart';
import '../../../core/utils/date_formatter.dart';
import '../providers/reports_provider.dart';
import '../../../shared/widgets/currency_display.dart';
import '../../../core/settings/calendar_system_provider.dart';
import '../../../core/settings/currency_preference_provider.dart';
import '../../../core/utils/currency_formatter.dart';

class CustomerReportScreen extends ConsumerStatefulWidget {
  const CustomerReportScreen({super.key});

  @override
  ConsumerState<CustomerReportScreen> createState() => _CustomerReportScreenState();
}

class _CustomerReportScreenState extends ConsumerState<CustomerReportScreen> {
  bool _loading = true;
  List<MapEntry<String, double>> _topCustomers = const [];
  int _newCustomers = 0;
  int _returningCustomers = 0;
  List<_AtRiskRow> _atRisk = const [];
  List<_PurchaseRow> _history = const [];

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);
  String _na(String s) => NumberSystemFormatter.apply(s);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportsProvider.notifier).trackReportView('customers');
    });
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);

    final customers = await db.customersDao.getCustomersByShopId(shopId);
    final customerMap = {for (final c in customers) c.id: c};

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    final sales = await db.salesDao.getSalesByDateRange(shopId, monthStart, now.add(const Duration(days: 1)));
    final Map<String, double> revenueByCustomer = {};
    final Map<String, int> salesCountByCustomer = {};

    for (final s in sales) {
      final cid = s.customerId;
      if (cid == null || cid.isEmpty) continue;
      revenueByCustomer[cid] = (revenueByCustomer[cid] ?? 0) + s.totalAfn;
      salesCountByCustomer[cid] = (salesCountByCustomer[cid] ?? 0) + 1;
    }

    final topCustomers = revenueByCustomer.entries
        .map((e) => MapEntry(customerMap[e.key]?.name ?? _tr('Customer', 'مشتری', 'پېرودونکی'), e.value))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final newCustomers = customers.where((c) => !c.createdAt.isBefore(monthStart)).length;
    final returningCustomers = salesCountByCustomer.entries.where((e) {
      final c = customerMap[e.key];
      return c != null && c.createdAt.isBefore(monthStart) && e.value > 0;
    }).length;

    final debts = await db.debtsDao.getDebtsByShopId(shopId);
    final Map<String, _AtRiskRow> riskMap = {};
    for (final d in debts.where((d) => d.status != 'paid')) {
      final overdue = DateTime.now().difference(d.createdAt).inDays;
      if (overdue <= 30) continue;
      final name = customerMap[d.customerId]?.name ?? _tr('Customer', 'مشتری', 'پېرودونکی');
      final current = riskMap[d.customerId];
      riskMap[d.customerId] = _AtRiskRow(
        customerName: name,
        amount: (current?.amount ?? 0) + d.amountRemaining,
        overdueDays: overdue > (current?.overdueDays ?? 0) ? overdue : (current?.overdueDays ?? 0),
      );
    }
    final atRisk = riskMap.values.toList()
      ..sort((a, b) {
        final byDays = b.overdueDays.compareTo(a.overdueDays);
        if (byDays != 0) return byDays;
        return b.amount.compareTo(a.amount);
      });

    final recentSales = [...sales]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final history = recentSales
        .where((s) => (s.customerId?.isNotEmpty ?? false))
        .take(12)
        .map(
          (s) => _PurchaseRow(
            customerName: customerMap[s.customerId!]?.name ?? _tr('Customer', 'مشتری', 'پېرودونکی'),
            amount: s.totalAfn,
            date: s.createdAt,
          ),
        )
        .toList();

    if (!mounted) return;
    setState(() {
      _topCustomers = topCustomers.take(8).toList();
      _newCustomers = newCustomers;
      _returningCustomers = returningCustomers;
      _atRisk = atRisk.take(5).toList();
      _history = history;
      _loading = false;
    });

    ref.read(reportsProvider.notifier).cacheReportData('customer_summary', {
      'new': _newCustomers,
      'returning': _returningCustomers,
      'top_count': _topCustomers.length,
      'at_risk_count': _atRisk.length,
    });
  }

  @override
  Widget build(BuildContext context) {
    final calendarSystem = ref.watch(appCalendarSystemProvider);
    final calendarType = calendarSystem == CalendarSystem.persian 
        ? CalendarType.persian 
        : CalendarType.gregorian;
    final dateFmt = DateFormat('yyyy/MM/dd');
    final isGeneratingPdf = ref.watch(reportsProvider.select((s) => s.isGenerating['customer_pdf'] ?? false));

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('Customer Report', 'گزارش مشتریان', 'د پېرودونکو راپور')),
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
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_tr('New vs returning (this month)', 'جدید در برابر بازگشتی (این ماه)', 'نوي د بېرته راتلونکو پر وړاندې (دې میاشت کې)'), style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(_tr('New customers: ${_nf(_newCustomers)}', 'مشتری جدید: ${_nf(_newCustomers)}', 'نوي پېرودونکي: ${_nf(_newCustomers)}')),
                          Text(_tr('Returning customers: ${_nf(_returningCustomers)}', 'مشتری بازگشتی: ${_nf(_returningCustomers)}', 'بېرته راغلي پېرودونکي: ${_nf(_returningCustomers)}')),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(_tr('Top customers by revenue', 'بهترین مشتریان بر اساس درآمد', 'د عاید له مخې غوره پېرودونکي'), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (_topCustomers.isEmpty)
                    Card(child: Padding(padding: const EdgeInsets.all(14), child: Text(_tr('No customer sales data', 'داده فروش مشتری وجود ندارد', 'د پېرودونکو د پلور معلومات نشته'))))
                  else
                    ..._topCustomers.map(
                      (e) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.person_outline_rounded),
                          title: Text(e.key),
                          trailing: CurrencyDisplay(
                            amount: e.value,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(_tr('At-risk customers', 'مشتریان پرخطر', 'له خطر سره مخ پېرودونکي'), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (_atRisk.isEmpty)
                    Card(child: Padding(padding: const EdgeInsets.all(14), child: Text(_tr('No high-risk customers', 'مشتری پرخطر وجود ندارد', 'لوړ خطر پېرودونکی نشته'))))
                  else
                    ..._atRisk.map(
                      (r) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                          title: Text(r.customerName),
                          subtitle: Text(_tr(
                            '${_nf(r.overdueDays)} days overdue',
                            '${_nf(r.overdueDays)} روز معوق',
                            '${_nf(r.overdueDays)} ورځې ځنډ',
                          )),
                          trailing: CurrencyDisplay(
                            amount: r.amount,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(_tr('Customer purchase history', 'تاریخچه خرید مشتری', 'د پېرودونکو د پېرود تاریخچه'), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (_history.isEmpty)
                    Card(child: Padding(padding: const EdgeInsets.all(14), child: Text(_tr('No history data', 'داده تاریخچه وجود ندارد', 'د تاریخچې معلومات نشته'))))
                  else
                    ..._history.map(
                      (h) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.receipt_long_rounded),
                          title: Text(h.customerName),
                          subtitle: Text(_na(DateFormatter.formatDate(h.date, calendar: calendarType, locale: _lang))),
                          trailing: CurrencyDisplay(
                            amount: h.amount,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
    );
  }

  Future<void> _exportPdf() async {
    final calendarSystem = ref.read(appCalendarSystemProvider);
    final calendarType = calendarSystem == CalendarSystem.persian 
        ? CalendarType.persian 
        : CalendarType.gregorian;
    try {
      final file = await ref.read(reportsProvider.notifier).runReportGeneration('customer_pdf', () async {
        return PdfGenerator.generateCustomerReportPdf(
          newCustomers: _newCustomers,
          returningCustomers: _returningCustomers,
          topCustomers: _topCustomers,
          atRiskCustomers: _atRisk.map((e) => MapEntry(e.customerName, e.amount)).toList(),
          purchaseHistory: () {
            final currency = ref.read(currencyPreferenceProvider);
            return _history.map((e) {
              final dateStr = DateFormatter.formatDate(e.date, calendar: calendarType, locale: _lang);
              final amountStr = CurrencyFormatter.format(e.amount, currency);
              return '$dateStr — ${e.customerName} — $amountStr';
            }).toList();
          }(),
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

class _AtRiskRow {
  final String customerName;
  final double amount;
  final int overdueDays;
  const _AtRiskRow({required this.customerName, required this.amount, required this.overdueDays});
}

class _PurchaseRow {
  final String customerName;
  final double amount;
  final DateTime date;
  const _PurchaseRow({required this.customerName, required this.amount, required this.date});
}
