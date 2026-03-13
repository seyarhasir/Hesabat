import 'package:flutter/material.dart';

import '../../core/utils/number_system_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/settings/calendar_system_provider.dart';

class CurrencySelector extends StatelessWidget {
  final String selectedCurrency;
  final Map<String, double> afnToRate;
  final DateTime? lastUpdated;
  final ValueChanged<String> onSelected;
  final String Function(String en, String fa, [String? ps]) tr;
  final CalendarType calendar;
  final String locale;

  const CurrencySelector({
    super.key,
    required this.selectedCurrency,
    required this.afnToRate,
    required this.lastUpdated,
    required this.onSelected,
    required this.tr,
    this.calendar = CalendarType.gregorian,
    this.locale = 'fa',
  });

  @override
  Widget build(BuildContext context) {
    String nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);
    String na(String s) => NumberSystemFormatter.apply(s);

    String subtitle(String code) {
      if (code == 'AFN') return '${nf(1)} AFN';
      final rate = afnToRate[code] ?? 0;
      return rate > 0 ? '${nf(1)} AFN = ${nf(rate, d: code == 'PKR' ? 2 : 3)} $code' : tr('Rate unavailable', 'نرخ ناموجود', 'نرخ نشته');
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text(tr('Select currency', 'انتخاب پول', 'اسعار وټاکئ'))),
          _tile(context, 'AFN', subtitle('AFN')),
          _tile(context, 'USD', subtitle('USD')),
          _tile(context, 'PKR', subtitle('PKR')),
          if (lastUpdated != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  tr(
                    'Last updated: ${na(_fmt(lastUpdated!))}',
                    'آخرین بروزرسانی: ${na(_fmt(lastUpdated!))}',
                    'وروستی تازه‌کول: ${na(_fmt(lastUpdated!))}',
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, String code, String subtitle) {
    return ListTile(
      title: Text(code),
      subtitle: Text(subtitle),
      trailing: selectedCurrency == code ? const Icon(Icons.check_rounded) : null,
      onTap: () {
        onSelected(code);
        Navigator.pop(context);
      },
    );
  }

  String _fmt(DateTime dt) {
    return DateFormatter.formatDateTime(dt, calendar: calendar, locale: locale);
  }
}
