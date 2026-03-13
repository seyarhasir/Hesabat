import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/auth/guest_mode_service.dart';
import '../../../core/sync/sync_service.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_layout.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/product_card.dart';

/// Sale Recording Screen
class SaleScreen extends ConsumerStatefulWidget {
  const SaleScreen({super.key});

  @override
  ConsumerState<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends ConsumerState<SaleScreen> {
  final List<CartItem> _cart = [];
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;
  bool _showCartFirst = false;
  List<Product> _searchResults = [];
  List<Product> _recentProducts = [];

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);
  String _nf(num v, {int d = 0}) => NumberSystemFormatter.formatFixed(v, fractionDigits: d);
  String _na(String s) => NumberSystemFormatter.apply(s);

  @override
  void initState() {
    super.initState();
    _loadRecentProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('New Sale', 'فروش جدید', 'نوی پلور')),
        actions: [
          if (_cart.isNotEmpty)
            TextButton.icon(
              onPressed: _clearCart,
              icon: const Icon(Icons.clear_all_rounded, size: 20),
              label: Text(_tr('Clear', 'پاک کردن', 'پاکول')),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.m),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: AppRadius.large,
                border: Border.all(color: cs.outline.withOpacity(0.1)),
              ),
              child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _onSearch,
                  decoration: InputDecoration(
                    hintText: _tr('Search products...', 'جستجوی محصول...', 'د محصول لټون...'),
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                                _searchResults = [];
                              });
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
                const SizedBox(height: AppSpacing.m),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _openBarcodeScanner,
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        label: Text(_tr('Scan', 'اسکن', 'سکن')),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _showRecentProducts,
                        icon: const Icon(Icons.history_rounded),
                        label: Text(_tr('Recent', 'اخیر', 'وروستي')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Cart mini summary
          if (_cart.isNotEmpty) _buildCartMiniSummary(cs, theme),

          // Product list, recent+cart, or empty state
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _searchQuery.isNotEmpty
                  ? _buildProductSearchResults(cs, theme)
                  : _isLoading && _recentProducts.isEmpty && _cart.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : (_recentProducts.isNotEmpty || _cart.isNotEmpty)
                          ? _buildRecentAndCart(cs, theme)
                          : AppEmptyState(
                              title: _tr('Start a New Sale', 'فروش جدید را شروع کنید', 'نوی پلور پیل کړئ'),
                              description: _tr('Search or scan products to add to cart', 'برای افزودن به سبد، محصول را جستجو یا اسکن کنید', 'ټوکرۍ ته د زیاتولو لپاره محصولات ولټوئ یا سکن کړئ'),
                              icon: Icons.add_shopping_cart_rounded,
                            ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _cart.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.l),
                decoration: BoxDecoration(
                  color: cs.surface,
                  boxShadow: [
                    BoxShadow(
                      color: cs.onSurface.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _tr('Total Amount', 'جمع کل', 'ټولیز مبلغ'),
                            style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.6)),
                          ),
                          Text(
                            '${_nf(_calculateTotal())} ${_tr('AFN', '؋', '؋')}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppButton(
                      text: _tr('Pay / Record Sale', 'پرداخت / ثبت فروش', 'تادیه / پلور ثبتول'),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/sales/review',
                        arguments: {
                          'items': _cart
                              .map((e) => {
                                    'productId': e.productId,
                                    'name': e.productName,
                                    'quantity': e.quantity,
                                    'price': e.price,
                                  })
                              .toList(),
                          'total': _calculateTotal(),
                        },
                      ),
                      icon: Icons.arrow_forward_rounded,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _onSearch(String value) async {
    setState(() => _searchQuery = value);
    if (value.trim().isEmpty) {
      setState(() => _searchResults = []);
      _loadRecentProducts();
      return;
    }
    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);
    final results = await db.productsDao.searchProducts(shopId, value.trim());
    if (mounted) {
      setState(() => _searchResults = results.where((p) => p.isActive).toList());
    }
  }

  Future<void> _loadRecentProducts() async {
    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);

    setState(() => _isLoading = true);
    final recent = await db.productsDao.getRecentProducts(shopId, limit: 12);
    if (!mounted) return;
    setState(() {
      _recentProducts = recent.where((p) => p.isActive).toList();
      _isLoading = false;
    });
  }

  void _showRecentProducts() {
    FocusScope.of(context).unfocus();
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _searchResults = [];
    });
    _loadRecentProducts();
  }

  Widget _buildCartMiniSummary(ColorScheme cs, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.l, 0, AppSpacing.l, AppSpacing.l),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.s),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.05),
        borderRadius: AppRadius.medium,
        border: Border.all(color: cs.primary.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _tr('${_cart.length} items in cart', '${_cart.length} محصول در سبد', 'په ټوکرۍ کې ${_cart.length} توکي'),
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: cs.primary),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _showCartFirst = true;
              });
            },
            child: Text(_tr('View Cart', 'نمایش سبد', 'ټوکرۍ وګورئ')),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSearchResults(ColorScheme cs, ThemeData theme) {
    if (_searchResults.isEmpty) {
      return AppEmptyState(
        title: _tr('No products found', 'محصولی یافت نشد', 'محصول ونه موندل شو'),
        description: _tr('Try a different search term', 'عبارت دیگری را جستجو کنید', 'د لټون بله کلمه وکاروئ'),
        icon: Icons.search_off_rounded,
        isLarge: false,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        final inCart = _cart.any((c) => c.productId == product.id);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.m),
          child: ProductCard(
            name: product.nameDari,
            barcode: product.barcode,
            price: product.price,
            stockQuantity: product.stockQuantity,
            minStockAlert: product.minStockAlert,
            unit: product.unit,
            trailing: inCart
                ? Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(Icons.check_rounded, color: AppColors.success, size: 20),
                  )
                : IconButton(
                    icon: Icon(Icons.add_circle_rounded, color: cs.primary, size: 28),
                    onPressed: () => _addToCart(product),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildRecentAndCart(ColorScheme cs, ThemeData theme) {
    final recentSection = <Widget>[
      Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.m, top: _showCartFirst && _cart.isNotEmpty ? AppSpacing.m : 0),
        child: _sectionHeader(
          theme,
          title: _tr('Recent Products', 'محصولات اخیر', 'وروستي محصولات'),
          count: _recentProducts.length,
        ),
      ),
      ..._recentProducts.map((product) {
        final inCart = _cart.any((c) => c.productId == product.id);
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.m),
          child: ProductCard(
            name: product.nameDari,
            barcode: product.barcode,
            price: product.price,
            stockQuantity: product.stockQuantity,
            minStockAlert: product.minStockAlert,
            unit: product.unit,
            trailing: inCart
                ? Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(Icons.check_rounded, color: AppColors.success, size: 20),
                  )
                : IconButton(
                    icon: Icon(Icons.add_circle_rounded, color: cs.primary, size: 28),
                    onPressed: () => _addToCart(product),
                  ),
          ),
        );
      }),
    ];

    final cartSection = <Widget>[
      Padding(
        padding: EdgeInsets.only(top: _recentProducts.isNotEmpty ? AppSpacing.m : 0, bottom: AppSpacing.m),
        child: _sectionHeader(
          theme,
          title: _tr('Cart', 'سبد خرید', 'ټوکرۍ'),
          count: _cart.length,
        ),
      ),
      ..._cart.asMap().entries.map((entry) => _buildCartItemCard(entry.key, entry.value, cs, theme)),
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      children: [
        if (_showCartFirst && _cart.isNotEmpty) ...cartSection,
        if (_recentProducts.isNotEmpty) ...recentSection,
        if (!_showCartFirst && _cart.isNotEmpty) ...cartSection,
      ],
    );
  }

  Widget _sectionHeader(ThemeData theme, {required String title, required int count}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.08),
            borderRadius: AppRadius.small,
          ),
          child: Text(
            _nf(count),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItemCard(int index, CartItem item, ColorScheme cs, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: cs.outline.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _na(_tr('${_nf(item.price)} AFN each', '${_nf(item.price)} ؋ فی واحد', '${_nf(item.price)} ؋ هر یو')),
                      style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.5)),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline_rounded, color: AppColors.danger.withOpacity(0.7)),
                onPressed: () => setState(() => _cart.removeAt(index)),
              ),
            ],
          ),
          const Divider(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _na(_tr(
                  'Subtotal: ${_nf(item.quantity * item.price)} AFN',
                  'جمع جزء: ${_nf(item.quantity * item.price)} ؋',
                  'فرعي جمع: ${_nf(item.quantity * item.price)} ؋',
                )),
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Container(
                decoration: BoxDecoration(
                  color: cs.onSurface.withOpacity(0.05),
                  borderRadius: AppRadius.medium,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_rounded, size: 18),
                      onPressed: () {
                        setState(() {
                          if (item.quantity <= 1) {
                            _cart.removeAt(index);
                          } else {
                            _cart[index] = item.copyWith(quantity: item.quantity - 1);
                          }
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
                      child: Text(
                        _nf(item.quantity),
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_rounded, size: 18),
                      onPressed: item.quantity >= item.maxStock
                          ? null
                          : () {
                              setState(() {
                                _cart[index] = item.copyWith(quantity: item.quantity + 1);
                              });
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addToCart(Product product) {
    final existing = _cart.indexWhere((c) => c.productId == product.id);
    setState(() {
      if (existing >= 0) {
        final item = _cart[existing];
        if (item.quantity < product.stockQuantity) {
          _cart[existing] = item.copyWith(quantity: item.quantity + 1);
        }
      } else {
        _cart.add(CartItem(
          productId: product.id,
          productName: product.nameDari,
          price: product.price,
          maxStock: product.stockQuantity,
        ));
      }
    });
  }

  Future<void> _openBarcodeScanner() async {
    final result = await Navigator.pushNamed(context, '/sales/barcode');
    if (!mounted || result == null) return;

    if (result is Map<String, dynamic>) {
      final productId = result['productId']?.toString();
      if (productId != null && productId.isNotEmpty) {
        final db = ref.read(databaseProvider);
        final product = await db.productsDao.getProductById(productId);
        if (product != null && mounted) {
          _addToCart(product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_tr('${product.nameDari} added to cart', '${product.nameDari} به سبد اضافه شد', '${product.nameDari} ټوکرۍ ته زیات شو')),
              backgroundColor: AppColors.success,
            ),
          );
        }
        return;
      }

      final notFound = result['notFound'] == true;
      if (notFound && mounted) {
        final barcode = result['barcode']?.toString();
        final created = await Navigator.pushNamed(
          context,
          '/inventory/add-product',
          arguments: {
            'barcode': barcode,
          },
        );

        if (created == true && barcode != null && mounted) {
          final db = ref.read(databaseProvider);
          final shopId = ref.read(currentShopIdProvider);
          final added = await db.productsDao.getProductByBarcode(shopId, barcode);
          if (added != null && mounted) {
            _addToCart(added);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_tr('${added.nameDari} was added and moved to cart', '${added.nameDari} اضافه شد و به سبد رفت', '${added.nameDari} زیات شو او ټوکرۍ ته ولاړ')),
                backgroundColor: AppColors.success,
              ),
            );
          }
        }
      }
    }
  }

  double _calculateTotal() {
    return _cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void _clearCart() {
    setState(() => _cart.clear());
  }

  void _showGuestLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr('Demo Limit Reached', 'محدودیت نسخه آزمایشی', 'د ازمایښتي نسخې حد پوره شو')),
        content: Text(_tr('You have reached the maximum number of sales for demo mode.\n\nUpgrade to full version for unlimited sales.', 'تعداد مجاز فروش در نسخه آزمایشی تکمیل شده است.\n\nبرای فروش نامحدود ارتقا دهید.', 'تاسو په ازمایښتي حالت کې د پلور اعظمي حد ته رسېدلي یاست.\n\nد نامحدود پلور لپاره بشپړې نسخې ته ارتقا وکړئ.')),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(_tr('OK', 'باشه', 'سمه ده')))],
      ),
    );
  }
}

class CartItem {
  final String productId;
  final String productName;
  final double price;
  final double quantity;
  final double maxStock;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    this.quantity = 1,
    this.maxStock = double.infinity,
  });

  CartItem copyWith({double? quantity}) => CartItem(
        productId: productId,
        productName: productName,
        price: price,
        quantity: quantity ?? this.quantity,
        maxStock: maxStock,
      );
}
