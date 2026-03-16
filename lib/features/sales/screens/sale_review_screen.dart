import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../../core/auth/guest_mode_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/sync/sync_service.dart';
import '../../../core/settings/calendar_system_provider.dart';
import '../../../core/utils/exchange_rate_service.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../shared/widgets/currency_selector.dart';

class SaleReviewScreen extends ConsumerStatefulWidget {
  const SaleReviewScreen({super.key});

  @override
  ConsumerState<SaleReviewScreen> createState() => _SaleReviewScreenState();
}

class _SaleReviewScreenState extends ConsumerState<SaleReviewScreen> {
  String _paymentMethod = 'cash';
  String _selectedCurrency = 'AFN';
  double _discount = 0;
  double _mixedPaidAfn = 0;
  String? _selectedCustomerId;
  String? _selectedCustomerName;
  bool _isSaving = false;
  Map<String, double> _afnToRate = const {'AFN': 1.0, 'USD': 0.013, 'PKR': 3.6};
  DateTime? _ratesUpdatedAt;

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);
  String _na(String s) => NumberSystemFormatter.apply(s);

  @override
  void initState() {
    super.initState();
    _loadRates();
  }

  Future<void> _loadRates() async {
    final snapshot = await ExchangeRateService.instance.getLatestSnapshot(preferFresh: false);
    if (!mounted) return;
    setState(() {
      _afnToRate = snapshot.ratesFromAfn;
      _ratesUpdatedAt = snapshot.fetchedAt;
    });
  }

  double _totalAfterDiscount(double subtotal) {
    final total = subtotal - _discount;
    return total < 0 ? 0 : total;
  }

  double _afnToSelected(double afnAmount) {
    if (_selectedCurrency == 'AFN') return afnAmount;
    final rate = _afnToRate[_selectedCurrency] ?? 0;
    if (rate <= 0) return afnAmount;
    return afnAmount * rate;
  }

  double _selectedToAfn(double amount) {
    if (_selectedCurrency == 'AFN') return amount;
    final afnToSelected = _afnToRate[_selectedCurrency] ?? 0;
    if (afnToSelected <= 0) return amount;
    return amount / afnToSelected;
  }

  String _currencySymbol(String code) {
    switch (code) {
      case 'USD':
        return r'$';
      case 'PKR':
        return '₨';
      default:
        return _tr('؋', '؋', '؋');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final items = (args?['items'] as List<dynamic>? ?? const []).cast<Map<String, dynamic>>();
    final subtotal = (args?['total'] as num?)?.toDouble() ?? 0;
    final totalAfn = _totalAfterDiscount(subtotal);
    final subtotalSelected = _afnToSelected(subtotal);
    final discountSelected = _afnToSelected(_discount);
    final totalSelected = _afnToSelected(totalAfn);

    return Scaffold(
      appBar: AppBar(title: Text(_tr('Review Sale', 'بررسی فروش', 'د پلور بیاکتنه'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: items.isEmpty
                  ? Center(child: Text(_tr('Cart is empty', 'سبد خرید خالی است', 'ستاسو کڅوړه خالي ده')))
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final quantity = (item['quantity'] as num?)?.toDouble() ?? 0;
                        final price = (item['price'] as num?)?.toDouble() ?? 0;
                        final subtotal = quantity * price;

                        return Card(
                          child: ListTile(
                            title: Text(item['name']?.toString() ?? '-'),
                            subtitle: Text('${_nf(quantity)} × ${_nf(price)} ${_tr('AFN', '؋', '؋')}'),
                            trailing: Text('${_nf(subtotal)} ${_tr('AFN', '؋', '؋')}'),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _openCustomerPicker,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person_outline_rounded),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            _selectedCustomerName ?? _tr('Customer', 'مشتری', 'پېرودونکی'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _openCurrencySelector,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.currency_exchange_rounded),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            _selectedCurrency,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _openDiscountEntry,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.percent_rounded),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            _tr('Discount', 'تخفیف', 'تخفیف'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_tr('Subtotal:', 'جمع فرعی:', 'فرعي مجموعه:')),
                        Text('${_nf(subtotalSelected, d: 2)} ${_currencySymbol(_selectedCurrency)}'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_tr('Discount:', 'تخفیف:', 'تخفیف:')),
                        Text('${_nf(discountSelected, d: 2)} ${_currencySymbol(_selectedCurrency)}'),
                      ],
                    ),
                    const Divider(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_tr('Total:', 'جمع کل:', 'ټول:')),
                        Text('${_nf(totalSelected, d: 2)} ${_currencySymbol(_selectedCurrency)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                    if (_selectedCurrency != 'AFN')
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _na(_tr('AFN: ${_nf(totalAfn)} ؋', 'افغانی: ${_nf(totalAfn)} ؋', 'افغانۍ: ${_nf(totalAfn)} ؋')),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_tr('Payment method', 'روش پرداخت', 'د تادیې طریقه')),
                        Text(
                          _labelForMethod(_paymentMethod),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _paymentChip('cash', Icons.payments_rounded, totalAfn: totalAfn),
                        _paymentChip('credit', Icons.person_outline_rounded, totalAfn: totalAfn),
                        _paymentChip('mixed', Icons.swap_horiz_rounded, totalAfn: totalAfn),
                      ],
                    ),
                    if (_paymentMethod == 'mixed')
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _tr(
                                'Part paid now, remaining goes to Qarz.',
                                'بخشی نقد پرداخت می‌شود و باقی به قرض می‌رود.',
                                'یوه برخه اوس ورکول کېږي او پاتې قرض ته ځي.',
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_tr('Paid now', 'پرداخت فعلی', 'اوس تادیه شوی')),
                                Text(
                                  '${_nf(_afnToSelected(_mixedPaidAfn), d: 2)} ${_currencySymbol(_selectedCurrency)}',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_tr('Remaining debt', 'باقی‌مانده قرض', 'پاتې قرض')),
                                Text(
                                  '${_nf(_afnToSelected((totalAfn - _mixedPaidAfn).clamp(0.0, totalAfn)), d: 2)} ${_currencySymbol(_selectedCurrency)}',
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: () => _openMixedPaymentEntry(totalAfn),
                                icon: const Icon(Icons.edit_rounded),
                                label: Text(_tr('Edit split', 'ویرایش تقسیم', 'وېش سمول')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_paymentMethod == 'credit' && _selectedCustomerName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _selectedCustomerName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : () => _confirmSale(items, subtotal, totalAfn),
                icon: const Icon(Icons.check_circle_rounded),
                label: Text(_isSaving ? _tr('Saving...', 'در حال ثبت...', 'خوندي کېږي...') : _tr('Confirm Sale', 'تایید فروش', 'پلور تاییدول')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _labelForMethod(String method) {
    switch (method) {
      case 'credit':
        return _tr('Qarz', 'قرض', 'پور');
      case 'mixed':
        return _tr('Split', 'ترکیبی', 'ګډ');
      default:
        return _tr('Cash', 'نقد', 'نغد');
    }
  }

  Future<void> _openMixedPaymentEntry(double totalAfn) async {
    final totalSelected = _afnToSelected(totalAfn);
    final initialSelected = _afnToSelected(_mixedPaidAfn);
    final controller = TextEditingController(text: _nf(initialSelected, d: 2));

    final value = await showModalBottomSheet<double>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _tr('Split payment', 'پرداخت ترکیبی', 'ګډه تادیه'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _tr(
                    'Enter amount paid now',
                    'مبلغ پرداخت فعلی را وارد کنید',
                    'اوس ورکړل شوې اندازه ولیکئ',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: _tr('Paid now', 'پرداخت فعلی', 'اوس تادیه شوی'),
                  suffixText: _selectedCurrency,
                  helperText: _tr(
                    'Max: ${_nf(totalSelected, d: 2)} ${_selectedCurrency}',
                    'حداکثر: ${_nf(totalSelected, d: 2)} ${_selectedCurrency}',
                    'اعظمي: ${_nf(totalSelected, d: 2)} ${_selectedCurrency}',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final parsed = double.tryParse(controller.text.trim()) ?? 0;
                    final clamped = parsed.clamp(0.0, totalSelected);
                    Navigator.pop(context, _selectedToAfn(clamped.toDouble()));
                  },
                  child: Text(_tr('Confirm', 'تایید', 'تایید')),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (value != null && mounted) {
      setState(() => _mixedPaidAfn = value);
    }
  }

  Future<void> _openDiscountEntry() async {
    final controller = TextEditingController(text: _nf(_afnToSelected(_discount), d: 2));
    final value = await showModalBottomSheet<double>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(_tr('Discount', 'تخفیف', 'تخفیف'), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: _tr('Discount amount', 'مبلغ تخفیف', 'د تخفیف اندازه')),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final parsed = double.tryParse(controller.text.trim()) ?? 0;
                    final inAfn = _selectedToAfn(parsed < 0 ? 0 : parsed);
                    Navigator.pop(context, inAfn);
                  },
                  child: Text(_tr('Confirm', 'تایید', 'تایید')),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (value != null) {
      setState(() => _discount = value);
    }
  }

  Future<void> _openCurrencySelector() async {
    final calendarSystem = ref.read(appCalendarSystemProvider);
    final calendarType = calendarSystem == CalendarSystem.persian ? CalendarType.persian : CalendarType.gregorian;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => CurrencySelector(
        selectedCurrency: _selectedCurrency,
        afnToRate: _afnToRate,
        lastUpdated: _ratesUpdatedAt,
        onSelected: (code) => setState(() => _selectedCurrency = code),
        tr: _tr,
        calendar: calendarType,
        locale: _lang,
      ),
    );
  }

  Future<void> _openPaymentMethodSelector() async {
    final value = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        Widget tile(String code, String label, IconData icon) {
          return ListTile(
            leading: Icon(icon),
            title: Text(label),
            trailing: _paymentMethod == code ? const Icon(Icons.check_rounded) : null,
            onTap: () => Navigator.pop(context, code),
          );
        }

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(title: Text(_tr('Payment Method', 'روش پرداخت', 'د تادیې طریقه'))),
              tile('cash', _tr('Cash', 'نقد', 'نغد'), Icons.payments_rounded),
              tile('credit', _tr('Qarz', 'قرض', 'پور'), Icons.person_outline_rounded),
              tile('mixed', _tr('Split', 'ترکیبی', 'ګډ'), Icons.swap_horiz_rounded),
            ],
          ),
        );
      },
    );

    if (value != null) {
      setState(() => _paymentMethod = value);
      if (value == 'credit' && _selectedCustomerId == null) {
        await _openCustomerPicker();
      }
    }
  }

  Widget _paymentChip(String method, IconData icon, {required double totalAfn}) {
    final cs = Theme.of(context).colorScheme;
    final selected = _paymentMethod == method;
    final fg = selected ? cs.primary : cs.onSurface.withOpacity(0.9);

    return ChoiceChip(
      selected: selected,
      showCheckmark: false,
      label: Text(
        _labelForMethod(method),
        style: TextStyle(
          color: fg,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      avatar: Icon(icon, size: 18, color: fg),
      selectedColor: cs.primary.withOpacity(0.18),
      backgroundColor: cs.surface,
      side: BorderSide(
        color: selected ? cs.primary.withOpacity(0.65) : cs.outline.withOpacity(0.28),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      onSelected: (isSelected) async {
        if (!isSelected) return;

        if (method == 'mixed') {
          final previous = _paymentMethod;
          setState(() => _paymentMethod = method);
          await _openMixedPaymentEntry(totalAfn);
          if (_mixedPaidAfn <= 0 && totalAfn > 0) {
            setState(() => _mixedPaidAfn = (totalAfn / 2));
          }
          if (previous == 'credit' && _selectedCustomerId == null) {
            await _openCustomerPicker();
          }
          return;
        }

        setState(() => _paymentMethod = method);
        if (method == 'credit' && _selectedCustomerId == null) {
          await _openCustomerPicker();
        }
      },
    );
  }

  Future<void> _openCustomerPicker() async {
    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);
    final customers = await db.customersDao.getCustomersByShopId(shopId);

    if (!mounted) return;

    final selected = await showModalBottomSheet<Object?>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        String query = '';
        return StatefulBuilder(
          builder: (context, setLocalState) {
            final filtered = customers.where((c) {
              if (query.trim().isEmpty) return true;
              final q = query.toLowerCase();
              return c.name.toLowerCase().contains(q) || (c.phone?.toLowerCase().contains(q) ?? false);
            }).toList();

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: MediaQuery.of(context).viewInsets.bottom + 12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_tr('Select customer', 'انتخاب مشتری', 'پېرودونکی وټاکئ'), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (v) => setLocalState(() => query = v),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded),
                      hintText: _tr('Search...', 'جستجو...', 'لټون...'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context, '__add_customer__');
                      },
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                      label: Text(_tr('New customer', 'مشتری جدید', 'نوی پېرودونکی')),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Flexible(
                    child: filtered.isEmpty
                      ? Padding(
                            padding: EdgeInsets.all(16),
                        child: Text(_tr('No customer found', 'مشتری یافت نشد', 'هیڅ پېرودونکی ونه موندل شو')),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final c = filtered[index];
                              return ListTile(
                                title: Text(c.name),
                                subtitle: Text(c.phone ?? '-'),
                                onTap: () => Navigator.pop(context, c),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selected == '__add_customer__') {
      final created = await Navigator.pushNamed(context, '/qarz/add-customer');
      if (!mounted) return;
      if (created is Map<String, dynamic>) {
        setState(() {
          _selectedCustomerId = created['id']?.toString();
          _selectedCustomerName = created['name']?.toString();
          if (_paymentMethod == 'cash') {
            _paymentMethod = 'credit';
          }
        });
      }
      return;
    }

    if (selected is Customer) {
      setState(() {
        _selectedCustomerId = selected.id;
        _selectedCustomerName = selected.name;
      });
    }
  }

  Future<void> _confirmSale(List<Map<String, dynamic>> items, double subtotal, double total) async {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_tr('Cart is empty', 'سبد خرید خالی است', 'ستاسو کڅوړه خالي ده'))));
      return;
    }

    if (_paymentMethod == 'credit' && _selectedCustomerId == null) {
      await _openCustomerPicker();
      if (_selectedCustomerId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_tr('Select a customer for credit sale', 'برای فروش قرض مشتری را انتخاب کنید', 'د قرض پلور لپاره پېرودونکی وټاکئ'))),
          );
        }
        return;
      }
    }

    final mixedRemaining = (total - _mixedPaidAfn).clamp(0.0, total);
    if (_paymentMethod == 'mixed' && mixedRemaining > 0 && _selectedCustomerId == null) {
      await _openCustomerPicker();
      if (_selectedCustomerId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_tr('Select a customer for remaining Qarz', 'برای باقی‌مانده قرض مشتری را انتخاب کنید', 'د پاتې قرض لپاره پېرودونکی وټاکئ'))),
          );
        }
        return;
      }
    }

    final canProceed = await GuestModeService.canAddSale();
    if (!canProceed) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_tr('Demo sale limit reached', 'محدودیت نسخه آزمایشی برای فروش تکمیل شده است', 'د ازمایښتي پلور محدودیت پوره شوی'))),
        );
      }
      return;
    }

    setState(() => _isSaving = true);

    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);
    final saleId = const Uuid().v4();
    final totalInSelected = _afnToSelected(total);
    final subtotalInSelected = _afnToSelected(subtotal);
    final discountInSelected = _afnToSelected(_discount);
    final exchangeRateToAfn = _selectedCurrency == 'AFN'
        ? 1.0
        : (totalInSelected > 0 ? (total / totalInSelected) : 1.0);
    final creditAmount = _paymentMethod == 'credit' ? total : (_paymentMethod == 'mixed' ? mixedRemaining.toDouble() : 0.0);
    final isCreditSale = creditAmount > 0;
    final syncEnabled = !(await GuestModeService.isGuestMode());
    final nowIso = DateTime.now().toIso8601String();

    try {
      await db.salesDao.insertSale(
        SalesCompanion(
          id: Value(saleId),
          shopId: Value(shopId),
          customerId: Value(_selectedCustomerId),
          totalAmount: Value(totalInSelected),
          totalAfn: Value(total),
          discount: Value(discountInSelected),
          paymentMethod: Value(_paymentMethod),
          currency: Value(_selectedCurrency),
          exchangeRate: Value(exchangeRateToAfn),
          isCredit: Value(isCreditSale),
        ),
      );

      if (syncEnabled) {
        await SyncService.instance.enqueueOperation(
          shopId: shopId,
          targetTable: 'sales',
          recordId: saleId,
          operation: 'INSERT',
          payload: {
            'id': saleId,
            'shop_id': shopId,
            'customer_id': _selectedCustomerId,
            'total_amount': totalInSelected,
            'total_afn': total,
            'discount': discountInSelected,
            'payment_method': _paymentMethod,
            'currency': _selectedCurrency,
            'exchange_rate': exchangeRateToAfn,
            'is_credit': isCreditSale,
            'created_at': nowIso,
            'updated_at': nowIso,
          },
        );
      }

      for (final item in items) {
        final saleItemId = const Uuid().v4();
        final productId = item['productId']?.toString();
        final quantity = (item['quantity'] as num?)?.toDouble() ?? 0;
        final price = (item['price'] as num?)?.toDouble() ?? 0;
        final name = item['name']?.toString() ?? '-';

        await db.salesDao.insertSaleItem(
          SaleItemsCompanion(
            id: Value(saleItemId),
            saleId: Value(saleId),
            productId: Value(productId),
            productNameSnapshot: Value(name),
            quantity: Value(quantity),
            unitPrice: Value(price),
            subtotal: Value(quantity * price),
          ),
        );

        if (syncEnabled) {
          await SyncService.instance.enqueueOperation(
            shopId: shopId,
            targetTable: 'sale_items',
            recordId: saleItemId,
            operation: 'INSERT',
            payload: {
              'id': saleItemId,
              'sale_id': saleId,
              'product_id': productId,
              'product_name_snapshot': name,
              'quantity': quantity,
              'unit_price': price,
              'subtotal': quantity * price,
              'created_at': nowIso,
            },
          );
        }

        if (productId != null && productId.isNotEmpty) {
          await db.productsDao.decrementStock(productId, quantity);

          if (syncEnabled) {
            final product = await db.productsDao.getProductById(productId);
            if (product != null) {
              await SyncService.instance.enqueueOperation(
                shopId: shopId,
                targetTable: 'products',
                recordId: product.id,
                operation: 'UPDATE',
                payload: {
                  'id': product.id,
                  'shop_id': product.shopId,
                  'name': product.nameDari,
                  'name_dari': product.nameDari,
                  'name_pashto': product.namePashto,
                  'name_en': product.nameEn,
                  'barcode': product.barcode,
                  'price': product.price,
                  'cost_price': product.costPrice,
                  'stock_quantity': product.stockQuantity,
                  'min_stock_alert': product.minStockAlert,
                  'unit': product.unit,
                  'updated_at': nowIso,
                },
              );
            }
          }
        }
      }

      if (isCreditSale && _selectedCustomerId != null) {
        final debtId = const Uuid().v4();
        await db.debtsDao.insertDebt(
          DebtsCompanion(
            id: Value(debtId),
            shopId: Value(shopId),
            customerId: Value(_selectedCustomerId!),
            saleId: Value(saleId),
            amountOriginal: Value(creditAmount),
            amountPaid: const Value(0),
            amountRemaining: Value(creditAmount),
            status: const Value('open'),
          ),
        );

        if (syncEnabled) {
          await SyncService.instance.enqueueOperation(
            shopId: shopId,
            targetTable: 'debts',
            recordId: debtId,
            operation: 'INSERT',
            payload: {
              'id': debtId,
              'shop_id': shopId,
              'customer_id': _selectedCustomerId,
              'sale_id': saleId,
              'amount_original': creditAmount,
              'amount_paid': 0,
              'amount_remaining': creditAmount,
              'status': 'open',
              'created_at': nowIso,
              'updated_at': nowIso,
            },
          );
        }

        final customer = await db.customersDao.getCustomerById(_selectedCustomerId!);
        if (customer != null) {
          final updatedTotalOwed = customer.totalOwed + creditAmount;
          await db.customersDao.updateTotalOwed(customer.id, updatedTotalOwed);
          await db.customersDao.updateLastInteraction(customer.id);

          if (syncEnabled) {
            await SyncService.instance.enqueueOperation(
              shopId: shopId,
              targetTable: 'customers',
              recordId: customer.id,
              operation: 'UPDATE',
              payload: {
                'id': customer.id,
                'shop_id': customer.shopId,
                'name': customer.name,
                'phone': customer.phone,
                'notes': customer.notes,
                'total_owed': updatedTotalOwed,
                'last_interaction_at': nowIso,
                'updated_at': nowIso,
              },
            );
          }
        }
      }

      await GuestModeService.incrementSalesCount();

      if (!mounted) return;
      Navigator.pushNamed(
        context,
        '/sales/confirmation',
        arguments: {
          'items': items,
          'total': totalInSelected,
          'subtotal': subtotalInSelected,
          'discount': discountInSelected,
          'totalAfn': total,
          'currency': _selectedCurrency,
          'paymentMethod': _paymentMethod,
          'customerName': _selectedCustomerName,
          'saleId': saleId,
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_tr('Failed to record sale: $e', 'خطا در ثبت فروش: $e', 'د پلور ثبت ناکام شو: $e'))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
