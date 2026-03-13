import 'package:flutter/material.dart';
import '../../core/utils/number_system_formatter.dart';
import '../theme/app_layout.dart';
import '../theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String? barcode;
  final double price;
  final double stockQuantity;
  final double? minStockAlert;
  final String unit;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.name,
    this.barcode,
    required this.price,
    required this.stockQuantity,
    this.minStockAlert,
    required this.unit,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isLowStock = minStockAlert != null && stockQuantity <= minStockAlert!;
    final isOutOfStock = stockQuantity <= 0;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.large,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: AppRadius.large,
          border: Border.all(
            color: isOutOfStock 
                ? AppColors.danger.withOpacity(0.3) 
                : isLowStock 
                    ? AppColors.warning.withOpacity(0.3) 
                    : cs.outline.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: cs.onSurface.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon/Avatar placeholder
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (isOutOfStock ? AppColors.danger : cs.primary).withOpacity(0.1),
                borderRadius: AppRadius.medium,
              ),
              child: Icon(
                isOutOfStock ? Icons.error_outline_rounded : Icons.inventory_2_rounded,
                color: isOutOfStock ? AppColors.danger : cs.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: isOutOfStock ? TextDecoration.lineThrough : null,
                      color: isOutOfStock ? cs.onSurface.withOpacity(0.4) : cs.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '${NumberSystemFormatter.formatFixed(price)} ${Localizations.localeOf(context).languageCode == 'en' ? 'AFN' : '؋'}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: cs.onSurface.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Text(
                        '${NumberSystemFormatter.formatFixed(stockQuantity)} $unit',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isOutOfStock 
                              ? AppColors.danger 
                              : isLowStock 
                                  ? AppColors.warning 
                                  : cs.onSurface.withOpacity(0.5),
                          fontWeight: (isLowStock || isOutOfStock) ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  if (barcode != null && barcode!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${Localizations.localeOf(context).languageCode == 'en' ? 'Barcode' : 'بارکد'}: $barcode',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
