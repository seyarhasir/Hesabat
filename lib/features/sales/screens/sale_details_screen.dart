import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/settings/calendar_system_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../core/settings/shop_profile_service.dart';
import '../../../core/utils/receipt_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_layout.dart';

class SaleDetailsScreen extends ConsumerWidget {
  final Sale sale;

  const SaleDetailsScreen({
    super.key,
    required this.sale,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final db = ref.watch(databaseProvider);

    String t(String en, String fa, [String? ps]) =>
        lang == 'fa' ? fa : (lang == 'ps' ? (ps ?? fa) : en);

    final calendarSystem = ref.watch(appCalendarSystemProvider);
    final calendarType = calendarSystem == CalendarSystem.persian
        ? CalendarType.persian
        : CalendarType.gregorian;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(t('Sale Details', 'جزئیات فروش', 'د پلور جزییات')),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () async {
              final items = await db.salesDao.getSaleItems(sale.id);
              final mappedItems = items.map((item) => {
                'name': item.productNameSnapshot,
                'quantity': item.quantity,
                'price': item.unitPrice,
              }).toList();

              await ReceiptService.shareReceipt(
                items: mappedItems,
                total: sale.totalAfn,
                currency: 'AFN', // History currently shows AFN totals
                paymentMethod: sale.paymentMethod,
                lang: lang,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<SaleItem>>(
        future: db.salesDao.getSaleItems(sale.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: AppRadius.large,
                    border: Border.all(color: cs.outline.withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        decoration: BoxDecoration(
                          color: _getStatusColor(sale.paymentMethod, cs).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getStatusIcon(sale.paymentMethod),
                          color: _getStatusColor(sale.paymentMethod, cs),
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.m),
                      Text(
                        '${NumberSystemFormatter.formatFixed(sale.totalAfn)} ؋',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getPaymentLabel(sale.paymentMethod, t),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: _getStatusColor(sale.paymentMethod, cs),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.l),
                      const Divider(),
                      const SizedBox(height: AppSpacing.l),
                      _infoRow(
                        t('Transaction Date', 'تاریخ تراکنش', 'د معاملې نېټه'),
                        DateFormatter.formatDisplayDateTime(sale.createdAt,
                            locale: lang, calendar: calendarType),
                        theme,
                        cs,
                      ),
                      const SizedBox(height: AppSpacing.m),
                      _infoRow(
                        t('Transaction ID', 'شناسه تراکنش', 'د معاملې پیژند'),
                        '#${sale.id.toUpperCase().substring(0, 8)}',
                        theme,
                        cs,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.l),

                // Items list
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.l),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: AppRadius.large,
                    border: Border.all(color: cs.outline.withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t('Items', 'کالاها', 'توکي'),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.m),
                      ...items.map((item) => _itemRow(item, theme, cs)),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.s),
                        child: Divider(),
                      ),
                      _summaryRow(
                        t('Total Amount', 'مجموع کل', 'ټولیز مبلغ'),
                        '${NumberSystemFormatter.formatFixed(sale.totalAfn)} ؋',
                        theme,
                        cs,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
                
                if (sale.paymentMethod == 'credit') ...[
                  const SizedBox(height: AppSpacing.l),
                   Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.l),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.05),
                      borderRadius: AppRadius.large,
                      border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.report_problem_rounded, color: AppColors.warning),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: Text(
                            t(
                              'This is a credit sale. Check debts for details.',
                              'این یک فروش قرضی است. برای جزئیات به بخش بدهی‌ها مراجعه کنید.',
                              'دا یو قرضي پلور دی. د جزییاتو لپاره پورونو برخې ته ولاړ شئ'
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange.shade900),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value, ThemeData theme, ColorScheme cs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface.withValues(alpha: 0.5))),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _itemRow(SaleItem item, ThemeData theme, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productNameSnapshot,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${NumberSystemFormatter.formatFixed(item.quantity)} × ${NumberSystemFormatter.formatFixed(item.unitPrice)} ؋',
                  style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.5)),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Text(
            '${NumberSystemFormatter.formatFixed(item.subtotal)} ؋',
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, ThemeData theme, ColorScheme cs, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isBold ? cs.primary : null,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String method, ColorScheme cs) {
    switch (method) {
      case 'credit':
        return AppColors.warning;
      case 'mixed':
        return cs.secondary;
      default:
        return AppColors.success;
    }
  }

  IconData _getStatusIcon(String method) {
    switch (method) {
      case 'credit':
        return Icons.credit_card_rounded;
      case 'mixed':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  String _getPaymentLabel(String method, String Function(String en, String fa, [String? ps]) t) {
    switch (method) {
      case 'credit':
        return t('Credit', 'قرضی', 'قرض');
      case 'mixed':
        return t('Split Payment', 'ترکیبی', 'ګډه تادیه');
      default:
        return t('Cash', 'نقدی', 'نغدي');
    }
  }
}
