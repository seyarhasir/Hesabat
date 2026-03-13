import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/settings/calendar_system_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../core/utils/pdf_generator.dart';
import '../providers/reports_provider.dart';

class InventoryReportScreen extends ConsumerStatefulWidget {
  const InventoryReportScreen({super.key});

  @override
  ConsumerState<InventoryReportScreen> createState() => _InventoryReportScreenState();
}

class _InventoryReportScreenState extends ConsumerState<InventoryReportScreen> {
  bool _loading = true;
  double _inventoryValue = 0;
  int _totalProducts = 0;
  int _lowStockCount = 0;
  List<_LabeledValue> _categoryBreakdown = const [];
  List<_Mover> _fastMovers = const [];
  List<_Mover> _slowMovers = const [];

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportsProvider.notifier).trackReportView('inventory');
    });
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);

    final value = await db.productsDao.getInventoryValue(shopId);
    final total = await db.productsDao.countProducts(shopId);
    final low = await db.productsDao.countLowStock(shopId);
    final products = await db.productsDao.getAllProducts(shopId);
    final categories = await (db.select(db.categories)..where((c) => c.shopId.equals(shopId))).get();
    final categoryMap = {for (final c in categories) c.id: (c.namePashto ?? c.nameDari)};

    final Map<String, int> byCategory = {};
    for (final p in products.where((p) => p.isActive)) {
      final key = p.categoryId == null ? _tr('Uncategorized', 'بدون دسته', 'بې کټګورۍ') : (categoryMap[p.categoryId!] ?? _tr('Other', 'سایر', 'نور'));
      byCategory[key] = (byCategory[key] ?? 0) + 1;
    }
    final categoryBreakdown = byCategory.entries
        .map((e) => _LabeledValue(e.key, e.value.toDouble()))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final now = DateTime.now();
    final last30Start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 30));
    final sales = await db.salesDao.getSalesByDateRange(shopId, last30Start, now.add(const Duration(days: 1)));
    final Map<String, double> soldQtyByProduct = {};
    for (final sale in sales) {
      final items = await db.salesDao.getSaleItems(sale.id);
      for (final item in items) {
        final pid = item.productId;
        if (pid == null || pid.isEmpty) continue;
        soldQtyByProduct[pid] = (soldQtyByProduct[pid] ?? 0) + item.quantity;
      }
    }

    final movers = products.where((p) => p.isActive).map((p) {
      final sold = soldQtyByProduct[p.id] ?? 0;
      return _Mover(name: p.namePashto ?? p.nameDari, sold: sold);
    }).toList();

    final fastMovers = [...movers]..sort((a, b) => b.sold.compareTo(a.sold));
    final slowMovers = [...movers]..sort((a, b) => a.sold.compareTo(b.sold));

    if (!mounted) return;
    setState(() {
      _inventoryValue = value;
      _totalProducts = total;
      _lowStockCount = low;
      _categoryBreakdown = categoryBreakdown.take(6).toList();
      _fastMovers = fastMovers.take(5).toList();
      _slowMovers = slowMovers.take(5).toList();
      _loading = false;
    });

    ref.read(reportsProvider.notifier).cacheReportData('inventory_summary', {
      'value': _inventoryValue,
      'products': _totalProducts,
      'low_stock': _lowStockCount,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGeneratingPdf = ref.watch(reportsProvider.select((s) => s.isGenerating['inventory_pdf'] ?? false));

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('Inventory Report', 'گزارش موجودی', 'د زېرمې راپور')),
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
                    child: ListTile(
                      leading: const Icon(Icons.payments_rounded),
                      title: Text(_tr('Inventory value', 'ارزش موجودی', 'د زېرمې ارزښت')),
                      trailing: Text('${_nf(_inventoryValue)} ${_tr('AFN', '؋', '؋')}'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.inventory_2_rounded),
                      title: Text(_tr('Total products', 'تعداد محصولات', 'ټول محصولات')),
                      trailing: Text(_nf(_totalProducts)),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.warning_amber_rounded),
                      title: Text(_tr('Low stock', 'کم‌موجود', 'کمه زېرمه')),
                      trailing: Text(_nf(_lowStockCount)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryBreakdown(context),
                  const SizedBox(height: 12),
                  _buildMoversCard(
                    context,
                    title: _tr('Fast movers (30d)', 'پرفروش‌ها (۳۰ روز)', 'ژر پلورل کېدونکي (۳۰ ورځې)'),
                    items: _fastMovers,
                    icon: Icons.trending_up_rounded,
                    iconColor: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildMoversCard(
                    context,
                    title: _tr('Slow movers (30d)', 'کم‌فروش‌ها (۳۰ روز)', 'ورو پلورل کېدونکي (۳۰ ورځې)'),
                    items: _slowMovers,
                    icon: Icons.trending_down_rounded,
                    iconColor: Colors.orange,
                  ),
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
      final file = await ref.read(reportsProvider.notifier).runReportGeneration('inventory_pdf', () async {
        return PdfGenerator.generateInventoryReportPdf(
          inventoryValue: _inventoryValue,
          totalProducts: _totalProducts,
          lowStockCount: _lowStockCount,
          categoryBreakdown: _categoryBreakdown.map((e) => MapEntry(e.label, e.value)).toList(),
          fastMovers: _fastMovers.map((m) => MapEntry(m.name, m.sold)).toList(),
          slowMovers: _slowMovers.map((m) => MapEntry(m.name, m.sold)).toList(),
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

  Widget _buildCategoryBreakdown(BuildContext context) {
    final theme = Theme.of(context);
    if (_categoryBreakdown.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(_tr('No category data', 'داده دسته‌بندی وجود ندارد', 'د کټګورۍ معلومات نشته')),
        ),
      );
    }

    final total = _categoryBreakdown.fold<double>(0, (sum, e) => sum + e.value);
    final palette = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.teal, Colors.red];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_tr('Category breakdown', 'تفکیک دسته‌بندی', 'د کټګورۍ وېش'), style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: RepaintBoundary(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 28,
                    sections: List.generate(_categoryBreakdown.length, (i) {
                      final e = _categoryBreakdown[i];
                      final pct = total == 0 ? 0 : (e.value / total) * 100;
                      return PieChartSectionData(
                        value: e.value,
                        color: palette[i % palette.length],
                        title: '${_nf(pct)}%',
                        radius: 56,
                        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      );
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: List.generate(_categoryBreakdown.length, (i) {
                final e = _categoryBreakdown[i];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: palette[i % palette.length], shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text('${e.label} (${_nf(e.value)})'),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoversCard(
    BuildContext context, {
    required String title,
    required List<_Mover> items,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (items.isEmpty)
              Text(_tr('No movement data', 'داده حرکتی وجود ندارد', 'د خوځښت معلومات نشته'))
            else
              ...items.map(
                (m) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(icon, color: iconColor),
                  title: Text(m.name),
                  trailing: Text(_nf(m.sold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LabeledValue {
  final String label;
  final double value;
  _LabeledValue(this.label, this.value);
}

class _Mover {
  final String name;
  final double sold;
  _Mover({required this.name, required this.sold});
}
