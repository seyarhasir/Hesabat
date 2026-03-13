import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/guest_mode_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/sync/sync_service.dart';

class AddQarzScreen extends ConsumerStatefulWidget {
  const AddQarzScreen({super.key});

  @override
  ConsumerState<AddQarzScreen> createState() => _AddQarzScreenState();
}

class _AddQarzScreenState extends ConsumerState<AddQarzScreen> {
  final _formKey = GlobalKey<FormState>();
  final _selectedCustomerController = TextEditingController();
  final _newNameController = TextEditingController();
  final _newPhoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  bool _saving = false;
  bool _loadingCustomers = true;
  bool _useExistingCustomer = true;
  List<Customer> _customers = const [];
  Customer? _selectedCustomer;

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void dispose() {
    _selectedCustomerController.dispose();
    _newNameController.dispose();
    _newPhoneController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);
    final customers = await db.customersDao.getCustomersByShopId(shopId);
    if (!mounted) return;
    setState(() {
      _customers = customers;
      _loadingCustomers = false;
      if (_customers.isEmpty) {
        _useExistingCustomer = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('Add Qarz', 'افزودن قرض', 'قرض زیات کړئ')),
      ),
      body: _loadingCustomers
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded, color: cs.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_tr(
                            'You can create qarz for an existing customer or a new customer.',
                            'می‌توانید قرض را برای مشتری موجود یا مشتری جدید ثبت کنید.',
                            'تاسو کولی شئ قرض د موجود پېرودونکي یا نوي پېرودونکي لپاره ثبت کړئ.',
                          )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (_customers.isNotEmpty)
                    SegmentedButton<bool>(
                      segments: [
                        ButtonSegment<bool>(
                          value: true,
                          icon: const Icon(Icons.people_alt_rounded),
                          label: Text(_tr('Existing', 'موجود', 'موجود')),
                        ),
                        ButtonSegment<bool>(
                          value: false,
                          icon: const Icon(Icons.person_add_alt_1_rounded),
                          label: Text(_tr('New', 'جدید', 'نوی')),
                        ),
                      ],
                      selected: {_useExistingCustomer},
                      onSelectionChanged: (selection) {
                        setState(() {
                          _useExistingCustomer = selection.first;
                        });
                      },
                    ),
                  const SizedBox(height: 12),
                  if (_useExistingCustomer) ...[
                    TextFormField(
                      controller: _selectedCustomerController,
                      readOnly: true,
                      onTap: _pickCustomer,
                      decoration: InputDecoration(
                        labelText: _tr('Customer *', 'مشتری *', 'پېرودونکی *'),
                        hintText: _tr('Select customer', 'انتخاب مشتری', 'پېرودونکی وټاکئ'),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search_rounded),
                          onPressed: _pickCustomer,
                        ),
                      ),
                      validator: (_) {
                        if (_useExistingCustomer && _selectedCustomer == null) {
                          return _tr('Please select a customer', 'لطفاً مشتری را انتخاب کنید', 'مهرباني وکړئ پېرودونکی وټاکئ');
                        }
                        return null;
                      },
                    ),
                  ] else ...[
                    TextFormField(
                      controller: _newNameController,
                      decoration: InputDecoration(
                        labelText: _tr('Customer name *', 'نام مشتری *', 'د پېرودونکي نوم *'),
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                      ),
                      validator: (v) {
                        if (!_useExistingCustomer && (v == null || v.trim().isEmpty)) {
                          return _tr('Customer name is required', 'نام مشتری الزامی است', 'د پېرودونکي نوم اړین دی');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _newPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: _tr('Phone (optional)', 'شماره موبایل (اختیاری)', 'شمېره (اختیاري)'),
                        prefixIcon: const Icon(Icons.phone_rounded),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: _tr('Amount (AFN) *', 'مبلغ (؋) *', 'اندازه (؋) *'),
                      prefixIcon: const Icon(Icons.attach_money_rounded),
                    ),
                    validator: (v) {
                      final amount = double.tryParse((v ?? '').trim());
                      if (amount == null || amount <= 0) {
                        return _tr('Enter a valid amount', 'مبلغ معتبر وارد کنید', 'معتبره اندازه ولیکئ');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: _tr('Notes (optional)', 'یادداشت (اختیاری)', 'یادښت (اختیاري)'),
                      prefixIcon: const Icon(Icons.note_alt_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _saving ? null : _saveQarz,
                      icon: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check_rounded),
                      label: Text(_tr('Save Qarz', 'ذخیره قرض', 'قرض خوندي کړئ')),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _pickCustomer() async {
    if (_customers.isEmpty) return;

    final result = await showModalBottomSheet<Customer>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        String query = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = _customers.where((c) {
              if (query.trim().isEmpty) return true;
              final q = query.toLowerCase();
              return c.name.toLowerCase().contains(q) || (c.phone?.toLowerCase().contains(q) ?? false);
            }).toList();

            filtered.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: TextField(
                      onChanged: (v) => setModalState(() => query = v),
                      decoration: InputDecoration(
                        hintText: _tr('Search customer...', 'جستجوی مشتری...', 'پېرودونکی ولټوئ...'),
                        prefixIcon: const Icon(Icons.search_rounded),
                      ),
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(child: Text(_tr('No customer found', 'مشتری یافت نشد', 'پېرودونکی ونه موندل شو')))
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final customer = filtered[index];
                              return ListTile(
                                leading: const Icon(Icons.person_outline_rounded),
                                title: Text(customer.name),
                                subtitle: customer.phone == null || customer.phone!.isEmpty ? null : Text(customer.phone!),
                                onTap: () => Navigator.pop(context, customer),
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

    if (result != null && mounted) {
      setState(() {
        _selectedCustomer = result;
        _selectedCustomerController.text = result.name;
      });
    }
  }

  Future<void> _saveQarz() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);
    final syncEnabled = !(await GuestModeService.isGuestMode());
    final nowIso = DateTime.now().toIso8601String();
    final amount = double.parse(_amountController.text.trim());
    final notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();

    try {
      String customerId;
      String customerName;

      if (_useExistingCustomer) {
        final c = _selectedCustomer;
        if (c == null) {
          setState(() => _saving = false);
          return;
        }
        customerId = c.id;
        customerName = c.name;

        final newTotalOwed = c.totalOwed + amount;
        await db.customersDao.updateTotalOwed(customerId, newTotalOwed);

        if (syncEnabled) {
          await SyncService.instance.enqueueOperation(
            shopId: shopId,
            targetTable: 'customers',
            recordId: customerId,
            operation: 'UPDATE',
            payload: {
              'id': c.id,
              'shop_id': c.shopId,
              'name': c.name,
              'phone': c.phone,
              'notes': c.notes,
              'total_owed': newTotalOwed,
              'updated_at': nowIso,
            },
          );
        }
      } else {
        customerName = _newNameController.text.trim();
        final phone = _newPhoneController.text.trim().isEmpty ? null : _newPhoneController.text.trim();

        customerId = 'local_cust_${DateTime.now().millisecondsSinceEpoch}';
        await db.customersDao.insertCustomer(
          CustomersCompanion(
            id: Value(customerId),
            shopId: Value(shopId),
            name: Value(customerName),
            phone: Value(phone),
            totalOwed: Value(amount),
          ),
        );

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

      final debtId = 'local_debt_${DateTime.now().millisecondsSinceEpoch}';
      await db.debtsDao.insertDebt(
        DebtsCompanion(
          id: Value(debtId),
          shopId: Value(shopId),
          customerId: Value(customerId),
          amountOriginal: Value(amount),
          amountRemaining: Value(amount),
          notes: Value(notes),
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

      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_tr('Qarz added for $customerName', 'قرض برای $customerName ثبت شد', 'د $customerName لپاره قرض ثبت شو')),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_tr('Error: $e', 'خطا: $e', 'تېروتنه: $e'))),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
