import 'package:flutter/material.dart';
import '../theme/app_layout.dart';
import 'currency_display.dart';

/// A unified stat card component to replace duplicated cards in Home, Summary, and Qarz.
class AppStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;
  final bool isCompact;
  final bool showIconBackground;
  final double? amount;
  final String? originalCurrency;

  const AppStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.color,
    this.onTap,
    this.isCompact = false,
    this.showIconBackground = true,
    this.amount,
    this.originalCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final primaryColor = color ?? cs.primary;

    if (isCompact) return _buildCompact(context, primaryColor);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.xxLarge,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: AppRadius.xxLarge,
          border: Border.all(color: cs.outline.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  if (showIconBackground)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: AppRadius.medium,
                      ),
                      child: Icon(icon, color: primaryColor, size: 20),
                    )
                  else
                    Icon(icon, color: primaryColor, size: 20),
                  const SizedBox(width: AppSpacing.m),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            if (amount != null)
              CurrencyDisplay(
                amount: amount!,
                currency: originalCurrency ?? 'AFN',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              )
            else
              Text(
                value,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompact(BuildContext context, Color primaryColor) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.large,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: AppRadius.large,
          border: Border.all(color: cs.outline.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              if (showIconBackground)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: AppRadius.small,
                  ),
                  child: Icon(icon, color: primaryColor, size: 18),
                )
              else
                Icon(icon, color: primaryColor, size: 18),
              const SizedBox(height: AppSpacing.m),
            ],
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            if (amount != null)
              CurrencyDisplay(
                amount: amount!,
                currency: originalCurrency ?? 'AFN',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              )
            else
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
