import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../../core/auth/guest_mode_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/sync/sync_service.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();
  bool _saving = false;

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(_tr('New Customer', 'مشتری جدید', 'نوی پېرودونکی'))),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_add_alt_1_rounded, color: cs.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_tr('Add customer details for future qarz records', 'جزئیات مشتری را برای ثبت قرض اضافه کنید', 'د راتلونکو قرض ریکارډونو لپاره د پېرودونکي معلومات زیات کړئ')),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: _tr('Customer Name *', 'نام مشتری *', 'د پېرودونکي نوم *')),
                validator: (v) => (v == null || v.trim().isEmpty) ? _tr('Customer name is required', 'نام مشتری الزامی است', 'د پېرودونکي نوم اړین دی') : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: _tr('Phone Number', 'شماره موبایل', 'د موبایل شمېره'), hintText: '+93'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: _tr('Note (optional)', 'یادداشت (اختیاری)', 'یادښت (اختیاري)')),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(_tr('Save Customer', 'ذخیره مشتری', 'پېرودونکی خوندي کړئ')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();

    setState(() => _saving = true);

    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);
    final customerId = const Uuid().v4();
    final syncEnabled = !(await GuestModeService.isGuestMode());
    final nowIso = DateTime.now().toIso8601String();
    final phone = _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim();
    final note = _noteController.text.trim().isEmpty ? null : _noteController.text.trim();

    await db.customersDao.insertCustomer(
      CustomersCompanion(
        id: Value(customerId),
        shopId: Value(shopId),
        name: Value(name),
        phone: Value(phone),
        notes: Value(note),
        totalOwed: const Value(0),
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
          'name': name,
          'phone': phone,
          'notes': note,
          'total_owed': 0,
          'created_at': nowIso,
          'updated_at': nowIso,
        },
      );
    }

    if (!mounted) return;
    Navigator.pop(context, {'id': customerId, 'name': name});
  }
}
