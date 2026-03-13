import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;

import '../../../core/auth/guest_mode_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/sync/sync_service.dart';
import '../../../core/utils/number_system_formatter.dart';

class StockTakeScreen extends ConsumerStatefulWidget {
  const StockTakeScreen({super.key});

  @override
  ConsumerState<StockTakeScreen> createState() => _StockTakeScreenState();
}

class _StockTakeScreenState extends ConsumerState<StockTakeScreen> {
  bool _loading = true;
  bool _saving = false;
  String _query = '';
  List<Product> _products = const [];
  final Map<String, double> _counted = {};
  final Map<String, TextEditingController> _countControllers = {};

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);
    final products = await db.productsDao.getAllProducts(shopId);

    if (!mounted) return;
    setState(() {
      _products = products.where((p) => p.isActive).toList();
      for (final p in _products) {
        final initial = _counted[p.id] ?? p.stockQuantity;
        _counted[p.id] = initial;
        _countControllers.putIfAbsent(p.id, () => TextEditingController(text: initial.toStringAsFixed(0)));
      }
      _loading = false;
    });
  }

  @override
  void dispose() {
    for (final c in _countControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _scan() async {
    final result = await Navigator.pushNamed(context, '/sales/barcode');
    if (!mounted || result == null || result is! Map<String, dynamic>) return;
    final productId = result['productId']?.toString();
    if (productId == null || productId.isEmpty) return;

    final product = _products.where((p) => p.id == productId).toList();
    if (product.isEmpty) return;

    final current = _counted[productId] ?? product.first.stockQuantity;
    setState(() => _counted[productId] = current + 1);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_tr('${product.first.nameDari} counted', '${product.first.nameDari} شمارش شد', '${product.first.nameDari} وشمېرل شو'))),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);
    final syncEnabled = !(await GuestModeService.isGuestMode());
    final nowIso = DateTime.now().toIso8601String();

    try {
      for (final p in _products) {
        final after = _counted[p.id] ?? p.stockQuantity;
        final before = p.stockQuantity;
        final change = after - before;
        if (change == 0) continue;
        final adjustmentId = 'local_adj_${DateTime.now().microsecondsSinceEpoch}';

        await db.productsDao.updateStock(p.id, after);
        await db.into(db.inventoryAdjustments).insert(
          InventoryAdjustmentsCompanion(
            id: Value(adjustmentId),
            shopId: Value(shopId),
            productId: Value(p.id),
            quantityBefore: Value(before),
            quantityAfter: Value(after),
            quantityChange: Value(change),
            reason: const Value('stock_take'),
          ),
        );

        if (syncEnabled) {
          await SyncService.instance.enqueueOperation(
            shopId: shopId,
            targetTable: 'products',
            recordId: p.id,
            operation: 'UPDATE',
            payload: {
              'id': p.id,
              'shop_id': p.shopId,
              'name_dari': p.nameDari,
              'name_pashto': p.namePashto,
              'name_en': p.nameEn,
              'barcode': p.barcode,
              'price': p.price,
              'cost_price': p.costPrice,
              'stock_quantity': after,
              'min_stock_alert': p.minStockAlert,
              'unit': p.unit,
              'updated_at': nowIso,
            },
          );

          await SyncService.instance.enqueueOperation(
            shopId: shopId,
            targetTable: 'inventory_adjustments',
            recordId: adjustmentId,
            operation: 'INSERT',
            payload: {
              'id': adjustmentId,
              'shop_id': shopId,
              'product_id': p.id,
              'quantity_before': before,
              'quantity_after': after,
              'quantity_change': change,
              'reason': 'stock_take',
              'adjusted_at': nowIso,
            },
          );
        }
      }

      if (!mounted) return;
      Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_tr('Stock take saved', 'شمارش موجودی ذخیره شد', 'د زېرمې شمېرنه خوندي شوه'))));
    } catch (e) {
      if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_tr('Error: $e', 'خطا: $e', 'تېروتنه: $e'))));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _products.where((p) {
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase();
      return p.nameDari.toLowerCase().contains(q) || (p.barcode?.toLowerCase().contains(q) ?? false);
    }).toList();
    final changedCount = _products.where((p) => ((_counted[p.id] ?? p.stockQuantity) - p.stockQuantity) != 0).length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
            title: Text(_tr('Stock Take', 'شمارش موجودی', 'د زېرمې شمېرنه')),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_tr('Counted items', 'اقلام شمارش‌شده', 'شمېرل شوي توکي')),
                        Text(_nf(filtered.length), style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text(_tr('Changed: ${_nf(changedCount)}', 'تغییر کرده: ${_nf(changedCount)}', 'بدل شوي: ${_nf(changedCount)}'), style: const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded),
                          hintText: _tr('Scan or search', 'اسکن یا جستجو کنید', 'سکین یا لټون وکړئ'),
                    ),
                  ),
                  const SizedBox(height: 8),
                      FilledButton.icon(onPressed: _scan, icon: const Icon(Icons.qr_code_scanner_rounded), label: Text(_tr('Scan barcode', 'اسکن بارکد', 'بارکوډ سکین کړئ'))),
                  const SizedBox(height: 12),
                  Expanded(
                    child: filtered.isEmpty
                            ? Center(child: Text(_tr('No products found', 'محصولی یافت نشد', 'هیڅ محصول ونه موندل شو')))
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final p = filtered[index];
                              final counted = _counted[p.id] ?? p.stockQuantity;
                              final diff = counted - p.stockQuantity;
                              final controller = _countControllers[p.id] ??= TextEditingController(text: counted.toStringAsFixed(0));
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.nameDari, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                              Expanded(child: Text(_tr('System: ${_nf(p.stockQuantity)}', 'سیستم: ${_nf(p.stockQuantity)}', 'سیستم: ${_nf(p.stockQuantity)}'))),
                                          const SizedBox(width: 8),
                                          SizedBox(
                                            width: 120,
                                            child: TextField(
                                              controller: controller,
                                              keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(labelText: _tr('You', 'شما', 'تاسې')),
                                              onChanged: (v) {
                                                final parsed = double.tryParse(v);
                                                if (parsed != null) {
                                                  setState(() {
                                                    _counted[p.id] = parsed;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                            '${_tr('Difference', 'تفاوت', 'توپیر')}: ${diff >= 0 ? '+' : ''}${_nf(diff)}',
                                        style: TextStyle(color: diff == 0 ? Colors.green : Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.check_rounded),
                        label: Text(_saving ? _tr('Saving...', 'در حال ذخیره...', 'خوندي کېدونکي...') : _tr('Confirm & Save', 'تایید و ذخیره', 'تایید او خوندي کړئ')),
                  ),
                ],
              ),
            ),
    );
  }
}
