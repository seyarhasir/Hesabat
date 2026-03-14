import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../shared/theme/app_colors.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  String _query = '';

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);
  String _na(String s) => NumberSystemFormatter.apply(s);

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final shopId = ref.watch(currentShopIdProvider);
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('Customers', 'مشتریان', 'پېرودونکي')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/qarz/add-customer'),
        tooltip: _tr('Add customer', 'افزودن مشتری', 'پېرودونکی زیات کړئ'),
        child: const Icon(Icons.person_add_alt_1_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: FutureBuilder<List<Customer>>(
        future: db.customersDao.getCustomersByShopId(shopId),
        builder: (context, snapshot) {
          final customers = [...(snapshot.data ?? const <Customer>[])];
          if (_query.trim().isNotEmpty) {
            final q = _query.toLowerCase();
            customers.retainWhere((c) => c.name.toLowerCase().contains(q) || (c.phone?.toLowerCase().contains(q) ?? false));
          }
          customers.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

          final withDebt = customers.where((c) => c.totalOwed > 0).length;
          final clear = customers.length - withDebt;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: _tr('Search customer...', 'جستجوی مشتری...', 'پېرودونکی ولټوئ...'),
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () => setState(() => _query = ''),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _pill(_tr('👥 ${_nf(customers.length)} customers', '👥 ${_nf(customers.length)} مشتری', '👥 ${_nf(customers.length)} پېرودونکي'), cs.primary.withOpacity(0.12), cs.primary),
                    _pill(_tr('⚠️ ${_nf(withDebt)} with debt', '⚠️ ${_nf(withDebt)} بدهکار', '⚠️ ${_nf(withDebt)} پوروړي'), AppColors.warning.withOpacity(0.15), AppColors.warning),
                    _pill(_tr('✅ ${_nf(clear)} clear', '✅ ${_nf(clear)} تصفیه', '✅ ${_nf(clear)} پاک'), AppColors.success.withOpacity(0.15), AppColors.success),
                  ],
                ),
              ),
              Expanded(
                child: customers.isEmpty
                    ? Center(
                        child: Text(
                          _tr('No customers found', 'مشتری یافت نشد', 'پېرودونکی ونه موندل شو'),
                          style: theme.textTheme.titleMedium,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: customers.length,
                        itemBuilder: (context, index) {
                          final customer = customers[index];
                          final hasDebt = customer.totalOwed > 0;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: hasDebt ? AppColors.warning.withOpacity(0.18) : cs.primary.withOpacity(0.14),
                                child: Text(customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?'),
                              ),
                              title: Text(customer.name),
                              subtitle: customer.phone == null || customer.phone!.isEmpty ? null : Text(customer.phone!),
                              trailing: hasDebt
                                  ? Text(
                                      _na('${_nf(customer.totalOwed)} ${_tr('AFN', '؋', '؋')}'),
                                      style: theme.textTheme.titleSmall?.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      _tr('No debt', 'بدون بدهی', 'بې پور'),
                                      style: theme.textTheme.labelMedium?.copyWith(color: AppColors.success),
                                    ),
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
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _pill(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
