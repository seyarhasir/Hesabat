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
  String _viewMode = 'debts';

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
          PopupMenuButton<String>(
            tooltip: _tr('Add', 'افزودن', 'زیاتول'),
            icon: const Icon(Icons.add_rounded),
            onSelected: (value) {
              if (value == 'qarz') {
                _openAddQarzPage();
              } else if (value == 'customer') {
                Navigator.pushNamed(context, '/qarz/add-customer');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'qarz',
                child: Row(
                  children: [
                    const Icon(Icons.add_card_rounded),
                    const SizedBox(width: 10),
                    Text(_tr('Add Qarz', 'افزودن قرض', 'قرض زیات کړئ')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'customer',
                child: Row(
                  children: [
                    const Icon(Icons.person_add_alt_1_rounded),
                    const SizedBox(width: 10),
                    Text(_tr('Add Customer', 'افزودن مشتری', 'پېرودونکی زیات کړئ')),
                  ],
                ),
              ),
            ],
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
                    hintText: _viewMode == 'customers'
                        ? _tr('Search customer...', 'جستجوی مشتری...', 'پېرودونکی ولټوئ...')
                        : _tr('Search debt by customer...', 'جستجوی قرض با نام مشتری...', 'د پېرودونکي په نوم پور ولټوئ...'),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _searchQuery = ''))
                        : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: [
                          ButtonSegment<String>(
                            value: 'debts',
                            icon: const Icon(Icons.receipt_long_rounded),
                            label: Text(_tr('Debts', 'قرض‌ها', 'پورونه')),
                          ),
                          ButtonSegment<String>(
                            value: 'customers',
                            icon: const Icon(Icons.people_alt_rounded),
                            label: Text(_tr('Customers', 'مشتریان', 'پېرودونکي')),
                          ),
                        ],
                        selected: {_viewMode},
                        onSelectionChanged: (selection) {
                          setState(() {
                            _viewMode = selection.first;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Customer list
              Expanded(
                child: _viewMode == 'debts'
                    ? _buildDebtList(allDebts, cs, theme)
                    : _buildCustomerList(cs, theme),
              ),
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
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _openAddQarzPage,
                  icon: const Icon(Icons.add_card_rounded),
                  label: Text(_tr('Add Qarz', 'افزودن قرض', 'قرض زیات کړئ')),
                ),
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

  Widget _buildCustomerList(ColorScheme cs, ThemeData theme) {
    final db = ref.watch(databaseProvider);
    final shopId = ref.watch(currentShopIdProvider);

    return FutureBuilder<List<Customer>>(
      future: db.customersDao.getCustomersByShopId(shopId),
      builder: (context, snapshot) {
        final allCustomers = snapshot.data ?? [];
        var displayCustomers = allCustomers;

        if (_searchQuery.isNotEmpty) {
          final q = _searchQuery.toLowerCase();
          displayCustomers = displayCustomers.where((c) {
            return c.name.toLowerCase().contains(q) || (c.phone?.toLowerCase().contains(q) ?? false);
          }).toList();
        }

        displayCustomers.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

        if (displayCustomers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline_rounded, size: 64, color: cs.onSurface.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text(_tr('No customers found', 'مشتری یافت نشد', 'پېرودونکی ونه موندل شو'), style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  _tr('Add a customer to start tracking records', 'برای شروع، مشتری جدید اضافه کنید', 'د ریکارډ پيل لپاره پېرودونکی زیات کړئ'),
                  style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(0.6)),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: displayCustomers.length,
          itemBuilder: (context, index) {
            final customer = displayCustomers[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?'),
                ),
                title: Text(customer.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (customer.phone != null && customer.phone!.isNotEmpty) Text(customer.phone!),
                    Text(_na(_tr('Outstanding: ${_nf(customer.totalOwed)} AFN', 'باقی‌مانده: ${_nf(customer.totalOwed)} ؋', 'پاتې: ${_nf(customer.totalOwed)} ؋'))),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.pushNamed(
                  context,
                  '/qarz/detail',
                  arguments: {
                    'customerId': customer.id,
                    'customerName': customer.name,
                    'customerPhone': customer.phone,
                  },
                ),
              ),
            );
          },
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

  Future<void> _openAddQarzPage() async {
    final result = await Navigator.pushNamed(context, '/qarz/add-debt');
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_tr('Qarz added successfully', 'قرض با موفقیت اضافه شد', 'قرض په بریالیتوب اضافه شو')),
          backgroundColor: AppColors.success,
        ),
      );
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
