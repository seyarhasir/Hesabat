import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/auth/guest_mode_service.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../shared/theme/app_layout.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/app_empty_state.dart';
import 'add_edit_product_screen.dart';

/// Product List Screen - Browse and search all products
class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showLowStockOnly = false;

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);
  String _na(String s) => NumberSystemFormatter.apply(s);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final guestMode = ref.watch(guestModeServiceProvider);
    final db = ref.watch(databaseProvider);
    final shopId = ref.watch(currentShopIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tr('Inventory', 'موجودی', 'زېرمه'),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline_rounded, color: cs.primary),
            onPressed: () => _addProduct(guestMode),
          ),
          const SizedBox(width: AppSpacing.s),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: _tr('Search products...', 'جستجوی محصول...', 'محصولات ولټوئ...'),
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.medium,
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            child: Row(
              children: [
                FilterChip(
                  label: Text(_tr('All', 'همه', 'ټول')),
                  selected: !_showLowStockOnly,
                  onSelected: (_) => setState(() => _showLowStockOnly = false),
                  selectedColor: cs.primary.withOpacity(0.1),
                  checkmarkColor: cs.primary,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
                ),
                const SizedBox(width: AppSpacing.s),
                FilterChip(
                  label: Text(_tr('Low Stock', 'کم‌موجود', 'کمه زېرمه')),
                  selected: _showLowStockOnly,
                  onSelected: (_) => setState(() => _showLowStockOnly = true),
                  selectedColor: AppColors.danger.withOpacity(0.1),
                  checkmarkColor: AppColors.danger,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.m),

          // Product count header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _tr('Your Inventory', 'موجودی شما', 'ستاسو زېرمه'),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface.withOpacity(0.8),
                  ),
                ),
                if (guestMode.isGuest)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: 2),
                    decoration: BoxDecoration(
                      color: (guestMode.hasReachedProductLimit ? AppColors.danger : cs.primary).withOpacity(0.1),
                      borderRadius: AppRadius.small,
                    ),
                    child: Text(
                      _na('${guestMode.productCount}/${guestMode.maxProducts}'),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: guestMode.hasReachedProductLimit ? AppColors.danger : cs.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.m),

          // Product list from DB
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _showLowStockOnly
                  ? db.productsDao.watchLowStockProducts(shopId)
                  : db.productsDao.watchAllProducts(shopId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var products = snapshot.data ?? [];

                // Filter inactive
                products = products.where((p) => p.isActive).toList();

                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  final q = _searchQuery.toLowerCase();
                  products = products.where((p) {
                    return p.nameDari.toLowerCase().contains(q) ||
                        (p.nameEn?.toLowerCase().contains(q) ?? false) ||
                        (p.namePashto?.toLowerCase().contains(q) ?? false) ||
                        (p.barcode?.toLowerCase().contains(q) ?? false);
                  }).toList();
                }

                if (products.isEmpty) {
                  return AppEmptyState(
                    title: _searchQuery.isNotEmpty ? _tr('No products found', 'محصولی یافت نشد', 'هیڅ محصول ونه موندل شو') : _tr('No products yet', 'هنوز محصولی نیست', 'لا تر اوسه محصول نشته'),
                    description: _searchQuery.isNotEmpty 
                        ? _tr('Try a different search term', 'عبارت دیگری را امتحان کنید', 'بله د لټون بله کلمه وازمویئ') 
                        : _tr('Add your first product to get started', 'اولین محصول خود را اضافه کنید', 'د پیل لپاره خپل لومړی محصول زیات کړئ'),
                    icon: Icons.inventory_2_outlined,
                    action: _searchQuery.isEmpty ? AppButton(
                      text: _tr('Add Product', 'افزودن محصول', 'محصول زیات کړئ'),
                      icon: Icons.add_rounded,
                      onPressed: () => _addProduct(guestMode),
                    ) : null,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.m),
                      child: ProductCard(
                        name: p.nameDari,
                        barcode: p.barcode,
                        price: p.price,
                        stockQuantity: p.stockQuantity,
                        minStockAlert: p.minStockAlert,
                        unit: p.unit,
                        onTap: () => _editProduct(p),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.l, 0, AppSpacing.l, AppSpacing.l),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/inventory/stock-take'),
                icon: const Icon(Icons.checklist_rtl_rounded),
                label: Text(_tr('Stock Take', 'شمارش موجودی', 'د زېرمې شمېرنه')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addProduct(GuestModeState guestMode) async {
    if (guestMode.isGuest && guestMode.hasReachedProductLimit) {
      _showLimitReachedDialog();
      return;
    }
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditProductScreen()),
    );
    if (result == true && guestMode.isGuest) {
      ref.read(guestModeServiceProvider.notifier).incrementProduct();
    }
  }

  void _editProduct(Product product) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddEditProductScreen(product: product)),
    );
  }

  void _showLimitReachedDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
        title: Text(_tr('Demo Limit Reached', 'محدودیت نسخه آزمایشی', 'د ازمایښتي نسخې حد پوره شو'), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        content: Text(
          _na(_tr('You have reached the maximum of 10 products in demo mode. Upgrade to add unlimited products.', 'شما به سقف ۱۰ محصول در نسخه آزمایشی رسیده‌اید. برای محصولات نامحدود ارتقا دهید.', 'تاسو په ازمایښتي حالت کې د ۱۰ محصولاتو تر حد رسېدلي یاست. د نامحدود محصولاتو لپاره ارتقا وکړئ.')),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(_tr('Cancel', 'لغو', 'لغوه'))),
          AppButton(
            text: _tr('Upgrade', 'ارتقا', 'ارتقا'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
