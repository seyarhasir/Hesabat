import 'package:flutter/material.dart';

import '../../../core/utils/number_system_formatter.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  String _tr(String lang, String en, String fa, [String? ps]) => lang == 'fa' ? fa : (lang == 'ps' ? (ps ?? fa) : en);

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    String nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);
    return Scaffold(
      appBar: AppBar(title: Text(_tr(lang, 'Subscription', 'اشتراک', 'ګډون'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(_tr(lang, 'Current plan: Free trial', 'پلن فعلی: آزمایشی رایگان', 'اوسنی پلان: وړیا ازمایښتي')),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_tr(lang, 'Basic Plan — ${nf(400)} AFN / month', 'پلن پایه — ${nf(400)} ؋ / ماه', 'بنسټیز پلان — ${nf(400)} افغانۍ / میاشت')),
                  const SizedBox(height: 8),
                  Text(_tr(lang, '✅ Unlimited products', '✅ محصولات نامحدود', '✅ نامحدود محصولات')),
                  Text(_tr(lang, '✅ WhatsApp reminders', '✅ یادآوری واتساپ', '✅ د واتساپ یادونې')),
                  Text(_tr(lang, '✅ Unlimited PDF', '✅ PDF نامحدود', '✅ نامحدود PDF')),
                  const SizedBox(height: 8),
                  FilledButton(onPressed: () {}, child: Text(_tr(lang, 'Choose Basic Plan', 'انتخاب پلن پایه', 'بنسټیز پلان وټاکئ'))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_tr(lang, 'Annual Plan — ${nf(3600)} AFN / year', 'پلن سالانه — ${nf(3600)} ؋ / سال', 'کلنی پلان — ${nf(3600)} افغانۍ / کال')),
                  const SizedBox(height: 8),
                  FilledButton(onPressed: () {}, child: Text(_tr(lang, 'Choose Annual Plan', 'انتخاب پلن سالانه', 'کلنی پلان وټاکئ'))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
