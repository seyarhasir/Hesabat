import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/auth/auth_state_notifier.dart';
import '../../../core/settings/app_locale_provider.dart';
import '../../../core/settings/number_system_provider.dart';
import '../../../core/settings/app_theme_mode_provider.dart';
import '../../../core/settings/calendar_system_provider.dart';
import '../../../core/settings/shop_profile_service.dart';
import '../../../core/utils/exchange_rate_service.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../core/settings/currency_preference_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_layout.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/currency_display.dart';

/// Settings Screen - App configuration and user preferences
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  bool _isEn(BuildContext context) => Localizations.localeOf(context).languageCode == 'en';
  String _tr(BuildContext context, String en, String fa, [String? ps]) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'fa') return fa;
    if (lang == 'ps') return ps ?? fa;
    return en;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateNotifierProvider);
    final isGuest = authState.status != AuthStatus.authenticated;
    final locale = ref.watch(appSettingsLocaleProvider);
    final numberSystem = ref.watch(appNumberSystemProvider);
    final calendarSystem = ref.watch(appCalendarSystemProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final currentLanguage = switch (locale.languageCode) {
      'fa' => 'دری (Dari)',
      'ps' => 'پښتو (Pashto)',
      _ => 'English',
    };
    final currentTheme = switch (themeMode) {
      ThemeMode.light => _tr(context, 'Light', 'روشن', 'روښانه'),
      ThemeMode.dark => _tr(context, 'Dark', 'تاریک', 'تیاره'),
      ThemeMode.system => _tr(context, 'System', 'سیستم', 'سیستم'),
    };
    final currentNumberSystem = switch (numberSystem) {
      NumberSystem.english => _tr(context, 'English digits (0-9)', 'ارقام انگلیسی (0-9)', 'انګلیسي شمېرې (0-9)'),
      NumberSystem.farsi => _tr(context, 'Farsi digits (۰-۹)', 'ارقام فارسی (۰-۹)', 'فارسي شمېرې (۰-۹)'),
    };
    final currentCalendarSystem = switch (calendarSystem) {
      CalendarSystem.gregorian => _tr(context, 'Gregorian Calendar', 'تقویم میلادی', 'میلادی کلیز'),
      CalendarSystem.persian => _tr(context, 'Persian Calendar', 'تقویم شمسی', 'شمسی کلیز'),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tr(context, 'Settings', 'تنظیمات'),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
        children: [
          // Profile Section
          _buildGroupHeader(context, _tr(context, 'Shop', 'دکان', 'دوکان'), Icons.person_outline_rounded),
          FutureBuilder<ShopProfile?>(
            future: ShopProfileService.loadWithCloudFallback(),
            builder: (context, snapshot) {
              final profile = snapshot.data;
              final subtitle = isGuest
                  ? _tr(context, 'Demo Shop', 'دکان آزمایشی', 'ازمایښتي دوکان')
                  : (profile?.shopName.isNotEmpty == true
                      ? profile!.shopName
                      : _tr(context, 'Active Shop', 'دکان فعال', 'فعال دوکان'));

              return _buildSettingTile(
                context,
                title: _tr(context, 'Shop Info', 'اطلاعات دکان', 'د دوکان معلومات'),
                subtitle: subtitle,
                leadingIcon: Icons.store_rounded,
                leadingBgColor: Colors.blue,
                onTap: () => _showShopProfile(context, isGuest: isGuest),
              );
            },
          ),
          const SizedBox(height: AppSpacing.l),

          _buildGroupHeader(context, _tr(context, 'Subscription', 'اشتراک', 'ګډون'), Icons.workspace_premium_rounded),
          FutureBuilder<ShopProfile?>(
            future: ShopProfileService.loadWithCloudFallback(),
            builder: (context, snapshot) {
              final profile = snapshot.data;
              
              String planName = isGuest 
                  ? _tr(context, 'Demo (Limited)', 'آزمایشی (محدود)', 'ازمایښتي (محدود)')
                  : (profile?.subscriptionStatus == 'trial'
                    ? _tr(context, 'Trial Plan', 'پلن آزمایشی', 'ازمایښتي پلان')
                    : (profile?.subscriptionStatus == 'expired'
                      ? _tr(context, 'Expired', 'منقضی شده', 'پای ته رسیدلی')
                      : _tr(context, 'Active Plan', 'پلن فعال', 'فعال پلان')));
              
              String? dateSubtitle;
              if (!isGuest && profile != null) {
                final date = profile.subscriptionStatus == 'trial' ? profile.trialEndsAt : profile.subscriptionEndsAt;
                if (date != null) {
                  final calendarSystem = ref.read(appCalendarSystemProvider);
                  final calendarType = calendarSystem == CalendarSystem.persian ? CalendarType.persian : CalendarType.gregorian;
                  final formattedDate = NumberSystemFormatter.apply(
                    DateFormatter.formatDate(date, calendar: calendarType, locale: Localizations.localeOf(context).languageCode),
                  );
                  dateSubtitle = profile.subscriptionStatus == 'expired'
                      ? _tr(context, 'Expired on $formattedDate', 'در تاریخ $formattedDate منقضی شد', 'په $formattedDate پای ته ورسېد')
                      : _tr(context, 'Ends on $formattedDate', 'تا تاریخ $formattedDate', 'تر $formattedDate پورې');
                }
              }

              return _buildSettingTile(
                context,
                title: _tr(context, 'Current Plan', 'پلن فعلی', 'اوسنی پلان'),
                subtitle: dateSubtitle ?? planName,
                leadingIcon: Icons.card_membership_rounded,
                leadingBgColor: Colors.orange,
                trailing: isGuest
                    ? AppButton(
                        text: _tr(context, 'Upgrade', 'ارتقا', 'ارتقا'),
                        onPressed: () => _showUpgradeDialog(context),
                        size: AppButtonSize.small,
                      )
                    : const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.pushNamed(context, '/subscription'),
              );
            },
          ),
          const SizedBox(height: AppSpacing.l),

          // Preferences Section
          _buildGroupHeader(context, _tr(context, 'Preferences', 'ترجیحات', 'غوره توبونه'), Icons.settings_suggest_rounded),
          _buildSettingTile(
            context,
            title: _tr(context, 'Language', 'زبان', 'ژبه'),
            subtitle: currentLanguage,
            leadingIcon: Icons.translate_rounded,
            leadingBgColor: Colors.green,
            onTap: () => _showLanguageSettings(context, ref),
          ),
          _buildSettingTile(
            context,
            title: _tr(context, 'Number System', 'سیستم اعداد', 'د شمېرو سیستم'),
            subtitle: currentNumberSystem,
            leadingIcon: Icons.pin_outlined,
            leadingBgColor: Colors.indigo,
            onTap: () => _showNumberSystemSettings(context, ref),
          ),
          _buildSettingTile(
            context,
            title: _tr(context, 'Calendar', 'تقویم', 'کلیز'),
            subtitle: currentCalendarSystem,
            leadingIcon: Icons.calendar_month_outlined,
            leadingBgColor: Colors.teal,
            onTap: () => _showCalendarSettings(context, ref),
          ),
          FutureBuilder<String>(
            future: _exchangeRateSubtitle(context, ref),
            builder: (context, snapshot) {
              return _buildSettingTile(
                context,
                title: _tr(context, 'Currency', 'پول', 'اسعار'),
                subtitle: snapshot.data ?? _tr(context, 'AFN (rates unavailable)', 'افغانی (نرخ ناموجود)', 'افغانۍ (نرخ نشته)'),
                leadingIcon: Icons.payments_outlined,
                leadingBgColor: Colors.greenAccent[700],
                onTap: () => _showCurrencySettings(context, ref),
              );
            },
          ),
          _buildSettingTile(
            context,
            title: _tr(context, 'Theme', 'تم', 'بڼه'),
            subtitle: currentTheme,
            leadingIcon: Icons.dark_mode_outlined,
            leadingBgColor: Colors.deepPurple,
            onTap: () => _showThemeSettings(context, ref),
          ),
          const SizedBox(height: AppSpacing.l),

          // Data & Privacy Section
          _buildGroupHeader(context, _tr(context, 'Data & Privacy', 'داده‌ها و حریم خصوصی', 'معلومات او محرمیت'), Icons.security_rounded),
          _buildSettingTile(
            context,
            title: _tr(context, 'Data Export', 'استخراج داده‌ها', 'د معلوماتو استخراج'),
            subtitle: _tr(context, 'Backup as CSV or PDF', 'پشتیبان‌گیری به صورت CSV یا PDF', 'CSV یا PDF په بڼه بک اپ'),
            leadingIcon: Icons.ios_share_rounded,
            leadingBgColor: Colors.teal,
            onTap: () => Navigator.pushNamed(context, '/settings/export'),
          ),
          const SizedBox(height: AppSpacing.l),

          // Support Section
          _buildGroupHeader(context, _tr(context, 'Support', 'پشتیبانی', 'ملاتړ'), Icons.help_outline_rounded),
          _buildSettingTile(
            context,
            title: _tr(context, 'Help & FAQ', 'راهنما و سوالات', 'مرسته او پوښتنې'),
            leadingIcon: Icons.quiz_outlined,
            leadingBgColor: Colors.amber[700],
            onTap: () => Navigator.pushNamed(context, '/settings/help-faq'),
          ),
          _buildSettingTile(
            context,
            title: _tr(context, 'Contact Support', 'تماس با پشتیبانی', 'د ملاتړ اړیکه'),
            subtitle: '+93 70 000 0000',
            leadingIcon: Icons.support_agent_rounded,
            leadingBgColor: Colors.lightBlue,
            onTap: () => _contactSupport(context),
          ),
          _buildSettingTile(
            context,
            title: _tr(context, 'About', 'درباره', 'په اړه'),
            subtitle: _tr(context, 'Version 1.0.1', 'نسخه 1.0.1', 'نسخه 1.0.1'),
            leadingIcon: Icons.info_outline_rounded,
            leadingBgColor: Colors.blueGrey,
            onTap: () => _showAbout(context),
          ),
          const SizedBox(height: AppSpacing.l),

          // Account Section
          _buildGroupHeader(context, _tr(context, 'Account', 'حساب', 'حساب'), Icons.account_circle_outlined),
          _buildSettingTile(
            context,
            title: _tr(context, 'Sign Out', 'خروج از حساب', 'له حسابه وتل'),
            titleColor: AppColors.danger,
            leadingIcon: Icons.logout_rounded,
            leadingBgColor: AppColors.danger,
            onTap: () => _signOut(context, ref),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Future<String> _exchangeRateSubtitle(BuildContext context, WidgetRef ref) async {
    final prefCurrency = ref.watch(currencyPreferenceProvider);

    final updatedAt = await ExchangeRateService.instance.getLastUpdatedAt();
    if (updatedAt == null) {
      // Trigger a silent background fetch if rates are missing
      ExchangeRateService.instance.getLatestSnapshot(preferFresh: true).then((_) {
        // Future builder will naturally show old data until next rebuild.
      });
      return _tr(context, '$prefCurrency (rates unavailable)', '$prefCurrency (نرخ ناموجود)', '$prefCurrency (نرخ نشته)');
    }

    final calendarSystem = ref.read(appCalendarSystemProvider);
    final calendarType = calendarSystem == CalendarSystem.persian ? CalendarType.persian : CalendarType.gregorian;
    final formatted = NumberSystemFormatter.apply(
      DateFormatter.formatDateTime(updatedAt, calendar: calendarType, locale: Localizations.localeOf(context).languageCode),
    );
    return _tr(
      context,
      '$prefCurrency • Updated: $formatted',
      '$prefCurrency • بروزرسانی: $formatted',
      '$prefCurrency • تازه شوی: $formatted',
    );
  }

  Widget _buildGroupHeader(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.m, AppSpacing.l, AppSpacing.s),
      child: Row(
        children: [
          Icon(icon, size: 18, color: cs.primary.withOpacity(0.7)),
          const SizedBox(width: AppSpacing.s),
          Text(
            title.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.onSurface.withOpacity(0.5),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    String? subtitle,
    required IconData leadingIcon,
    Widget? trailing,
    Color? titleColor,
    Color? leadingBgColor,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.medium,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.m),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: AppRadius.medium,
            border: Border.all(color: cs.outline.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: leadingBgColor ?? cs.primary,
                  borderRadius: AppRadius.small,
                ),
                child: Icon(leadingIcon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: titleColor ?? cs.onSurface,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(0.5),
                        ),
                      ),
                  ],
                ),
              ),
              trailing ?? Icon(Icons.chevron_right_rounded, color: cs.onSurface.withOpacity(0.2)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showShopProfile(BuildContext context, {required bool isGuest}) async {
    final profile = await ShopProfileService.loadWithCloudFallback();

    final shopName = profile?.shopName.isNotEmpty == true
        ? profile!.shopName
        : (isGuest
            ? _tr(context, 'Demo Shop', 'دکان آزمایشی', 'ازمایښتي دوکان')
            : _tr(context, 'My Shop', 'دکان من', 'زما دوکان'));
    final shopType = profile?.shopType.isNotEmpty == true
        ? profile!.shopType
        : _tr(context, 'General Store', 'دکان عمومی', 'عمومي دوکان');
    final location = profile == null
        ? _tr(context, 'Kabul, Afghanistan', 'کابل، افغانستان', 'کابل، افغانستان')
        : [profile.city, if ((profile.district ?? '').trim().isNotEmpty) profile.district!, 'Afghanistan']
            .join(', ');

    if (!context.mounted) return;

    _showAppBottomSheet(
      context,
      title: _tr(context, 'Shop Profile', 'پروفایل دکان', 'د دوکان پېژندپاڼه'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildInfoRow(context, Icons.store_rounded, _tr(context, 'Shop Name', 'نام دکان', 'د دوکان نوم'), shopName),
          const SizedBox(height: AppSpacing.l),
          _buildInfoRow(context, Icons.category_outlined, _tr(context, 'Business Type', 'نوع دکان', 'د دوکان ډول'), shopType),
          const SizedBox(height: AppSpacing.l),
          _buildInfoRow(context, Icons.location_on_outlined, _tr(context, 'Location', 'موقعیت', 'ځای'), location),
        ],
      ),
    );
  }

  void _showSubscriptionDetails(BuildContext context) {
    _showAppBottomSheet(
      context,
      title: _tr(context, 'Subscription', 'اشتراک', 'ګډون'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _tr(context, 'Your Plan: Demo', 'پلن شما: آزمایشی', 'ستاسو پلان: ازمایښتي'), 
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.l),
          _buildFeatureRow(context, _tr(context, 'Up to 10 products', 'تا 10 محصول', 'تر 10 محصولاتو پورې')),
          _buildFeatureRow(context, _tr(context, 'Up to 5 sales daily', 'تا 5 فروش روزانه', 'تر 5 ورځني پلور پورې')),
          _buildFeatureRow(context, _tr(context, 'Local storage only', 'فقط ذخیره محلی', 'یوازې محلي ساتنه')),
          const SizedBox(height: AppSpacing.xl),
          _buildUpgradeBanner(context),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: _tr(context, 'Upgrade Plan', 'ارتقا پلن', 'پلان ارتقا'),
            isFullWidth: true,
            onPressed: () {
              Navigator.pop(context);
              _showUpgradeDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    _showAppBottomSheet(
      context,
      title: _tr(context, 'Upgrade to Basic', 'ارتقا به پلن پایه', 'بنسټیز پلان ته ارتقا'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: AppRadius.large,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CurrencyDisplay(
                  amount: 400,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  ' / ${_tr(context, 'month', 'ماه', 'میاشت')}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildFeatureRow(context, _tr(context, 'Unlimited Products & Sales', 'محصول و فروش نامحدود', 'نامحدود محصولات او پلور')),
          _buildFeatureRow(context, _tr(context, 'Cloud Data Backup', 'نسخه پشتیبان ابری', 'ورېځیز شاتړ')),
          _buildFeatureRow(context, _tr(context, 'WhatsApp Reminders', 'یادآوری واتساپ', 'د واتساپ یادونې')),
          _buildFeatureRow(context, _tr(context, 'Multi-device Sync', 'همگام‌سازی چند دستگاه', 'د څو وسیلو همغږي')),
          const SizedBox(height: AppSpacing.xl),
          Text(
            _tr(context, 'Contact our team to activate your subscription.', 'برای فعال‌سازی اشتراک با تیم ما تماس بگیرید.', 'د ګډون فعالولو لپاره زموږ له ټیم سره اړیکه ونیسئ.'), 
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.l),
          AppButton(
            text: _tr(context, 'Contact Team via WhatsApp', 'تماس با تیم در واتساپ', 'له ټیم سره په واتساپ اړیکه'),
            icon: Icons.chat_bubble_outline_rounded,
            isFullWidth: true,
            onPressed: () {
              Navigator.pop(context);
              _launchWhatsApp('+93700000000', _tr(context, 'Hi, I want to upgrade my Hesabat plan.', 'سلام، می‌خواهم پلن حسابات را ارتقا بدهم.', 'سلام، زه غواړم د حسابات پلان ارتقا کړم.'));
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageSettings(BuildContext context, WidgetRef ref) {
    final locale = ref.read(appSettingsLocaleProvider);
    _showAppBottomSheet(
      context,
      title: _tr(context, 'Language', 'زبان', 'ژبه'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSelectionTile(
            context,
            'English',
            isSelected: locale.languageCode == 'en',
            onTap: () {
              ref.read(appSettingsLocaleProvider.notifier).setLocale(const Locale('en'));
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
          _buildSelectionTile(
            context,
            'دری (Dari)',
            isSelected: locale.languageCode == 'fa',
            onTap: () {
              ref.read(appSettingsLocaleProvider.notifier).setLocale(const Locale('fa'));
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
          _buildSelectionTile(
            context,
            'پښتو (Pashto)',
            isSelected: locale.languageCode == 'ps',
            onTap: () {
              ref.read(appSettingsLocaleProvider.notifier).setLocale(const Locale('ps'));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showCurrencySettings(BuildContext context, WidgetRef ref) {
    _showAppBottomSheet(
      context,
      title: _tr(context, 'Currency', 'پول', 'اسعار'),
      content: Consumer(
        builder: (context, ref, child) {
          final currentCurrency = ref.watch(currencyPreferenceProvider);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCurrencySelectionTile(context, ref, 'AFN', _tr(context, 'AFN - Afghan Afghani', 'AFN - افغانی', 'AFN - افغانۍ'), currentCurrency == 'AFN'),
              const SizedBox(height: 8),
              _buildCurrencySelectionTile(context, ref, 'USD', _tr(context, 'USD - US Dollar', 'USD - دالر', 'USD - ډالر'), currentCurrency == 'USD'),
              const SizedBox(height: 8),
              _buildCurrencySelectionTile(context, ref, 'PKR', _tr(context, 'PKR - Pakistani Rupee', 'PKR - روپیه', 'PKR - کلدارې'), currentCurrency == 'PKR'),
              const SizedBox(height: 8),
              _buildCurrencySelectionTile(context, ref, 'IRR', _tr(context, 'IR - Iranian Rial', 'IR - ریال ایران', 'IR - ایراني ریال'), currentCurrency == 'IRR'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCurrencySelectionTile(BuildContext context, WidgetRef ref, String code, String label, bool isSelected) {
    return _buildSelectionTile(
      context,
      label,
      isSelected: isSelected,
      onTap: () async {
        await ref.read(currencyPreferenceProvider.notifier).setCurrency(code);
        
        // Try to sync with cloud if possible
        try {
          final supabase = Supabase.instance.client;
          if (supabase.auth.currentUser != null) {
            final profile = await ShopProfileService.load();
            if (profile != null) {
              await ShopProfileService.saveToCloud(supabase, profile);
            }
          }
        } catch (_) {}
        
        if (context.mounted) Navigator.pop(context);
      },
    );
  }

  void _showThemeSettings(BuildContext context, WidgetRef ref) {
    final mode = ref.read(appThemeModeProvider);
    _showAppBottomSheet(
      context,
      title: _tr(context, 'Theme', 'تم', 'بڼه'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSelectionTile(
            context,
            _tr(context, 'System', 'سیستم', 'سیستم'),
            isSelected: mode == ThemeMode.system,
            onTap: () {
              ref.read(appThemeModeProvider.notifier).setThemeMode(ThemeMode.system);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
          _buildSelectionTile(
            context,
            _tr(context, 'Light', 'روشن', 'روښانه'),
            isSelected: mode == ThemeMode.light,
            onTap: () {
              ref.read(appThemeModeProvider.notifier).setThemeMode(ThemeMode.light);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
          _buildSelectionTile(
            context,
            _tr(context, 'Dark', 'تاریک', 'تیاره'),
            isSelected: mode == ThemeMode.dark,
            onTap: () {
              ref.read(appThemeModeProvider.notifier).setThemeMode(ThemeMode.dark);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showNumberSystemSettings(BuildContext context, WidgetRef ref) {
    final selected = ref.read(appNumberSystemProvider);
    _showAppBottomSheet(
      context,
      title: _tr(context, 'Number System', 'سیستم اعداد', 'د شمېرو سیستم'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSelectionTile(
            context,
            _tr(context, 'English digits (0-9)', 'ارقام انگلیسی (0-9)', 'انګلیسي شمېرې (0-9)'),
            isSelected: selected == NumberSystem.english,
            onTap: () {
              ref.read(appNumberSystemProvider.notifier).setNumberSystem(NumberSystem.english);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
          _buildSelectionTile(
            context,
            _tr(context, 'Farsi digits (۰-۹)', 'ارقام فارسی (۰-۹)', 'فارسي شمېرې (۰-۹)'),
            isSelected: selected == NumberSystem.farsi,
            onTap: () {
              ref.read(appNumberSystemProvider.notifier).setNumberSystem(NumberSystem.farsi);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showCalendarSettings(BuildContext context, WidgetRef ref) {
    final selected = ref.read(appCalendarSystemProvider);
    _showAppBottomSheet(
      context,
      title: _tr(context, 'Calendar System', 'سیستم تقویم', 'د کلیز سیستم'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSelectionTile(
            context,
            _tr(context, 'Gregorian Calendar', 'تقویم میلادی', 'میلادی کلیز'),
            isSelected: selected == CalendarSystem.gregorian,
            onTap: () {
              ref.read(appCalendarSystemProvider.notifier).setCalendarSystem(CalendarSystem.gregorian);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
          _buildSelectionTile(
            context,
            _tr(context, 'Persian Calendar (Solar Hijri)', 'تقویم شمسی (هجری خورشیدی)', 'شمسی کلیز (هجري لمریز)'),
            isSelected: selected == CalendarSystem.persian,
            onTap: () {
              ref.read(appCalendarSystemProvider.notifier).setCalendarSystem(CalendarSystem.persian);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }


  void _contactSupport(BuildContext context) {
    _showAppBottomSheet(
      context,
      title: _tr(context, 'Customer Support', 'پشتیبانی مشتری', 'د پېرودونکو ملاتړ'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildInfoRow(context, Icons.support_agent_rounded, 'WhatsApp', '+93 70 000 0000'),
          const SizedBox(height: AppSpacing.l),
          _buildInfoRow(context, Icons.email_outlined, 'Email', 'support@hesabat.app'),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: _tr(context, 'Start Chat on WhatsApp', 'شروع گفتگو در واتساپ', 'په واتساپ چټ پيل کړئ'),
            icon: Icons.chat_outlined,
            isFullWidth: true,
            onPressed: () {
              Navigator.pop(context);
              _launchWhatsApp('+93700000000', _tr(context, 'Hi, I need assistance with Hesabat.', 'سلام، برای حسابات کمک می‌خواهم.', 'سلام، زه د حسابات لپاره مرستې ته اړتیا لرم.'));
            },
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    _showAppBottomSheet(
      context,
      title: _tr(context, 'About', 'درباره', 'په اړه'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Text(
              'ح',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: AppSpacing.l),
          Text(
            'Hesabat - The Smart Shop',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            _tr(context, 'The first offline-first business management app built specifically for Afghan shopkeepers.', 'اولین اپ مدیریت کسب‌وکار آفلاین‌اول برای دکانداران افغانستان.', 'د افغان دوکاندارانو لپاره لومړنی افلاین-اول کاروباري مدیریت اپ.'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _tr(context, 'Version 1.0.1', 'نسخه 1.0.1', 'نسخه 1.0.1'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _signOut(BuildContext context, WidgetRef ref) {
    _showAppBottomSheet(
      context,
      title: _tr(context, 'Sign Out', 'خروج از حساب', 'له حسابه وتل'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _tr(context, 'Are you sure you want to exit your account?', 'آیا مطمئن هستید که از حساب خارج شوید؟', 'ایا تاسو ډاډه یاست چې له حسابه ووځئ؟'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(_tr(context, 'Cancel', 'لغو', 'لغوه')),
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: AppButton(
                  text: _tr(context, 'Sign Out', 'خروج', 'وتل'),
                  onPressed: () async {
                    Navigator.pop(context);
                    await ref.read(authStateNotifierProvider.notifier).signOutAtomic();
                    await ShopProfileService.clear();
                    await ShopProfileService.clearOnboardingFlag();
                    if (context.mounted) {
                      context.go('/auth');
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  void _showAppBottomSheet(
    BuildContext context, {
    required String title,
    required Widget content,
    List<Widget>? actions,
    bool scrollable = true,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: cs.onSurface.withOpacity(0.05),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            // Content
            if (scrollable)
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
                  child: content,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
                child: content,
              ),
            // Actions
            if (actions != null)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions.map((a) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: a,
                  )).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAppDialog(BuildContext context, {required String title, required Widget content, List<Widget>? actions}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: content,
        actions: actions ?? [TextButton(onPressed: () => Navigator.pop(context), child: Text(_tr(context, 'Back', 'بازگشت', 'بېرته')))],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
        const SizedBox(width: AppSpacing.m),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureRow(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppSpacing.s),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildUpgradeBanner(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.05),
        borderRadius: AppRadius.medium,
        border: Border.all(color: cs.primary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.bolt_rounded, color: cs.primary),
          const SizedBox(width: AppSpacing.m),
          Expanded(child: Text(_tr(context, 'Get unlimited features today!', 'همین امروز ویژگی‌های نامحدود بگیرید!', 'نن نامحدود ځانګړتیاوې ترلاسه کړئ!'))),
        ],
      ),
    );
  }

  Widget _buildSelectionTile(BuildContext context, String title, {bool isSelected = false, VoidCallback? onTap}) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.medium,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary.withOpacity(0.08) : cs.surface,
          borderRadius: AppRadius.medium,
          border: Border.all(
            color: isSelected ? cs.primary.withOpacity(0.2) : cs.outline.withOpacity(0.05),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? cs.primary : cs.onSurface,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: cs.primary, size: 22)
            else
              Icon(Icons.circle_outlined, color: cs.onSurface.withOpacity(0.1), size: 22),
          ],
        ),
      ),
    );
  }


  void _launchWhatsApp(String phone, String message) async {
    final encoded = Uri.encodeComponent(message);
    final uri = Uri.parse('https://wa.me/$phone?text=$encoded');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
