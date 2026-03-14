import 'package:flutter/material.dart';
import '../../../shared/theme/app_layout.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  String _tr(String lang, String en, String fa, [String? ps]) => lang == 'fa' ? fa : (lang == 'ps' ? (ps ?? fa) : en);

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    Widget navCard({
      required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
    }) {
      return InkWell(
        onTap: onTap,
        borderRadius: AppRadius.medium,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: AppRadius.medium,
            border: Border.all(color: cs.outline.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.1),
                  borderRadius: AppRadius.small,
                ),
                child: Icon(icon, color: cs.primary),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.55))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      );
    }

    Widget sectionTitle(String text) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s),
        child: Text(
          text,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSurface.withOpacity(0.7),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_tr(lang, 'More', 'بیشتر', 'نور'))),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.l),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: AppRadius.large,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _tr(lang, 'Tools & Management', 'ابزارها و مدیریت', 'وسایل او مدیریت'),
                  style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _tr(lang, 'Everything beyond daily sales', 'همه چیز فراتر از فروش روزانه', 'د ورځني پلور هاخوا هر څه'),
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.9)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.l),
          sectionTitle(_tr(lang, 'People', 'افراد', 'خلک')),
          navCard(
            icon: Icons.people_alt_rounded,
            title: _tr(lang, 'Customers', 'مشتریان', 'پېرودونکي'),
            subtitle: _tr(lang, 'All customers, profiles, and history', 'همه مشتریان، پروفایل و تاریخچه', 'ټول پېرودونکي، پروفایل او تاریخچه'),
            onTap: () => Navigator.pushNamed(context, '/customers'),
          ),
          const SizedBox(height: AppSpacing.l),
          sectionTitle(_tr(lang, 'Operations', 'عملیات', 'عملیات')),
          navCard(
            icon: Icons.inventory_2_rounded,
            title: _tr(lang, 'Inventory', 'موجودی', 'ذخیره'),
            subtitle: _tr(lang, 'Products, stock, and counting', 'محصولات، موجودی و شمارش', 'محصولات، زېرمه او شمېرنه'),
            onTap: () => Navigator.pushNamed(context, '/inventory'),
          ),
          const SizedBox(height: AppSpacing.s),
          navCard(
            icon: Icons.assessment_rounded,
            title: _tr(lang, 'Reports', 'گزارش‌ها', 'راپورونه'),
            subtitle: _tr(lang, 'Sales, qarz, inventory, profit', 'فروش، قرض، موجودی، سود', 'پلور، قرض، زېرمه، ګټه'),
            onTap: () => Navigator.pushNamed(context, '/reports'),
          ),
          const SizedBox(height: AppSpacing.l),
          sectionTitle(_tr(lang, 'App', 'اپلیکیشن', 'اپلیکیشن')),
          navCard(
            icon: Icons.settings_rounded,
            title: _tr(lang, 'Settings', 'تنظیمات', 'امستنې'),
            subtitle: _tr(lang, 'Language, digits, theme, calendar', 'زبان، ارقام، تم، تقویم', 'ژبه، شمېرې، بڼه، کلیز'),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          const SizedBox(height: AppSpacing.s),
          navCard(
            icon: Icons.workspace_premium_rounded,
            title: _tr(lang, 'Subscription', 'اشتراک', 'ګډون'),
            subtitle: _tr(lang, 'Plan and upgrade options', 'پلن و گزینه‌های ارتقا', 'پلان او د ارتقا اختیارونه'),
            onTap: () => Navigator.pushNamed(context, '/subscription'),
          ),
        ],
      ),
    );
  }
}
