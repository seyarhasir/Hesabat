import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/sync/sync_provider.dart';
import '../../../core/settings/shop_profile_service.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_layout.dart';
import '../../../shared/widgets/app_stat_card.dart';
import '../../../shared/widgets/sync_status_bar.dart';
import '../../sales/providers/pending_scanned_barcode_result_provider.dart';
import '../../sales/screens/sale_screen.dart';
import '../../qarz/screens/qarz_dashboard_screen.dart';
import '../../more/screens/more_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentTab = 0;
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final isEn = lang == 'en';
    final isPs = lang == 'ps';
    String t(String en, String fa, String ps) => isEn ? en : (isPs ? ps : fa);
    final syncState = ref.watch(syncProvider);

    return Scaffold(
      appBar: _currentTab == 0
          ? AppBar(
              title: FutureBuilder<ShopProfile?>(
                future: ShopProfileService.loadWithCloudFallback(),
                builder: (context, snapshot) {
                  final name = snapshot.data?.shopName;
                  return Text(
                    (name != null && name.isNotEmpty) ? name : t('Hesabat', 'حسابات', 'حسابات'),
                  );
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                  tooltip: t('Settings', 'تنظیمات', 'امستنې'),
                ),
              ],
            )
          : null,
      body: _getPage(_currentTab, syncState),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 58,
        height: 58,
        child: Material(
          color: Theme.of(context).colorScheme.primary,
          elevation: 8,
          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.45),
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: _openGlobalBarcodeScanner,
            child: const Center(
              child: Icon(Icons.qr_code_scanner_rounded, size: 30, color: Colors.white),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(10, 0, 10, 8),
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.14)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _navItem(
                  label: t('Home', 'خانه', 'کور'),
                  icon: Icons.home_rounded,
                  active: _currentTab == 0,
                  onTap: () => setState(() => _currentTab = 0),
                ),
              ),
              Expanded(
                child: _navItem(
                  label: t('Sales', 'فروش', 'پلور'),
                  icon: Icons.paid_rounded,
                  active: _currentTab == 1,
                  onTap: () => setState(() => _currentTab = 1),
                ),
              ),
              const SizedBox(width: 58),
              Expanded(
                child: _navItem(
                  label: t('Qarz', 'قرض', 'قرض'),
                  icon: Icons.handshake_rounded,
                  active: _currentTab == 2,
                  onTap: () => setState(() => _currentTab = 2),
                ),
              ),
              Expanded(
                child: _navItem(
                  label: t('More', 'بیشتر', 'نور'),
                  icon: Icons.menu_rounded,
                  active: _currentTab == 3,
                  onTap: () => setState(() => _currentTab = 3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required String label,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    final color = active ? cs.primary : cs.onSurface.withOpacity(0.6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: active ? cs.primary.withOpacity(0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: active ? 23 : 21),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, dynamic authState, ColorScheme cs, ThemeData theme, SyncState syncState) {
    final lang = Localizations.localeOf(context).languageCode;
    final isEn = lang == 'en';
    final isPs = lang == 'ps';
    String t(String en, String fa, String ps) => isEn ? en : (isPs ? ps : fa);
    final db = ref.watch(databaseProvider);
    final shopId = ref.watch(currentShopIdProvider);

    return FutureBuilder<ShopProfile?>(
      future: ShopProfileService.loadWithCloudFallback(),
      builder: (context, profileSnapshot) {
        final profile = profileSnapshot.data;
        final isSubscriptionActive = profile?.isSubscriptionActive ?? true;

        return StreamBuilder<List<Sale>>(
          stream: db.salesDao.watchSalesByShopId(shopId),
          builder: (context, salesSnapshot) {
            final now = DateTime.now();
            final sales = salesSnapshot.data ?? const <Sale>[];
            final todaysSales = sales.where((s) =>
                s.createdAt.year == now.year && s.createdAt.month == now.month && s.createdAt.day == now.day);

            final todaySales = todaysSales.fold<double>(0, (sum, s) => sum + s.totalAfn);
            final todayCash = todaysSales
                .where((s) => !(s.isCredit || s.paymentMethod == 'credit'))
                .fold<double>(0, (sum, s) => sum + s.totalAfn);
            final todayCredit = todaysSales
                .where((s) => s.isCredit || s.paymentMethod == 'credit')
                .fold<double>(0, (sum, s) => sum + s.totalAfn);

            return StreamBuilder<List<Debt>>(
              stream: db.debtsDao.watchDebtsByShopId(shopId),
              builder: (context, debtSnapshot) {
                final openDebts = (debtSnapshot.data ?? const <Debt>[]).where((d) => d.status != 'paid');
                final totalQarz = openDebts.fold<double>(0, (sum, d) => sum + d.amountRemaining);

                return FutureBuilder<int>(
                  future: db.productsDao.countLowStock(shopId),
                  builder: (context, lowStockSnapshot) {
                    final lowStockItems = lowStockSnapshot.data ?? 0;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.m, AppSpacing.screenPadding, AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isSubscriptionActive) _buildExpiredBanner(context, t),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.l),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [cs.primary, cs.primary.withOpacity(0.78)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: AppRadius.large,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t('Today\'s Sales', 'فروش امروز', 'د نن پلور'),
                                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: AppSpacing.s),
                                Text(
                                  '${_nf(todaySales)} ؋',
                                  style: theme.textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: AppSpacing.s),
                                Wrap(
                                  spacing: AppSpacing.s,
                                  children: [
                                    _homeChip('💵 ${t('Cash', 'نقد', 'نغد')} ${_nf(todayCash)}'),
                                    _homeChip('🤝 ${t('Qarz', 'قرض', 'قرض')} ${_nf(todayCredit)}'),
                                  ],
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
                                  icon: Icons.handshake_rounded,
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
                          Text(t('Quick actions', 'میانبرهای سریع', 'چټک کارونه'),
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: AppSpacing.m),
                          GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 1.35,
                            mainAxisSpacing: AppSpacing.m,
                            crossAxisSpacing: AppSpacing.m,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _quickActionCard(
                                context,
                                icon: Icons.shopping_cart_checkout_rounded,
                                label: t('New sale', 'فروش جدید', 'نوی پلور'),
                                onTap: isSubscriptionActive
                                    ? () => setState(() => _currentTab = 1)
                                    : () => _showSubscriptionRequired(context, t),
                                filled: true,
                                disabled: !isSubscriptionActive,
                              ),
                              _quickActionCard(
                                context,
                                icon: Icons.handshake_rounded,
                                label: t('New qarz', 'قرض جدید', 'نوی قرض'),
                                onTap: isSubscriptionActive
                                    ? () => Navigator.pushNamed(context, '/qarz/add-debt')
                                    : () => _showSubscriptionRequired(context, t),
                                amber: true,
                                disabled: !isSubscriptionActive,
                              ),
                              _quickActionCard(
                                context,
                                icon: Icons.today_rounded,
                                label: t('Daily summary', 'خلاصه روزانه', 'ورځنی لنډیز'),
                                onTap: () => Navigator.pushNamed(context, '/reports/daily-summary'),
                              ),
                              _quickActionCard(
                                context,
                                icon: Icons.analytics_rounded,
                                label: t('Reports', 'گزارش‌ها', 'راپورونه'),
                                onTap: () => Navigator.pushNamed(context, '/reports'),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sectionGap),
                          Text(t('Recent activity', 'فعالیت اخیر', 'وروستي فعالیت'),
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: AppSpacing.s),
                          _buildRecentSalesPreview(theme, t),
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
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _homeChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }

  Widget _buildExpiredBanner(BuildContext context, String Function(String, String, String) t) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.danger.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.danger),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('Subscription Expired', 'اشتراک تمام شده', 'ګډون پای ته رسیدلی'),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.danger),
                ),
                Text(
                  t('App is in View-Only mode.', 'اپلیکیشن در حالت نمایشی است.', 'اپلیکیشن یوازې د لیدلو په حالت کې دی.'),
                  style: TextStyle(fontSize: 12, color: AppColors.danger.withOpacity(0.8)),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/subscription'),
            child: Text(t('Renew', 'تمدید', 'تمدید')),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionRequired(BuildContext context, String Function(String, String, String) t) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t('Subscription Required', 'اشتراک لازم است', 'ګډون ته اړتیا ده')),
        content: Text(t(
          'Your subscription has expired. Please renew to add new sales or customers.',
          'اشتراک شما تمام شده است. لطفاً برای ثبت فروش یا مشتری جدید آن را تمدید کنید.',
          'ستاسو ګډون پای ته رسیدلی. مهرباني وکړئ د نوي پلور یا پېرودونکو اضافه کولو لپاره تمدید کړئ.'
        )),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(t('Later', 'بعداً', 'وروسته'))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/subscription');
            },
            child: Text(t('Renew Now', 'تمدید حالا', 'اوس تمدید کړئ')),
          ),
        ],
      ),
    );
  }

  Widget _quickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool filled = false,
    bool amber = false,
    bool disabled = false,
  }) {
    final cs = Theme.of(context).colorScheme;
    final bg = disabled
        ? cs.surfaceVariant.withOpacity(0.1)
        : (filled
            ? cs.primary
            : amber
                ? AppColors.warning.withOpacity(0.18)
                : cs.surface);
    final fg = disabled
        ? cs.onSurface.withOpacity(0.3)
        : (filled
            ? Colors.white
            : amber
                ? AppColors.warning
                : cs.onSurface);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.large,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.large,
          border: Border.all(color: filled ? cs.primary : cs.outline.withOpacity(0.18)),
        ),
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: fg, size: 28),
            const SizedBox(height: AppSpacing.s),
            Text(label, textAlign: TextAlign.center, style: TextStyle(color: fg, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSalesPreview(ThemeData theme, String Function(String, String, String) t) {
    final db = ref.watch(databaseProvider);
    final shopId = ref.watch(currentShopIdProvider);

    return StreamBuilder<List<Sale>>(
      stream: db.salesDao.watchSalesByShopId(shopId),
      builder: (context, snapshot) {
        final sales = [...(snapshot.data ?? const <Sale>[])];
        sales.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final recent = sales.take(3).toList();

        if (recent.isEmpty) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long_rounded),
              title: Text(t('No recent sales', 'فروش اخیر وجود ندارد', 'وروستي پلور نشته')),
              subtitle: Text(t('Start a new sale to see activity', 'برای دیدن فعالیت، فروش جدید ثبت کنید', 'د فعالیت لپاره نوی پلور ثبت کړئ')),
              trailing: TextButton(
                onPressed: () => setState(() => _currentTab = 1),
                child: Text(t('New sale', 'فروش جدید', 'نوی پلور')),
              ),
            ),
          );
        }

        return Card(
          child: Column(
            children: [
              ...recent.asMap().entries.map((entry) {
                final i = entry.key;
                final sale = entry.value;
                final isCredit = sale.isCredit || sale.paymentMethod == 'credit';
                final color = isCredit ? AppColors.warning : AppColors.success;
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(isCredit ? Icons.credit_card_rounded : Icons.payments_rounded, color: color),
                      title: Text('${_nf(sale.totalAfn)} ؋'),
                      subtitle: Text('${_paymentMethodText(sale.paymentMethod, t)} • ${_timeAgoText(sale.createdAt, t)}'),
                    ),
                    if (i < recent.length - 1) const Divider(height: 1),
                  ],
                );
              }),
              const Divider(height: 1),
              ListTile(
                title: Text(t('View all sales', 'نمایش همه فروش‌ها', 'ټول پلورونه وګورئ')),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => setState(() => _currentTab = 1),
              ),
            ],
          ),
        );
      },
    );
  }

  String _paymentMethodText(String method, String Function(String, String, String) t) {
    switch (method) {
      case 'credit':
        return t('Credit', 'قرضی', 'قرض');
      case 'mixed':
        return t('Split', 'ترکیبی', 'ګډ');
      default:
        return t('Cash', 'نقدی', 'نغدي');
    }
  }

  String _timeAgoText(DateTime time, String Function(String, String, String) t) {
    final mins = DateTime.now().difference(time).inMinutes;
    if (mins < 60) {
      return t('${_nf(mins)} min ago', '${_nf(mins)} دقیقه پیش', '${_nf(mins)} دقیقې مخکې');
    }
    final hrs = (mins / 60).floor();
    if (hrs < 24) {
      return t('${_nf(hrs)} hr ago', '${_nf(hrs)} ساعت پیش', '${_nf(hrs)} ساعت مخکې');
    }
    final days = (hrs / 24).floor();
    return t('${_nf(days)} day ago', '${_nf(days)} روز پیش', '${_nf(days)} ورځ مخکې');
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

  Future<void> _openGlobalBarcodeScanner() async {
    final result = await Navigator.pushNamed(context, '/sales/barcode');
    if (!mounted || result == null || result is! Map) return;

    final map = Map<String, dynamic>.from(result.cast());
    final productId = map['productId']?.toString();
    final barcode = map['barcode']?.toString();
    final notFound = map['notFound'] == true;

    if (productId != null && productId.isNotEmpty) {
      ref.read(pendingScannedBarcodeResultProvider.notifier).state = map;
      setState(() => _currentTab = 1);
      return;
    }

    if (notFound && barcode != null && barcode.isNotEmpty) {
      final created = await Navigator.pushNamed(
        context,
        '/inventory/add-product',
        arguments: {'barcode': barcode},
      );

      if (!mounted) return;
      if (created == true) {
        final db = ref.read(databaseProvider);
        final shopId = ref.read(currentShopIdProvider);
        final added = await db.productsDao.getProductByBarcode(shopId, barcode);
        if (added != null) {
          ref.read(pendingScannedBarcodeResultProvider.notifier).state = {
            'productId': added.id,
            'barcode': barcode,
          };
        }
        setState(() => _currentTab = 1);
      }
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

}
