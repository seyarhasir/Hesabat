import 'package:intl/intl.dart';

import '../settings/number_system_provider.dart';

class NumberSystemFormatter {
  static NumberSystem _system = NumberSystem.english;

  static void setSystem(NumberSystem system) {
    _system = system;
  }

  static NumberSystem get currentSystem => _system;

  static String formatFixed(num value, {int fractionDigits = 0}) {
    final decimalPattern = fractionDigits > 0 ? '.${'0' * fractionDigits}' : '';
    final formatter = NumberFormat('#,##0$decimalPattern', 'en_US');
    final raw = formatter.format(value);
    return apply(raw);
  }

  static String apply(String input) {
    if (_system == NumberSystem.english) return input;

    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    var out = input;
    for (var i = 0; i < en.length; i++) {
      out = out.replaceAll(en[i], fa[i]);
    }
    return out;
  }
}
