import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount, String currency) {
    final symbol = _getSymbol(currency);
    
    // Format with thousands separator
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final formatted = formatter.format(amount);
    
    if (currency == 'AFN') {
      // For AFN, put symbol after the number (Afghan convention)
      return '$formatted $symbol';
    } else {
      // For USD/PKR, put symbol before
      return '$symbol$formatted';
    }
  }
  
  static String formatCompact(double amount, String currency) {
    final symbol = _getSymbol(currency);
    
    if (amount >= 1000000) {
      return '${symbol}${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${symbol}${(amount / 1000).toStringAsFixed(1)}K';
    }
    
    return format(amount, currency);
  }
  
  static String _getSymbol(String currency) {
    switch (currency) {
      case 'AFN':
        return '؋';
      case 'USD':
        return '\$';
      case 'PKR':
        return '₨';
      default:
        return currency;
    }
  }
  
  static double convert(double amount, String from, String to, double rate) {
    if (from == to) return amount;
    return amount * rate;
  }
}
