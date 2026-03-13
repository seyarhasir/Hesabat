import 'package:flutter/material.dart';

import '../../core/utils/number_system_formatter.dart';

class CurrencyDisplay extends StatelessWidget {
  final double amount;
  final String currency;
  final bool showOriginal;
  final double? originalAmount;
  final String? originalCurrency;
  final TextStyle? style;
  final bool isRTL;

  const CurrencyDisplay({
    super.key,
    required this.amount,
    this.currency = 'AFN',
    this.showOriginal = false,
    this.originalAmount,
    this.originalCurrency,
    this.style,
    this.isRTL = true,
  });

  String get _currencySymbol {
    switch (currency) {
      case 'AFN': return '\u060B';
      case 'USD': return '\$';
      case 'PKR': return '\u20A8';
      default: return currency;
    }
  }

  String _formatAmount(double value) {
    final decimalPart = (value * 100).toInt() % 100;
    if (decimalPart > 0) {
      return NumberSystemFormatter.formatFixed(value, fractionDigits: 2);
    }
    return NumberSystemFormatter.formatFixed(value, fractionDigits: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = style ?? theme.textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.w600,
    );

    final children = <Widget>[
      Text(
        '${_formatAmount(amount)} $_currencySymbol',
        style: defaultStyle,
        textDirection: TextDirection.ltr,
      ),
    ];

    if (showOriginal && originalAmount != null && originalCurrency != null) {
      children.add(
        Text(
          ' (${_formatAmount(originalAmount!)} $originalCurrency)',
          style: defaultStyle.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontSize: (defaultStyle.fontSize ?? 16) * 0.85,
            fontWeight: FontWeight.normal,
          ),
          textDirection: TextDirection.ltr,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.ltr,
      children: children,
    );
  }
}

class CurrencyInput extends StatelessWidget {
  final String currency;
  final VoidCallback? onTap;
  final bool isSelected;

  const CurrencyInput({
    super.key,
    required this.currency,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outline,
          ),
        ),
        child: Text(
          currency,
          style: TextStyle(
            color: isSelected ? cs.onPrimary : cs.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
