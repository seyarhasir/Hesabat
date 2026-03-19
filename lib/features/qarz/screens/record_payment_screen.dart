import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../../core/auth/guest_mode_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/sync/sync_service.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../shared/widgets/currency_display.dart';
import '../../../core/settings/currency_preference_provider.dart';

class RecordPaymentScreen extends ConsumerStatefulWidget {
  const RecordPaymentScreen({super.key});

  @override
  ConsumerState<RecordPaymentScreen> createState() => _RecordPaymentScreenState();
}

class _RecordPaymentScreenState extends ConsumerState<RecordPaymentScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _saving = false;

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);
  String _na(String s) => NumberSystemFormatter.apply(s);
  String _rawInt(num v) => v.toStringAsFixed(0);

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final debtId = args?['debtId']?.toString() ?? '';
    final customerId = args?['customerId']?.toString() ?? '';
    final customerName = args?['customerName']?.toString() ?? _tr('Customer', 'مشتری', 'پېرودونکی');
    final amountRemaining = (args?['amountRemaining'] as num?)?.toDouble() ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(_tr('Record Payment', 'ثبت پرداخت', 'د تادیې ثبت'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customerName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(_tr('Total debt', 'کل بدهی', 'ټول پور'), style: Theme.of(context).textTheme.bodyMedium),
                      Text(': ', style: Theme.of(context).textTheme.bodyMedium),
                      CurrencyDisplay(
                        amount: amountRemaining,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: _tr('Received amount', 'مبلغ دریافتی', 'ترلاسه شوې اندازه')),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => _amountController.text = _rawInt(20000),
                    child: CurrencyDisplay(amount: 20000),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => _amountController.text = _rawInt(50000),
                    child: CurrencyDisplay(amount: 50000),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _amountController.text = _rawInt(amountRemaining),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_tr('Full Amount: ', 'کل مبلغ: ', 'بشپړه اندازه: ')),
                        CurrencyDisplay(amount: amountRemaining),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: _tr('Note (optional)', 'یادداشت (اختیاری)', 'یادښت (اختیاري)')),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving
                    ? null
                    : () => _savePayment(
                          debtId: debtId,
                          customerId: customerId,
                          amountRemaining: amountRemaining,
                        ),
                icon: _saving
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.check_rounded),
                label: Text(_saving ? _tr('Saving...', 'در حال ثبت...', 'ثبت روان دی...') : _tr('Confirm Payment', 'تایید پرداخت', 'تادیه تایید کړئ')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePayment({
    required String debtId,
    required String customerId,
    required double amountRemaining,
  }) async {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (debtId.isEmpty || customerId.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_tr('Invalid payment data', 'اطلاعات پرداخت نامعتبر است', 'د تادیې معلومات ناسم دي'))));
      return;
    }

    final validAmount = amount > amountRemaining ? amountRemaining : amount;
    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);
    final newRemaining = (amountRemaining - validAmount).clamp(0.0, amountRemaining);
    final newStatus = newRemaining <= 0 ? 'paid' : 'partial';
    final paymentId = const Uuid().v4();
    final syncEnabled = !(await GuestModeService.isGuestMode());
    final nowIso = DateTime.now().toIso8601String();

    setState(() => _saving = true);
    try {
      await db.debtsDao.recordPayment(
        debtId,
        DebtPaymentsCompanion(
          id: Value(paymentId),
          debtId: Value(debtId),
          shopId: Value(shopId),
          amount: Value(validAmount),
          notes: Value(_noteController.text.trim().isEmpty ? null : _noteController.text.trim()),
        ),
        newRemaining,
        newStatus,
      );

      final customerDebts = await db.debtsDao.getDebtsByCustomer(customerId);
      final totalOwed = customerDebts.where((d) => d.status != 'paid').fold<double>(0, (sum, d) => sum + d.amountRemaining);
      await db.customersDao.updateTotalOwed(customerId, totalOwed);
      await db.customersDao.updateLastInteraction(customerId);

      if (syncEnabled) {
        await SyncService.instance.enqueueOperation(
          shopId: shopId,
          targetTable: 'debt_payments',
          recordId: paymentId,
          operation: 'INSERT',
          payload: {
            'id': paymentId,
            'debt_id': debtId,
            'shop_id': shopId,
            'amount': validAmount,
            'payment_method': 'cash',
            'currency': 'AFN',
            'notes': _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
            'created_at': nowIso,
          },
        );

        final debt = await db.debtsDao.getDebtById(debtId);
        await SyncService.instance.enqueueOperation(
          shopId: shopId,
          targetTable: 'debts',
          recordId: debtId,
          operation: 'UPDATE',
          payload: {
            'id': debtId,
            'amount_paid': debt?.amountPaid ?? (amountRemaining - newRemaining),
            'amount_remaining': newRemaining,
            'status': newStatus,
            'updated_at': nowIso,
          },
        );

        final customer = await db.customersDao.getCustomerById(customerId);
        if (customer != null) {
          await SyncService.instance.enqueueOperation(
            shopId: shopId,
            targetTable: 'customers',
            recordId: customerId,
            operation: 'UPDATE',
            payload: {
              'id': customer.id,
              'shop_id': customer.shopId,
              'name': customer.name,
              'phone': customer.phone,
              'notes': customer.notes,
              'total_owed': totalOwed,
              'last_interaction_at': nowIso,
              'updated_at': nowIso,
            },
          );
        }
      }

      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_na(_tr('Payment ${_nf(validAmount)} AFN recorded', 'پرداخت ${_nf(validAmount)} ؋ ثبت شد', 'د ${_nf(validAmount)} ؋ تادیه ثبت شوه')))),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_tr('Failed to record payment: $e', 'خطا در ثبت پرداخت: $e', 'د تادیې ثبت ناکام شو: $e'))),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
