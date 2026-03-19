import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/number_system_formatter.dart';
import '../../core/settings/currency_preference_provider.dart';

class CurrencyDisplay extends ConsumerWidget {
  final double amount;
  final String currency; // Original currency (usually AFN)
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

  String _getCurrencySymbol(String code) {
    switch (code.toUpperCase()) {
      case 'AFN':
        return '\u060B';
      case 'USD':
        return '\$';
      case 'PKR':
        return '\u20A8';
      case 'IRR':
        return 'IR'; // User preferred 'IR' label for Rial
      default:
        return code;
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final targetCurrency = ref.watch(currencyPreferenceProvider);
    final snapshotAsync = ref.watch(exchangeRateSnapshotProvider);

    final defaultStyle = style ??
        theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w600,
        );

    // Default to provided amount if no conversion needed or available
    double displayAmount = amount;
    String displayCurrency = currency;

    snapshotAsync.whenData((snapshot) {
      if (currency != targetCurrency) {
        final fromRate = snapshot.ratesFromAfn[currency] ?? (currency == 'AFN' ? 1.0 : null);
        final toRate = snapshot.ratesFromAfn[targetCurrency] ?? (targetCurrency == 'AFN' ? 1.0 : null);

        if (fromRate != null && toRate != null && fromRate > 0) {
          displayAmount = amount * (toRate / fromRate);
          displayCurrency = targetCurrency;
        }
      }
    });

    final children = <Widget>[
      Text(
        '${_formatAmount(displayAmount)} ${_getCurrencySymbol(displayCurrency)}',
        style: defaultStyle,
        textDirection: TextDirection.ltr,
      ),
    ];

    if (showOriginal && (originalAmount != null || (displayCurrency != currency))) {
      final actualOriginalAmount = originalAmount ?? amount;
      final actualOriginalCurrency = originalCurrency ?? currency;

      children.add(
        Text(
          ' (${_formatAmount(actualOriginalAmount)} ${actualOriginalCurrency == 'AFN' ? '\u060B' : actualOriginalCurrency})',
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
