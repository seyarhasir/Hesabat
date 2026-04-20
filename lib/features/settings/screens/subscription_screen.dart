import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/auth/auth_state_notifier.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/currency_display.dart';
import '../../../core/settings/shop_profile_service.dart';
import '../../../core/settings/calendar_system_provider.dart';
import '../../../core/utils/date_formatter.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  String _tr(String lang, String en, String fa, [String? ps]) => lang == 'fa' ? fa : (lang == 'ps' ? (ps ?? fa) : en);

  String _effectiveStatus(ShopProfile? profile, bool isGuest) {
    if (isGuest || profile == null) return 'guest';

    // If computed state says inactive, treat as expired for UI regardless of raw status.
    if (!profile.isSubscriptionActive) return 'expired';

    if (profile.subscriptionStatus == 'trial') return 'trial';
    if (profile.subscriptionStatus == 'expired' || profile.subscriptionStatus == 'suspended') {
      return 'expired';
    }

    return 'active';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Localizations.localeOf(context).languageCode;
    final authState = ref.watch(authStateNotifierProvider);
    String nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(_tr(lang, 'Subscription', 'اشتراک', 'ګډون'))),
      body: FutureBuilder<ShopProfile?>(
        future: ShopProfileService.loadWithCloudFallback(),
        builder: (context, snapshot) {
          final profile = snapshot.data;
          final isGuest = authState.status != AuthStatus.authenticated;
          final effectiveStatus = _effectiveStatus(profile, isGuest);
          
          String planDescription = effectiveStatus == 'guest'
              ? _tr(lang, 'Demo Mode', 'حالت آزمایشی', 'ازمایښتي حالت')
              : (effectiveStatus == 'trial'
                ? _tr(lang, 'Trial Period', 'دوره آزمایشی', 'ازمایښتي دوره')
                : (effectiveStatus == 'expired'
                  ? _tr(lang, 'Expired', 'منقضی شده', 'پای ته رسیدلی')
                  : _tr(lang, 'Active Plan', 'پلن فعال', 'فعال پلان')));

          String? dateInfo;
          if (!isGuest && profile != null) {
            final date = effectiveStatus == 'trial' ? profile.trialEndsAt : profile.subscriptionEndsAt;
            if (date != null) {
              final calendarSystem = ref.read(appCalendarSystemProvider);
              final formattedDate = NumberSystemFormatter.apply(
                DateFormatter.formatDate(date, 
                  calendar: calendarSystem == CalendarSystem.persian ? CalendarType.persian : CalendarType.gregorian,
                  locale: lang,
                ),
              );
              dateInfo = effectiveStatus == 'expired'
                  ? _tr(lang, 'Expired on $formattedDate', 'در تاریخ $formattedDate منقضی شد', 'په $formattedDate پای ته ورسېد')
                  : _tr(lang, 'Expires on $formattedDate', 'تاریخ انقضا: $formattedDate', 'د ختمیدو نیټه: $formattedDate');
            }
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: profile?.isSubscriptionActive == false ? AppColors.danger.withOpacity(0.1) : cs.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: profile?.isSubscriptionActive == false ? AppColors.danger.withOpacity(0.3) : cs.primary.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Text(planDescription, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    if (dateInfo != null) ...[
                      const SizedBox(height: 8),
                      Text(dateInfo, style: TextStyle(color: profile?.isSubscriptionActive == false ? AppColors.danger : cs.onSurfaceVariant)),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(_tr(lang, 'Available Plans', 'پلن‌های موجود', 'شته پلانونه'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildPlanCard(
                context,
                lang: lang,
                title: _tr(lang, 'Basic Plan', 'پلن پایه', 'بنسټیز پلان'),
                price: 400,
                period: _tr(lang, 'month', 'ماه', 'میاشت'),
                features: [
                  _tr(lang, 'Unlimited products', 'محصولات نامحدود', 'نامحدود محصولات'),
                  _tr(lang, 'WhatsApp reminders', 'یادآوری واتساپ', 'د واتساپ یادونې'),
                  _tr(lang, 'Cloud sync', 'همگام‌سازی ابری', 'د کلاوډ همغږي'),
                ],
              ),
              const SizedBox(height: 12),
              _buildPlanCard(
                context,
                lang: lang,
                title: _tr(lang, 'Annual Plan', 'پلن سالانه', 'کلنی پلان'),
                price: 4000,
                period: _tr(lang, 'year', 'سال', 'کال'),
                features: [
                  _tr(lang, 'Everything in Basic', 'همه امکانات پلن پایه', 'د بنسټیز پلان ټولې اسانتیاوې'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_tr(lang, 'Save ', 'صرفه جویی ', 'د ')),
                      CurrencyDisplay(
                        amount: 800, 
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (lang == 'en') const Text(' AFN'),
                      if (lang == 'ps') const Text(' افغانیو سپما'),
                    ],
                  ),
                ],
                isPopular: true,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.amber),
                    const SizedBox(height: 8),
                    Text(
                      _tr(lang, 
                        'To renew or upgrade, please contact our support team or pay in cash at our office.',
                        'برای تمدید یا ارتقا، لطفاً با تیم پشتیبانی ما تماس بگیرید یا هزینه را به صورت نقدی در دفتر ما پرداخت کنید.',
                        'د تمدید یا ارتقا لپاره، مهرباني وکړئ زموږ د ملاتړ ټیم سره اړیکه ونیسئ یا زموږ په دفتر کې نغدي پیسې ورکړئ.'
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _contactAction(context, Icons.phone_rounded, 'Call', 'tel:+93772654965'),
                        const SizedBox(width: 8),
                        _contactAction(context, Icons.chat_outlined, 'WhatsApp', 'https://wa.me/93772654965'),
                        const SizedBox(width: 8),
                        _contactAction(context, Icons.email_outlined, 'Email', 'mailto:support@hesabat.app'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _contactAction(BuildContext context, IconData icon, String label, String url) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.orange.shade800),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange.shade900)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String lang,
    required String title,
    required double price,
    required String period,
    required List<dynamic> features,
    bool isPopular = false,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: isPopular ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isPopular ? BorderSide(color: cs.primary, width: 2) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(8)),
                child: Text(_tr(lang, 'BEST VALUE', 'بهترین ارزش', 'غوره ارزښت'), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                CurrencyDisplay(
                  amount: price,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(' / $period', style: TextStyle(color: cs.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 16),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 18, color: cs.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: f is Widget ? f : Text(f.toString()),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
