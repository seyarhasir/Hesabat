import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:url_launcher/url_launcher.dart';
import '../../../core/auth/guest_mode_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/sync/sync_service.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/debt_badge.dart';

/// Qarz (Debt) Dashboard Screen - Core feature of Hesabat
class QarzDashboardScreen extends ConsumerStatefulWidget {
  const QarzDashboardScreen({super.key});

  @override
  ConsumerState<QarzDashboardScreen> createState() => _QarzDashboardScreenState();
}

class _QarzDashboardScreenState extends ConsumerState<QarzDashboardScreen> {
  String _searchQuery = '';
  String _sortBy = 'amount';

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);
  String _na(String s) => NumberSystemFormatter.apply(s);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final db = ref.watch(databaseProvider);
    final shopId = ref.watch(currentShopIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('Qarz', 'قرض‌ها', 'قرضونه')),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            onPressed: () => Navigator.pushNamed(context, '/qarz/add-customer'),
          ),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: _showSortOptions),
        ],
      ),
      body: StreamBuilder<List<Debt>>(
        stream: db.debtsDao.watchDebtsByShopId(shopId),
        builder: (context, snapshot) {
          final allDebts = (snapshot.data ?? []).where((d) => d.status != 'paid').toList();

          final totalOwed = allDebts.fold<double>(0, (sum, d) => sum + d.amountRemaining);
          final overdueCount = allDebts.where((d) {
            final days = DateTime.now().difference(d.createdAt).inDays;
            return days > 7;
          }).length;

          return Column(
            children: [
              // Hero number
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Text(_tr('Total owed to you', 'کل بدهی به شما', 'ټول پور چې درته پاتې دی'), style: theme.textTheme.titleMedium?.copyWith(color: Colors.white.withOpacity(0.8))),
                    const SizedBox(height: 8),
                    Text('${_nf(totalOwed)} ؋', style: theme.textTheme.displayLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatChip(_na(_tr('${allDebts.length} customers with debt', '${allDebts.length} مشتری بدهکار', '${allDebts.length} پېرودونکي پوروړي دي')), Colors.white.withOpacity(0.2), Colors.white),
                        const SizedBox(width: 8),
                        _buildStatChip(_na(_tr('$overdueCount overdue', '$overdueCount سررسید گذشته', '$overdueCount ځنډېدلي')), AppColors.danger.withOpacity(0.3), Colors.white),
                      ],
                    ),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: _tr('Search customer...', 'جستجوی مشتری...', 'پېرودونکی ولټوئ...'),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _searchQuery = ''))
                        : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              // Customer list
              Expanded(child: _buildDebtList(allDebts, cs, theme)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildDebtList(List<Debt> allDebts, ColorScheme cs, ThemeData theme) {
    final db = ref.watch(databaseProvider);
    final shopId = ref.watch(currentShopIdProvider);

    return FutureBuilder<List<Customer>>(
      future: db.customersDao.getCustomersByShopId(shopId),
      builder: (context, custSnapshot) {
        final customers = custSnapshot.data ?? [];
        final customerMap = {for (final c in customers) c.id: c};

        var displayDebts = allDebts.map((debt) {
          final customer = customerMap[debt.customerId];
          return _DebtDisplay(
            debt: debt,
            customerName: customer?.name ?? _tr('Unknown', 'نامشخص', 'نامعلوم'),
            customerPhone: customer?.phone,
            daysSince: DateTime.now().difference(debt.createdAt).inDays,
          );
        }).toList();

        // Search filter
        if (_searchQuery.isNotEmpty) {
          final q = _searchQuery.toLowerCase();
          displayDebts = displayDebts.where((d) {
            return d.customerName.toLowerCase().contains(q) || (d.customerPhone?.toLowerCase().contains(q) ?? false);
          }).toList();
        }

        // Sort
        switch (_sortBy) {
          case 'amount':
            displayDebts.sort((a, b) => b.debt.amountRemaining.compareTo(a.debt.amountRemaining));
            break;
          case 'date':
            displayDebts.sort((a, b) => b.daysSince.compareTo(a.daysSince));
            break;
          case 'name':
            displayDebts.sort((a, b) => a.customerName.compareTo(b.customerName));
            break;
        }

        if (displayDebts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance_wallet_outlined, size: 64, color: cs.onSurface.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text(_tr('No debts found', 'قرضی یافت نشد', 'هیڅ پور ونه موندل شو'), style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(_tr('Add a new qarz to get started', 'برای شروع قرض جدید اضافه کنید', 'د پیل لپاره نوی قرض زیات کړئ'), style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(0.6))),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: displayDebts.length,
          itemBuilder: (context, index) => _buildDebtCard(displayDebts[index], cs, theme),
        );
      },
    );
  }

  Widget _buildDebtCard(_DebtDisplay display, ColorScheme cs, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(
          context,
          '/qarz/detail',
          arguments: {
            'debtId': display.debt.id,
            'customerId': display.debt.customerId,
            'customerName': display.customerName,
            'customerPhone': display.customerPhone,
          },
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(display.customerName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      if (display.customerPhone != null)
                        Text(display.customerPhone!, style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.6))),
                    ],
                  ),
                ),
                DebtBadge(amount: display.debt.amountRemaining, daysSince: display.daysSince),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(_tr('Amount Owed', 'مبلغ بدهی', 'پور پاتې اندازه'), style: theme.textTheme.bodySmall),
                      Text('${_nf(display.debt.amountRemaining)} ${_tr('AFN', '؋', '؋')}',
                        style: theme.textTheme.titleLarge?.copyWith(color: AppColors.danger, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    if (display.customerPhone != null)
                      OutlinedButton.icon(
                            onPressed: () => _sendReminder(display),
                        icon: const Icon(Icons.message, size: 18),
                            label: Text(_tr('Reminder', 'یادآوری', 'یادونه')),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12)),
                      ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/qarz/record-payment',
                            arguments: {
                              'debtId': display.debt.id,
                              'customerId': display.debt.customerId,
                              'customerName': display.customerName,
                              'amountRemaining': display.debt.amountRemaining,
                            },
                          ),
                      icon: const Icon(Icons.payments, size: 18),
                          label: Text(_tr('Pay', 'پرداخت', 'تادیه')),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12), backgroundColor: AppColors.success),
                    ),
                  ],
                ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_tr('Sort by', 'مرتب‌سازی', 'ترتیب د'), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: Text(_tr('Highest amount', 'بیشترین مبلغ', 'تر ټولو لوړ مبلغ')),
                trailing: _sortBy == 'amount' ? const Icon(Icons.check) : null,
                onTap: () { setState(() => _sortBy = 'amount'); Navigator.pop(context); },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(_tr('Days overdue', 'روزهای تاخیر', 'د ځنډ ورځې')),
                trailing: _sortBy == 'date' ? const Icon(Icons.check) : null,
                onTap: () { setState(() => _sortBy = 'date'); Navigator.pop(context); },
              ),
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: Text(_tr('Customer name', 'نام مشتری', 'د پېرودونکي نوم')),
                trailing: _sortBy == 'name' ? const Icon(Icons.check) : null,
                onTap: () { setState(() => _sortBy = 'name'); Navigator.pop(context); },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendReminder(_DebtDisplay display) {
    final message = _lang == 'ps'
      ? 'ګرانه ${display.customerName}،\n\nستاسو پور ${_nf(display.debt.amountRemaining)} افغانۍ دی.\nمهرباني وکړئ ژر تر ژره یې تادیه کړئ.\n\nمننه،\nحسابات'
      : (_lang == 'fa'
        ? 'محترم ${display.customerName}،\n\nقرضه شما به مبلغ ${_nf(display.debt.amountRemaining)} افغانی است.\nلطفاً در اسرع وقت پرداخت کنید.\n\nتشکر،\nحسابات'
        : 'Dear ${display.customerName},\n\nYou currently owe ${_nf(display.debt.amountRemaining)} AFN.\nPlease pay as soon as possible.\n\nThank you,\nHesabat');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr('Send WhatsApp Reminder', 'ارسال یادآوری واتساپ', 'د واتساپ یادونه ولېږئ')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_tr('Message to ${display.customerName}:', 'پیام برای ${display.customerName}:', '${display.customerName} ته پیغام:')),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
              child: Text(message),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(_tr('Cancel', 'لغو', 'لغوه'))),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _openWhatsApp(display.customerPhone!, message);
            },
            icon: const Icon(Icons.send),
            label: Text(_tr('Send via WhatsApp', 'ارسال با واتساپ', 'د واتساپ له لارې ولېږئ')),
          ),
        ],
      ),
    );
  }

  void _openWhatsApp(String phone, String message) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final encoded = Uri.encodeComponent(message);
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=$encoded');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('Could not open WhatsApp', 'باز کردن واتساپ ممکن نشد', 'واتساپ نه پرانیستل کېږي')), backgroundColor: AppColors.danger),
      );
    }
  }

  void _recordPayment(_DebtDisplay display) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(_tr('Record Payment - ${display.customerName}', 'ثبت پرداخت - ${display.customerName}', 'تادیه ثبت - ${display.customerName}')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_na(_tr('Amount owed: ${_nf(display.debt.amountRemaining)} AFN', 'مبلغ بدهی: ${_nf(display.debt.amountRemaining)} ؋', 'پور پاتې: ${_nf(display.debt.amountRemaining)} ؋')), style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _tr('Payment Amount (AFN)', 'مبلغ پرداخت (؋)', 'د تادیې اندازه (؋)'),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.attach_money),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(_tr('Cancel', 'لغو', 'لغوه'))),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0;
              if (amount > 0) {
                Navigator.pop(dialogContext);
                _processPayment(display, amount);
              }
            },
            child: Text(_tr('Record Payment', 'ثبت پرداخت', 'تادیه ثبت کړئ')),
          ),
        ],
      ),
    );
  }

  void _processPayment(_DebtDisplay display, double amount) async {
    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);
    final debt = display.debt;

    final newRemaining = (debt.amountRemaining - amount).clamp(0.0, debt.amountOriginal);
    final newStatus = newRemaining <= 0 ? 'paid' : 'partial';
    final paymentId = 'local_pay_${DateTime.now().millisecondsSinceEpoch}';
    final syncEnabled = !(await GuestModeService.isGuestMode());
    final nowIso = DateTime.now().toIso8601String();

    try {
      await db.debtsDao.recordPayment(
        debt.id,
        DebtPaymentsCompanion(
          id: Value(paymentId),
          debtId: Value(debt.id),
          shopId: Value(shopId),
          amount: Value(amount),
        ),
        newRemaining,
        newStatus,
      );

      if (syncEnabled) {
        await SyncService.instance.enqueueOperation(
          shopId: shopId,
          targetTable: 'debt_payments',
          recordId: paymentId,
          operation: 'INSERT',
          payload: {
            'id': paymentId,
            'debt_id': debt.id,
            'shop_id': shopId,
            'amount': amount,
            'payment_method': 'cash',
            'currency': 'AFN',
            'created_at': nowIso,
          },
        );
      }

      // Update customer's total owed
      if (display.debt.customerId.isNotEmpty) {
        final customerDebts = await db.debtsDao.getDebtsByCustomer(display.debt.customerId);
        final newTotal = customerDebts.where((d) => d.id != debt.id).fold<double>(0, (sum, d) => sum + d.amountRemaining) + newRemaining;
        await db.customersDao.updateTotalOwed(display.debt.customerId, newTotal);

        if (syncEnabled) {
          await SyncService.instance.enqueueOperation(
            shopId: shopId,
            targetTable: 'debts',
            recordId: debt.id,
            operation: 'UPDATE',
            payload: {
              'id': debt.id,
              'amount_paid': debt.amountPaid + amount,
              'amount_remaining': newRemaining,
              'status': newStatus,
              'updated_at': nowIso,
            },
          );

          final customer = await db.customersDao.getCustomerById(display.debt.customerId);
          if (customer != null) {
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
                'total_owed': newTotal,
                'last_interaction_at': nowIso,
                'updated_at': nowIso,
              },
            );
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_na(_tr('Payment of ${_nf(amount)} AFN recorded!', 'پرداخت ${_nf(amount)} ؋ ثبت شد!', 'د ${_nf(amount)} ؋ تادیه ثبت شوه!'))), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_tr('Error: $e', 'خطا: $e', 'تېروتنه: $e')), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  void _addNewDebt(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final amountController = TextEditingController();
    final notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_tr('Add New Qarz', 'افزودن قرض جدید', 'نوی قرض زیات کړئ'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: _tr('Customer Name *', 'نام مشتری *', 'د پېرودونکي نوم *'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: _tr('Phone (optional)', 'شماره موبایل (اختیاری)', 'شمېره (اختیاري)'),
                  hintText: '+93 70 ...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _tr('Amount (AFN) *', 'مبلغ (؋) *', 'اندازه (؋) *'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: _tr('Notes (optional)', 'یادداشت (اختیاری)', 'یادښت (اختیاري)'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final amount = double.tryParse(amountController.text) ?? 0;
                    if (name.isEmpty || amount <= 0) return;

                    Navigator.pop(context);
                    await _createDebt(
                      customerName: name,
                      phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                      amount: amount,
                      notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(_tr('Add Qarz', 'افزودن قرض', 'قرض زیات کړئ'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _createDebt({
    required String customerName,
    String? phone,
    required double amount,
    String? notes,
  }) async {
    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);
    final syncEnabled = !(await GuestModeService.isGuestMode());
    final nowIso = DateTime.now().toIso8601String();

    try {
      // Create or find customer
      final existingCustomers = await db.customersDao.searchCustomers(customerName, shopId);
      String customerId;

      if (existingCustomers.isNotEmpty) {
        customerId = existingCustomers.first.id;
        final newTotalOwed = existingCustomers.first.totalOwed + amount;
        await db.customersDao.updateTotalOwed(customerId, newTotalOwed);

        if (syncEnabled) {
          final customer = existingCustomers.first;
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
              'total_owed': newTotalOwed,
              'updated_at': nowIso,
            },
          );
        }
      } else {
        customerId = 'local_cust_${DateTime.now().millisecondsSinceEpoch}';
        await db.customersDao.insertCustomer(CustomersCompanion(
          id: Value(customerId),
          shopId: Value(shopId),
          name: Value(customerName),
          phone: Value(phone),
          totalOwed: Value(amount),
        ));

        if (syncEnabled) {
          await SyncService.instance.enqueueOperation(
            shopId: shopId,
            targetTable: 'customers',
            recordId: customerId,
            operation: 'INSERT',
            payload: {
              'id': customerId,
              'shop_id': shopId,
              'name': customerName,
              'phone': phone,
              'total_owed': amount,
              'created_at': nowIso,
              'updated_at': nowIso,
            },
          );
        }
      }

      // Create debt
      final debtId = 'local_debt_${DateTime.now().millisecondsSinceEpoch}';
      await db.debtsDao.insertDebt(DebtsCompanion(
        id: Value(debtId),
        shopId: Value(shopId),
        customerId: Value(customerId),
        amountOriginal: Value(amount),
        amountRemaining: Value(amount),
        notes: Value(notes),
      ));

      if (syncEnabled) {
        await SyncService.instance.enqueueOperation(
          shopId: shopId,
          targetTable: 'debts',
          recordId: debtId,
          operation: 'INSERT',
          payload: {
            'id': debtId,
            'shop_id': shopId,
            'customer_id': customerId,
            'amount_original': amount,
            'amount_paid': 0,
            'amount_remaining': amount,
            'status': 'open',
            'notes': notes,
            'created_at': nowIso,
            'updated_at': nowIso,
          },
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_na(_tr('Qarz of ${_nf(amount)} AFN added for $customerName', 'قرض ${_nf(amount)} ؋ برای $customerName ثبت شد', 'د $customerName لپاره ${_nf(amount)} ؋ قرض ثبت شو'))), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_tr('Error: $e', 'خطا: $e', 'تېروتنه: $e')), backgroundColor: AppColors.danger),
        );
      }
    }
  }
}

class _DebtDisplay {
  final Debt debt;
  final String customerName;
  final String? customerPhone;
  final int daysSince;

  _DebtDisplay({
    required this.debt,
    required this.customerName,
    this.customerPhone,
    required this.daysSince,
  });
}
