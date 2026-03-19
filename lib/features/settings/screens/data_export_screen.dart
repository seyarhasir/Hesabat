import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/settings/shop_profile_service.dart';
import '../../../core/utils/data_export_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_layout.dart';
import '../../../shared/widgets/app_button.dart';

class DataExportScreen extends ConsumerStatefulWidget {
  const DataExportScreen({super.key});

  @override
  ConsumerState<DataExportScreen> createState() => _DataExportScreenState();
}

class _DataExportScreenState extends ConsumerState<DataExportScreen> {
  bool _isExportingCsv = false;
  bool _isExportingPdf = false;

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);

  Future<void> _exportCsv() async {
    setState(() => _isExportingCsv = true);
    try {
      final db = ref.read(databaseProvider);
      final shopId = ref.read(currentShopIdProvider);
      
      final products = await db.productsDao.getAllProducts(shopId);
      final customers = await db.customersDao.getCustomersByShopId(shopId);
      final sales = await db.salesDao.getSalesByShopId(shopId);
      final saleItems = await db.salesDao.getSaleItemsByShopId(shopId);
      final debts = await db.debtsDao.getDebtsByShopId(shopId);
      final debtPayments = await db.debtsDao.getDebtPaymentsByShopId(shopId);
      
      final profile = await ShopProfileService.loadWithCloudFallback();
      final shopName = profile?.shopName ?? 'Hesabat';

      await DataExportService.exportAllDataToSingleCsv(
        shopName: shopName,
        products: products,
        customers: customers,
        sales: sales,
        saleItems: saleItems,
        debts: debts,
        debtPayments: debtPayments,
        lang: _lang,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_tr('Export failed', 'خطا در استخراج', 'استخراج کې خطا'))));
      }
    } finally {
      if (mounted) setState(() => _isExportingCsv = false);
    }
  }

  Future<void> _exportPdf() async {
    setState(() => _isExportingPdf = true);
    try {
      final db = ref.read(databaseProvider);
      final shopId = ref.read(currentShopIdProvider);
      
      final products = await db.productsDao.getAllProducts(shopId);
      final customers = await db.customersDao.getCustomersByShopId(shopId);
      final sales = await db.salesDao.getSalesByShopId(shopId);
      final saleItems = await db.salesDao.getSaleItemsByShopId(shopId);
      final debts = await db.debtsDao.getDebtsByShopId(shopId);
      final debtPayments = await db.debtsDao.getDebtPaymentsByShopId(shopId);
      
      await DataExportService.exportToPdf(
        products: products,
        customers: customers,
        sales: sales,
        saleItems: saleItems,
        debts: debts,
        debtPayments: debtPayments,
        lang: _lang,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_tr('PDF Export failed', 'خطا در استخراج PDF', 'پی ډی ایف استخراج کې خطا'))));
      }
    } finally {
      if (mounted) setState(() => _isExportingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('Data Export', 'استخراج داده‌ها', 'د معلوماتو استخراج')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.05),
              borderRadius: AppRadius.large,
              border: Border.all(color: cs.primary.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Icon(Icons.backup_rounded, size: 48, color: cs.primary),
                const SizedBox(height: AppSpacing.m),
                Text(
                  _tr('Backup & Export', 'پشتیبان‌گیری و استخراج', 'بک اپ او استخراج'),
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  _tr(
                    'Export your business data to use in Excel or keep as a printed record.',
                    'داده‌های کسب‌وکار خود را برای استفاده در اکسل یا نگهداری به صورت چاپی استخراج کنید.',
                    'خپل کاروباري معلومات د اکسل لپاره یا د چاپ په بڼه د ساتلو لپاره استخراج کړئ.'
                  ),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(0.7)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          _exportCard(
            context,
            title: _tr('Full Business Export (CSV)', 'استخراج کامل کسب‌وکار (CSV)', 'د ټول کاروبار استخراج (CSV)'),
            subtitle: _tr('Every detail in one file for Excel.', 'تمام جزئیات در یک فایل برای اکسل.', 'ټول جزیات د اکسل لپاره په یوه فایل کې.'),
            icon: Icons.table_chart_rounded,
            color: Colors.teal,
            isLoading: _isExportingCsv,
            onTap: _isExportingCsv || _isExportingPdf ? null : _exportCsv,
          ),
          const SizedBox(height: AppSpacing.l),
          _exportCard(
            context,
            title: _tr('Export as PDF (Print)', 'استخراج به صورت PDF (چاپ)', 'د پی ډی ایف په بڼه استخراج (چاپ)'),
            subtitle: _tr('Professional layout for offline records.', 'ظاهر حرفه‌ای برای سوابق آفلاین.', 'د افلاین ریکارډونو لپاره مسلکي بڼه.'),
            icon: Icons.picture_as_pdf_rounded,
            color: Colors.redAccent,
            isLoading: _isExportingPdf,
            onTap: _isExportingCsv || _isExportingPdf ? null : _exportPdf,
          ),
          
          const SizedBox(height: AppSpacing.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.security_rounded, size: 16, color: cs.onSurface.withOpacity(0.4)),
              const SizedBox(width: 8),
              Text(
                _tr('Your data stays secure and private.', 'داده‌های شما امن و خصوصی می‌ماند.', 'ستاسو معلومات خوندي او پټ پاتې کیږي.'),
                style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.4)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _exportCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isLoading,
    required VoidCallback? onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.large,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: AppRadius.large,
          border: Border.all(color: cs.outline.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: AppRadius.medium,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: AppSpacing.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.6))),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            else
              Icon(Icons.chevron_right_rounded, color: cs.onSurface.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }
}
