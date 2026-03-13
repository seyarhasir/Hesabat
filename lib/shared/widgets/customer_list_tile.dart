import 'package:flutter/material.dart';
import '../../core/utils/number_system_formatter.dart';
import '../theme/app_colors.dart';
import 'debt_badge.dart';

class CustomerListTile extends StatelessWidget {
  final String name;
  final String? phone;
  final double totalOwed;
  final DateTime? lastInteractionAt;
  final VoidCallback? onTap;
  final VoidCallback? onCall;
  final VoidCallback? onWhatsApp;

  const CustomerListTile({
    super.key,
    required this.name,
    this.phone,
    required this.totalOwed,
    this.lastInteractionAt,
    this.onTap,
    this.onCall,
    this.onWhatsApp,
  });

  int get _daysSinceInteraction {
    if (lastInteractionAt == null) return 999;
    return DateTime.now().difference(lastInteractionAt!).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: totalOwed > 0
                      ? AppColors.warning.withOpacity(0.1)
                      : AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: totalOwed > 0 ? AppColors.warning : AppColors.success,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (phone != null)
                      Text(phone!, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 4),
                    if (totalOwed > 0)
                      DebtBadge(
                        amount: totalOwed,
                        daysSince: _daysSinceInteraction,
                        isCompact: true,
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Paid off',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Actions
              if (totalOwed > 0 && onWhatsApp != null)
                IconButton(
                  onPressed: onWhatsApp,
                  icon: Icon(Icons.message, color: AppColors.success),
                  iconSize: 24,
                ),
              // Debt amount
              if (totalOwed > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${NumberSystemFormatter.formatFixed(totalOwed)} \u060B',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.danger,
                      ),
                    ),
                    if (lastInteractionAt != null)
                      Text(
                        '${NumberSystemFormatter.formatFixed(_daysSinceInteraction)}d ago',
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
