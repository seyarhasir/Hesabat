import 'package:flutter/material.dart';
import '../../core/utils/number_system_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../theme/app_layout.dart';
import '../theme/app_colors.dart';

class TransactionCard extends StatelessWidget {
  final double amount;
  final String paymentMethod;
  final DateTime createdAt;
  final String currencySymbol;
  final VoidCallback? onTap;
  final String locale;
  final CalendarType calendarType;
  final bool isVisible;

  const TransactionCard({
    super.key,
    required this.amount,
    required this.paymentMethod,
    required this.createdAt,
    this.currencySymbol = '؋',
    this.onTap,
    required this.locale,
    required this.calendarType,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    
    final isCredit = paymentMethod == 'credit';
    final isMixed = paymentMethod == 'mixed';
    final statusColor = isCredit 
        ? AppColors.warning 
        : (isMixed ? const Color(0xFF8B5CF6) : AppColors.success);
    
    String t(String en, String fa, String ps) {
      if (locale == 'en') return en;
      if (locale == 'ps') return ps;
      return fa;
    }

    final methodLabel = _getMethodLabel(paymentMethod, t);
    final relativeDate = DateFormatter.formatRelative(createdAt, locale: locale, calendar: calendarType);
    final fullDate = DateFormatter.formatDisplayDateTime(createdAt, locale: locale, calendar: calendarType);

    final amountText = isVisible 
      ? '${NumberSystemFormatter.formatFixed(amount)} $currencySymbol'
      : '• • • •';

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.large,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: AppRadius.large,
          border: Border.all(
            color: cs.outline.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: cs.onSurface.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: AppRadius.medium,
              ),
              child: Icon(
                _getMethodIcon(paymentMethod),
                color: statusColor,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        amountText,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      Text(
                        relativeDate,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          methodLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Text(
                        '•',
                        style: TextStyle(color: cs.onSurface.withValues(alpha: 0.2)),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: Text(
                          fullDate,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.4),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            Icon(Icons.chevron_right_rounded, color: cs.onSurface.withValues(alpha: 0.2), size: 20),
          ],
        ),
      ),
    );
  }

  IconData _getMethodIcon(String method) {
    switch (method) {
      case 'credit':
        return Icons.credit_card_rounded;
      case 'mixed':
        return Icons.account_balance_wallet_rounded;
      case 'cash':
      default:
        return Icons.payments_rounded;
    }
  }

  String _getMethodLabel(String method, String Function(String, String, String) t) {
    switch (method) {
      case 'credit':
        return t('Credit', 'قرضی', 'قرض');
      case 'mixed':
        return t('Split', 'ترکیبی', 'ګډ');
      default:
        return t('Cash', 'نقدی', 'نغدي');
    }
  }
}
