import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../core/settings/shop_profile_service.dart';

class CustomerDebtDetailScreen extends ConsumerStatefulWidget {
  const CustomerDebtDetailScreen({super.key});

  @override
  ConsumerState<CustomerDebtDetailScreen> createState() => _CustomerDebtDetailScreenState();
}

class _CustomerDebtDetailScreenState extends ConsumerState<CustomerDebtDetailScreen> {
  bool _loading = true;
  List<Debt> _debts = const [];
  final Map<String, List<DebtPayment>> _paymentsByDebt = {};
  double _totalOwed = 0;
  DateTime? _lastPaymentAt;

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);
  String _na(String s) => NumberSystemFormatter.apply(s);

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final customerId = args?['customerId']?.toString();
    if (customerId == null || customerId.isEmpty) {
      if (!mounted) return;
      setState(() => _loading = false);
      return;
    }

    final db = ref.read(databaseProvider);
    final debts = await db.debtsDao.getDebtsByCustomer(customerId);

    final Map<String, List<DebtPayment>> paymentsByDebt = {};
    DateTime? lastPaymentAt;
    for (final debt in debts) {
      final payments = await db.debtsDao.getDebtPayments(debt.id);
      paymentsByDebt[debt.id] = payments;
      for (final p in payments) {
        if (lastPaymentAt == null || p.createdAt.isAfter(lastPaymentAt)) {
          lastPaymentAt = p.createdAt;
        }
      }
    }

    final total = debts.where((d) => d.status != 'paid').fold<double>(0, (sum, d) => sum + d.amountRemaining);

    if (!mounted) return;
    setState(() {
      _debts = debts;
      _paymentsByDebt
        ..clear()
        ..addAll(paymentsByDebt);
      _totalOwed = total;
      _lastPaymentAt = lastPaymentAt;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final customerName = args?['customerName']?.toString() ?? _tr('Customer', 'مشتری', 'پېرودونکی');
    final customerPhone = args?['customerPhone']?.toString();
    final customerId = args?['customerId']?.toString();

    return Scaffold(
      appBar: AppBar(title: Text(customerName)),
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
                          if (customerPhone != null && customerPhone.isNotEmpty)
                            InkWell(
                              onTap: () async {
                                final uri = Uri.parse('tel:$customerPhone');
                                await launchUrl(uri);
                              },
                              child: Text('📞 $customerPhone'),
                            ),
                          const SizedBox(height: 6),
                            Text(_na('${_tr('Total debt', 'کل بدهی', 'ټول پور')}: ${_nf(_totalOwed)} ${_tr('AFN', '؋', '؋')}'), style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(
                            _lastPaymentAt == null
                              ? _tr('Last payment: unknown', 'آخرین پرداخت: نامشخص', 'وروستۍ تادیه: نامعلومه')
                              : _na(_tr('Last payment: ${_nf(DateTime.now().difference(_lastPaymentAt!).inDays)} days ago', 'آخرین پرداخت: ${_nf(DateTime.now().difference(_lastPaymentAt!).inDays)} روز پیش', 'وروستۍ تادیه: ${_nf(DateTime.now().difference(_lastPaymentAt!).inDays)} ورځې مخکې')),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: customerPhone == null
                        ? null
                        : () => _sendReminder(customerName, customerPhone, _totalOwed),
                    icon: const Icon(Icons.message_rounded),
                    label: Text(_tr('Send WhatsApp reminder', 'ارسال یادآوری واتساپ', 'د واتساپ یادونه ولېږئ')),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () async {
                      final openDebts = _debts.where((d) => d.status != 'paid').toList();
                      if (openDebts.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_tr('No open debt available for payment', 'بدهی بازی برای پرداخت وجود ندارد', 'د تادیې لپاره خلاص پور نشته'))));
                        return;
                      }
                      final debtForPayment = await _pickDebtForPayment(openDebts);
                      if (debtForPayment == null || !mounted) return;
                      final result = await Navigator.pushNamed(
                        context,
                        '/qarz/record-payment',
                        arguments: {
                          'debtId': debtForPayment.id,
                          'customerId': customerId,
                          'customerName': customerName,
                          'amountRemaining': debtForPayment.amountRemaining,
                        },
                      );
                      if (result == true && mounted) {
                        await _load();
                      }
                    },
                    icon: const Icon(Icons.payments_rounded),
                    label: Text(_tr('Record payment', 'ثبت پرداخت', 'تادیه ثبت کړئ')),
                  ),
                  const SizedBox(height: 16),
                  Text(_tr('Debt history', 'تاریخچه بدهی', 'د پور تاریخچه'), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (_debts.isEmpty)
                    Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(_tr('No records', 'رکوردی وجود ندارد', 'هیڅ ریکارډ نشته'))))
                  else
                    ..._debts.map((debt) {
                      final payments = _paymentsByDebt[debt.id] ?? const <DebtPayment>[];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_na(_tr('Debt: ${_nf(debt.amountOriginal)} AFN | Remaining: ${_nf(debt.amountRemaining)} AFN', 'قرض: ${_nf(debt.amountOriginal)} ؋ | باقیمانده: ${_nf(debt.amountRemaining)} ؋', 'پور: ${_nf(debt.amountOriginal)} ؋ | پاتې: ${_nf(debt.amountRemaining)} ؋'))),
                              const SizedBox(height: 4),
                              Text('${_tr('Status', 'وضعیت', 'حالت')}: ${debt.status == 'paid' ? _tr('Paid', 'پرداخت شد', 'تصفیه شو') : _tr('Open', 'باز', 'خلاص')}'),
                              if (payments.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                ...payments.map((p) => Text(_na(_tr('💚 Payment ${_nf(p.amount)} AFN', '💚 پرداخت ${_nf(p.amount)} ؋', '💚 تادیه ${_nf(p.amount)} ؋')))),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }

  Future<void> _sendReminder(String customerName, String phone, double amount) async {
    final profile = await ShopProfileService.loadWithCloudFallback();
    final shopName = profile?.shopName ?? 'Hesabat';
    final message = _lang == 'ps'
      ? 'ګرانه $customerName،%0A%0Aستاسو پور په $shopName کې ${_nf(amount)} افغانۍ دی.'
      : (_lang == 'fa'
        ? 'محترم $customerName،%0A%0Aقرضه شما در $shopName به مبلغ ${_nf(amount)} افغانی است.'
        : 'Dear $customerName,%0A%0AYou currently owe ${_nf(amount)} AFN to $shopName.');
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=$message');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<Debt?> _pickDebtForPayment(List<Debt> openDebts) async {
    if (openDebts.length == 1) return openDebts.first;

    return showModalBottomSheet<Debt>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(title: Text(_tr('Choose debt to pay', 'بدهی مورد نظر را انتخاب کنید', 'د تادیې لپاره پور وټاکئ'))),
              ...openDebts.map(
                (d) => ListTile(
                  leading: const Icon(Icons.receipt_long_rounded),
                  title: Text(_na(_tr('Remaining: ${_nf(d.amountRemaining)} AFN', 'باقیمانده: ${_nf(d.amountRemaining)} ؋', 'پاتې: ${_nf(d.amountRemaining)} ؋'))),
                  subtitle: Text(_na(_tr('Original: ${_nf(d.amountOriginal)} AFN', 'اصل بدهی: ${_nf(d.amountOriginal)} ؋', 'اصلي پور: ${_nf(d.amountOriginal)} ؋'))),
                  onTap: () => Navigator.pop(context, d),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
