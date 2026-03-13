import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/guest_mode_service.dart';
import '../../../core/sync/sync_provider.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_layout.dart';
import '../../../shared/widgets/app_stat_card.dart';
import '../../../shared/widgets/demo_banner.dart';
import '../../../shared/widgets/sync_status_bar.dart';
import '../../sales/screens/sale_screen.dart';
import '../../qarz/screens/qarz_dashboard_screen.dart';
import '../../reports/screens/daily_summary_screen.dart';
import '../../more/screens/more_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentTab = 0;
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);
  String _na(String s) => NumberSystemFormatter.apply(s);

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final isEn = lang == 'en';
    final isPs = lang == 'ps';
    String t(String en, String fa, String ps) => isEn ? en : (isPs ? ps : fa);
    final authState = ref.watch(authProvider);
    final syncState = ref.watch(syncProvider);
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t('Hesabat', 'حسابات', 'حسابات')),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          const DemoBanner(),
          Expanded(
            child: _getPage(_currentTab, syncState),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (i) => setState(() => _currentTab = i),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_rounded), label: t('Home', 'خانه', 'کور')),
          NavigationDestination(icon: const Icon(Icons.paid_rounded), label: t('Sales', 'فروش', 'پلور')),
          NavigationDestination(icon: const Icon(Icons.people_alt_rounded), label: t('Qarz', 'قرض', 'قرض')),
          NavigationDestination(icon: const Icon(Icons.menu_rounded), label: t('More', 'بیشتر', 'نور')),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, dynamic authState, ColorScheme cs, ThemeData theme, SyncState syncState) {
    final lang = Localizations.localeOf(context).languageCode;
    final isEn = lang == 'en';
    final isPs = lang == 'ps';
    String t(String en, String fa, String ps) => isEn ? en : (isPs ? ps : fa);
    const todaySales = 85000;
    const todayCash = 65000;
    const todayCredit = 20000;
    const totalQarz = 145000;
    const lowStockItems = 7;
    const recentCashSale = 12000;
    const recentQarz = 8500;
    const recentPayment = 5000;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(authState, theme),
          const SizedBox(height: AppSpacing.sectionGap),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: AppRadius.large,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('Today\'s Sales', 'فروش امروز', 'د نن پلور'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  '${_nf(todaySales)} ؋',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  t('Cash: ${_nf(todayCash)}  Credit: ${_nf(todayCredit)}', 'نقد: ${_nf(todayCash)}  قرض: ${_nf(todayCredit)}', 'نغد: ${_nf(todayCash)}  قرض: ${_nf(todayCredit)}'),
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.9)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          Row(
            children: [
              Expanded(
                child: AppStatCard(
                  title: t('💰 Qarz', '💰 قرض', '💰 قرض'),
                  value: '${_nf(totalQarz)} ؋',
                  subtitle: t('Total debt', 'کل بدهی', 'ټول پور'),
                  icon: Icons.people_alt_rounded,
                  color: AppColors.warning,
                  onTap: () => setState(() => _currentTab = 2),
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: AppStatCard(
                  title: t('📦 Low stock', '📦 کم‌موجود', '📦 کم ذخیره'),
                  value: t('${_nf(lowStockItems)} items', '${_nf(lowStockItems)} کالا', '${_nf(lowStockItems)} توکي'),
                  subtitle: t('Running low', 'کم‌موجود', 'کم شوی'),
                  icon: Icons.inventory_2_rounded,
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGap),

          Text(
            t('Quick actions', 'میانبرهای سریع', 'چټک کارونه'),
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.m),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => setState(() => _currentTab = 1),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(t('New sale', 'فروش جدید', 'نوی پلور')),
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _currentTab = 2),
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  label: Text(t('New qarz', 'قرض جدید', 'نوی قرض')),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/reports/daily-summary'),
                  icon: const Icon(Icons.today_rounded),
                  label: Text(t('Daily summary', 'خلاصه روزانه', 'ورځنی لنډیز')),
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/reports'),
                  icon: const Icon(Icons.analytics_rounded),
                  label: Text(t('Reports', 'گزارش‌ها', 'راپورونه')),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Text(
            t('Recent activity', 'فعالیت اخیر', 'وروستي فعالیت'),
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.payments_rounded, color: AppColors.success),
                  title: Text(t('Cash sale ${_nf(recentCashSale)} ؋', 'فروش نقد ${_nf(recentCashSale)} ؋', 'نغدي پلور ${_nf(recentCashSale)} ؋')),
                  subtitle: Text(t('${_nf(10)} minutes ago', '${_nf(10)} دقیقه پیش', '${_nf(10)} دقیقې مخکې')),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.people_alt_rounded, color: AppColors.warning),
                  title: Text(t('Qarz to Mohammad ${_nf(recentQarz)} ؋', 'قرض محمد ${_nf(recentQarz)} ؋', 'محمد ته قرض ${_nf(recentQarz)} ؋')),
                  subtitle: Text(t('${_nf(35)} minutes ago', '${_nf(35)} دقیقه پیش', '${_nf(35)} دقیقې مخکې')),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.favorite_rounded, color: AppColors.success),
                  title: Text(t('Debt payment ${_nf(recentPayment)} ؋', 'پرداخت قرض ${_nf(recentPayment)} ؋', 'د قرض تادیه ${_nf(recentPayment)} ؋')),
                  subtitle: Text(t('${_nf(2)} hours ago', '${_nf(2)} ساعت پیش', '${_nf(2)} ساعته مخکې')),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Align(
            alignment: Alignment.centerLeft,
            child: SyncStatusBar(
              status: _mapSyncStatus(syncState.status),
              pendingCount: syncState.pendingCount,
              onTap: () {
                if (syncState.status == SyncUiStatus.conflict) {
                  Navigator.pushNamed(context, '/sync/conflicts');
                  return;
                }
                ref.read(syncProvider.notifier).syncNow(force: true);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(dynamic authState, ThemeData theme) {
    final lang = Localizations.localeOf(context).languageCode;
    final isEn = lang == 'en';
    final isPs = lang == 'ps';
    String t(String en, String fa, String ps) => isEn ? en : (isPs ? ps : fa);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          authState.isGuest
              ? t('Hello! 👋', 'سلام! 👋', 'سلام! 👋')
              : t('Hello, Ahmad Khan! 👋', 'سلام، احمد خان! 👋', 'سلام، احمد خان! 👋'),
          style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          authState.isGuest
              ? t('Welcome to Hesabat', 'خوش آمدید به حسابات', 'حسابات ته ښه راغلاست')
              : t('Shop: Ahmad Supermarket', 'دکان: سوپرمارکت احمد', 'دوکان: احمد سوپرمارکېټ'),
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
        ),
      ],
    );
  }

  Widget _getPage(int index, SyncState syncState) {
    final authState = ref.watch(authProvider);
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    switch (index) {
      case 0:
        return _buildDashboard(context, authState, cs, theme, syncState);
      case 1:
        return const SaleScreen();
      case 2:
        return const QarzDashboardScreen();
      case 3:
        return const MoreScreen();
      default:
        return _buildDashboard(context, authState, cs, theme, syncState);
    }
  }

  SyncStatus _mapSyncStatus(SyncUiStatus status) {
    switch (status) {
      case SyncUiStatus.syncing:
        return SyncStatus.syncing;
      case SyncUiStatus.offline:
        return SyncStatus.offline;
      case SyncUiStatus.error:
        return SyncStatus.error;
      case SyncUiStatus.conflict:
        return SyncStatus.conflict;
      case SyncUiStatus.idle:
        return SyncStatus.online;
    }
  }

  void _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(authProvider.notifier).signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    }
  }
}
