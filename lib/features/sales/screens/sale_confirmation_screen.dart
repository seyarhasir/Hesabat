import 'package:flutter/material.dart';

import '../../../core/utils/number_system_formatter.dart';

class SaleConfirmationScreen extends StatelessWidget {
  const SaleConfirmationScreen({super.key});

  String _tr(String lang, String en, String fa, [String? ps]) => lang == 'fa' ? fa : (lang == 'ps' ? (ps ?? fa) : en);
  String _nf(num value, {int d = 0}) => NumberSystemFormatter.formatFixed(value, fractionDigits: d);
  String _na(String value) => NumberSystemFormatter.apply(value);

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final items = (args?['items'] as List<dynamic>? ?? const []).cast<Map<String, dynamic>>();
    final total = (args?['total'] as num?)?.toDouble() ?? 0;
    final subtotal = (args?['subtotal'] as num?)?.toDouble() ?? total;
    final discount = (args?['discount'] as num?)?.toDouble() ?? 0;
    final totalAfn = (args?['totalAfn'] as num?)?.toDouble() ?? total;
    final currency = (args?['currency']?.toString() ?? 'AFN');
    final paymentMethod = (args?['paymentMethod']?.toString() ?? 'cash');
    final customerName = args?['customerName']?.toString();

    String currencySymbol(String code) {
      switch (code) {
        case 'USD':
          return r'$';
        case 'PKR':
          return '₨';
        default:
          return _tr(lang, 'AFN', '؋', '؋');
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Icon(Icons.check_circle_rounded, size: 88, color: Colors.green),
              const SizedBox(height: 12),
              Text(
                _tr(lang, 'Sale recorded!', 'فروش ثبت شد!', 'پلور ثبت شو!'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tr(lang, 'Sale Receipt', 'رسید فروش', 'د پلور رسید'),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      ...items.take(5).map((item) {
                        final quantity = (item['quantity'] as num?)?.toDouble() ?? 0;
                        final price = (item['price'] as num?)?.toDouble() ?? 0;
                        final subtotal = quantity * price;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text('${item['name']} × ${_nf(quantity)}')),
                              Text('${_nf(subtotal)} ${currencySymbol(currency)}'),
                            ],
                          ),
                        );
                      }),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_tr(lang, 'Payment:', 'پرداخت:', 'تادیه:')),
                          Text(
                            paymentMethod == 'credit'
                                ? _tr(lang, 'Qarz', 'قرض', 'قرض')
                                : paymentMethod == 'mixed'
                                    ? _tr(lang, 'Mixed', 'مختلط', 'ګډ')
                                    : _tr(lang, 'Cash', 'نقد', 'نغد'),
                          ),
                        ],
                      ),
                      if (paymentMethod == 'credit' && customerName != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_tr(lang, 'Customer:', 'مشتری:', 'پېرودونکی:')),
                            Text(customerName),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_tr(lang, 'Subtotal:', 'جمع فرعی:', 'فرعي جمع:')),
                          Text('${_nf(subtotal)} ${currencySymbol(currency)}'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_tr(lang, 'Discount:', 'تخفیف:', 'تخفیف:')),
                          Text('${_nf(discount)} ${currencySymbol(currency)}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_tr(lang, 'Total:', 'جمع کل:', 'ټول:')),
                          Text(
                            '${_nf(total)} ${currencySymbol(currency)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (currency != 'AFN') ...[
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _na(_tr(
                              'AFN equivalent: ${_nf(totalAfn)} ؋',
                              'معادل افغانی: ${_nf(totalAfn)} ؋',
                              'د افغانۍ معادل: ${_nf(totalAfn)} ؋',
                            )),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.send_rounded),
                  label: Text(_tr(lang, 'Send via WhatsApp', 'ارسال واتساپ', 'د واتساپ له لارې لېږل')),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  label: Text(_tr(lang, 'Save PDF', 'ذخیره PDF', 'PDF خوندي کول')),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/sales', (_) => false),
                child: Text(_tr(lang, 'New Sale', 'فروش جدید', 'نوی پلور')),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
                child: Text(_tr(lang, 'Back to Home', 'بازگشت به خانه', 'کور ته ستنېدل')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
