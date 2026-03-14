import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/settings/calendar_system_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../providers/pending_scanned_barcode_result_provider.dart';
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
  String _mode = 'new'; // new | history
  bool _isLoading = false;
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
    ref.watch(appCalendarSystemProvider);
    final pendingGlobalScan = ref.watch(pendingScannedBarcodeResultProvider);
    if (pendingGlobalScan != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _consumePendingGlobalScanResult(pendingGlobalScan);
      });
    }
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_mode == 'new'
            ? _tr('New Sale', 'فروش جدید', 'نوی پلور')
            : _tr('Sales History', 'تاریخچه فروش', 'د پلور تاریخچه')),
        actions: [
          if (_mode == 'new' && _cart.isNotEmpty)
            TextButton.icon(
              onPressed: _clearCart,
              icon: const Icon(Icons.clear_all_rounded, size: 20),
              label: Text(_tr('Clear', 'پاک کردن', 'پاکول')),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.l, AppSpacing.l, 0),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment<String>(
                  value: 'new',
                  icon: const Icon(Icons.add_shopping_cart_rounded),
                  label: Text(_tr('New Sale', 'فروش جدید', 'نوی پلور')),
                ),
                ButtonSegment<String>(
                  value: 'history',
                  icon: const Icon(Icons.receipt_long_rounded),
                  label: Text(_tr('History', 'تاریخچه', 'تاریخچه')),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (selection) {
                setState(() {
                  _mode = selection.first;
                });
              },
            ),
          ),

          if (_mode == 'new')
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
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
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
                        ),
                        const SizedBox(width: AppSpacing.m),
                        SizedBox(
                          height: 52,
                          width: 52,
                          child: OutlinedButton(
                            onPressed: _openBarcodeScanner,
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
                            ),
                            child: const Icon(Icons.qr_code_scanner_rounded),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Product list / history list
          Expanded(
            child: _mode == 'history'
                ? _buildSalesHistoryView(cs, theme)
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: _searchQuery.isNotEmpty
                        ? _buildProductSearchResults(cs, theme)
                        : _isLoading && _recentProducts.isEmpty && _cart.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : _cart.isNotEmpty
                                ? _buildCartFocusedView(cs, theme)
                                : _recentProducts.isNotEmpty
                                    ? _buildRecentList(cs, theme)
                                    : AppEmptyState(
                                        title: _tr('Start a New Sale', 'فروش جدید را شروع کنید', 'نوی پلور پیل کړئ'),
                                        description: _tr('Search or scan products to add to cart', 'برای افزودن به سبد، محصول را جستجو یا اسکن کنید', 'ټوکرۍ ته د زیاتولو لپاره محصولات ولټوئ یا سکن کړئ'),
                                        icon: Icons.add_shopping_cart_rounded,
                                      ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _mode != 'new' || _cart.isEmpty
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(10, 0, 10, AppSpacing.l),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.l),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: AppRadius.xLarge,
                  border: Border.all(color: cs.outline.withOpacity(0.12)),
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

  Widget _buildSalesHistoryView(ColorScheme cs, ThemeData theme) {
    final db = ref.watch(databaseProvider);
    final shopId = ref.watch(currentShopIdProvider);

    return StreamBuilder<List<Sale>>(
      stream: db.salesDao.watchSalesByShopId(shopId),
      builder: (context, snapshot) {
        final sales = [...(snapshot.data ?? const <Sale>[])];
        sales.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (sales.isEmpty) {
          return AppEmptyState(
            title: _tr('No sales yet', 'هنوز فروشی ثبت نشده', 'لا تر اوسه پلور نشته'),
            description: _tr('Record a new sale to see history here', 'برای دیدن تاریخچه، یک فروش جدید ثبت کنید', 'دلته د تاریخچې لپاره نوی پلور ثبت کړئ'),
            icon: Icons.receipt_long_rounded,
            actionLabel: _tr('Start New Sale', 'شروع فروش جدید', 'نوی پلور پیل کړئ'),
            onAction: () => setState(() => _mode = 'new'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.l),
          itemCount: sales.length,
          itemBuilder: (context, index) {
            final sale = sales[index];
            final isCredit = sale.isCredit || sale.paymentMethod == 'credit';
            final statusColor = isCredit ? AppColors.warning : AppColors.success;

            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.m),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
                leading: CircleAvatar(
                  backgroundColor: statusColor.withOpacity(0.12),
                  child: Icon(isCredit ? Icons.credit_card_rounded : Icons.payments_rounded, color: statusColor),
                ),
                title: Text(
                  '${_nf(sale.totalAfn)} ${_tr('AFN', '؋', '؋')}',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${_paymentMethodLabel(sale.paymentMethod)} • ${_formatSaleDate(sale.createdAt)}',
                  style: theme.textTheme.bodySmall,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _openSaleDetails(sale),
              ),
            );
          },
        );
      },
    );
  }

  String _paymentMethodLabel(String method) {
    switch (method) {
      case 'credit':
        return _tr('Credit', 'قرضی', 'قرض');
      case 'mixed':
        return _tr('Split', 'ترکیبی', 'ګډ');
      case 'cash':
      default:
        return _tr('Cash', 'نقدی', 'نغدي');
    }
  }

  String _formatSaleDate(DateTime dt) {
    final system = ref.read(appCalendarSystemProvider);
    final calendarType = system == CalendarSystem.persian ? CalendarType.persian : CalendarType.gregorian;
    return DateFormatter.formatDateTime(dt, calendar: calendarType, locale: _lang);
  }

  Future<void> _openSaleDetails(Sale sale) async {
    final db = ref.read(databaseProvider);
    final items = await db.salesDao.getSaleItems(sale.id);
    if (!mounted) return;

    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.s, AppSpacing.l, AppSpacing.l),
            children: [
              Text(_tr('Sale Details', 'جزئیات فروش', 'د پلور جزییات'), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpacing.m),
              Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: AppRadius.medium,
                  border: Border.all(color: cs.outline.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_tr('Date: ${_formatSaleDate(sale.createdAt)}', 'تاریخ: ${_formatSaleDate(sale.createdAt)}', 'نېټه: ${_formatSaleDate(sale.createdAt)}')),
                    const SizedBox(height: 6),
                    Text(_tr('Payment: ${_paymentMethodLabel(sale.paymentMethod)}', 'پرداخت: ${_paymentMethodLabel(sale.paymentMethod)}', 'تادیه: ${_paymentMethodLabel(sale.paymentMethod)}')),
                    const SizedBox(height: AppSpacing.s),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _tr('Total: ${_nf(sale.totalAfn)} ${_tr('AFN', '؋', '؋')}', 'مجموع: ${_nf(sale.totalAfn)} ${_tr('AFN', '؋', '؋')}', 'ټول: ${_nf(sale.totalAfn)} ${_tr('AFN', '؋', '؋')}'),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              ...items.map(
                (item) => Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.s),
                  padding: const EdgeInsets.all(AppSpacing.s),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: AppRadius.medium,
                    border: Border.all(color: cs.outline.withOpacity(0.15)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.productNameSnapshot, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(
                              _tr('Qty: ${_nf(item.quantity)} × ${_nf(item.unitPrice)}', 'تعداد: ${_nf(item.quantity)} × ${_nf(item.unitPrice)}', 'شمېر: ${_nf(item.quantity)} × ${_nf(item.unitPrice)}'),
                              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Text(
                        '${_nf(item.subtotal)} ${_tr('AFN', '؋', '؋')}',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_tr('Total', 'مجموع', 'ټول')),
                trailing: Text(
                  '${_nf(sale.totalAfn)} ${_tr('AFN', '؋', '؋')}',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.warning),
                ),
              ),
            ],
          ),
        );
      },
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

  Widget _buildCartFocusedView(ColorScheme cs, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.m),
          child: _sectionHeader(
            theme,
            title: _tr('Cart', 'سبد خرید', 'ټوکرۍ'),
            count: _cart.length,
          ),
        ),
        ..._cart.asMap().entries.map((entry) => _buildCartItemCard(entry.key, entry.value, cs, theme)),
      ],
    );
  }

  Widget _buildRecentList(ColorScheme cs, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.m),
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
      ],
    );
  }

  Widget _sectionHeader(ThemeData theme, {required String title, required int count, Widget? action}) {
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
        if (action != null) ...[
          const SizedBox(width: AppSpacing.s),
          action,
        ],
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

  Future<void> _consumePendingGlobalScanResult(Map<String, dynamic> result) async {
    ref.read(pendingScannedBarcodeResultProvider.notifier).state = null;
    if (!mounted) return;

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
