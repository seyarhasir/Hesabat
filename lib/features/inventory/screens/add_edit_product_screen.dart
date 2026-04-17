import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';
import '../../../core/auth/guest_mode_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/sync/sync_service.dart';
import '../../../core/utils/barcode_lookup_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_layout.dart';
import '../../../shared/widgets/app_button.dart';

class AddEditProductScreen extends ConsumerStatefulWidget {
  final Product? product;
  final String? initialBarcode;

  const AddEditProductScreen({super.key, this.product, this.initialBarcode});

  @override
  ConsumerState<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends ConsumerState<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameDariController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _priceController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sizeVariantController = TextEditingController();
  final _stockController = TextEditingController();
  final _minStockController = TextEditingController();
  String _selectedUnit = 'piece';
  bool _isSaving = false;
  bool _isAutofilling = false;

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);

  bool get _isEditing => widget.product != null;

  static const _units = ['piece', 'kg', 'gram', 'liter', 'meter', 'box', 'pack', 'dozen'];

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final p = widget.product!;
      _nameDariController.text = p.nameDari;
      _nameEnController.text = p.nameEn ?? '';
      _barcodeController.text = p.barcode ?? '';
      _priceController.text = p.price.toStringAsFixed(0);
      _costPriceController.text = p.costPrice?.toStringAsFixed(0) ?? '';
      _sizeVariantController.text = p.sizeVariant ?? '';
      _stockController.text = p.stockQuantity.toStringAsFixed(0);
      _minStockController.text = p.minStockAlert.toStringAsFixed(0);
      _selectedUnit = p.unit;
    } else {
      _minStockController.text = '5';
      _stockController.text = '0';
      if (widget.initialBarcode != null && widget.initialBarcode!.trim().isNotEmpty) {
        _barcodeController.text = widget.initialBarcode!.trim();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _autofillFromBarcode();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _nameDariController.dispose();
    _nameEnController.dispose();
    _barcodeController.dispose();
    _priceController.dispose();
    _costPriceController.dispose();
    _sizeVariantController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? _tr('Edit Product', 'ویرایش محصول', 'محصول سمول') : _tr('Add Product', 'محصول جدید', 'نوی محصول')),
        actions: [
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: AppColors.danger),
              onPressed: _confirmDelete,
            ),
          const SizedBox(width: AppSpacing.s),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            _buildSectionHeader(context, _tr('Basic Information', 'اطلاعات اولیه', 'بنسټیز معلومات'), Icons.info_outline_rounded),
            const SizedBox(height: AppSpacing.l),
            
            // Product name (required)
            TextFormField(
              controller: _nameDariController,
              decoration: InputDecoration(
                labelText: _tr('Product Name *', 'نام محصول *', 'د محصول نوم *'),
                hintText: _tr('e.g. Green tea', 'مثال: چای سبز', 'لکه: شین چای'),
                prefixIcon: const Icon(Icons.inventory_2_outlined),
                filled: true,
                border: OutlineInputBorder(borderRadius: AppRadius.medium, borderSide: BorderSide.none),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? _tr('Product name is required', 'نام محصول الزامی است', 'د محصول نوم اړین دی') : null,
            ),
            const SizedBox(height: AppSpacing.m),

            // English name (optional)
            TextFormField(
              controller: _nameEnController,
              decoration: InputDecoration(
                labelText: _tr('English Name (optional)', 'نام انگلیسی (اختیاری)', 'انګلیسي نوم (اختیاري)'),
                hintText: _tr('e.g. Green Tea', 'مثال: Green Tea', 'لکه: Green Tea'),
                filled: true,
                border: OutlineInputBorder(borderRadius: AppRadius.medium, borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: AppSpacing.m),

            // Barcode (optional)
            TextFormField(
              controller: _barcodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _tr('Barcode (optional)', 'بارکد (اختیاری)', 'بارکوډ (اختیاري)'),
                hintText: _tr('Scan or enter barcode', 'بارکد را اسکن یا وارد کنید', 'بارکوډ سکین یا ولیکئ'),
                prefixIcon: const Icon(Icons.qr_code_scanner_rounded),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: _isAutofilling
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.auto_awesome_rounded),
                      onPressed: _isAutofilling ? null : _autofillFromBarcode,
                      tooltip: _tr('Auto-fill from barcode', 'تکمیل خودکار با بارکد', 'له بارکوډه اتومات ډکول'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.photo_camera_back_rounded),
                      onPressed: _scanBarcode,
                      tooltip: _tr('Scan barcode', 'اسکن بارکد', 'بارکوډ سکن'),
                    ),
                  ],
                ),
                filled: true,
                border: OutlineInputBorder(borderRadius: AppRadius.medium, borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            _buildSectionHeader(context, _tr('Pricing & Inventory', 'قیمت و موجودی', 'بیه او زېرمه'), Icons.account_balance_wallet_outlined),
            const SizedBox(height: AppSpacing.l),

            // Price row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _tr('Sell Price *', 'قیمت فروش *', 'د پلور بیه *'),
                      suffixText: _tr('AFN', '؋', '؋'),
                      filled: true,
                      border: OutlineInputBorder(borderRadius: AppRadius.medium, borderSide: BorderSide.none),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return _tr('Required', 'الزامی', 'اړین');
                      if (double.tryParse(v) == null) return _tr('Invalid', 'نامعتبر', 'ناسم');
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: TextFormField(
                    controller: _costPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _tr('Cost Price', 'قیمت خرید', 'د پېر بیه'),
                      suffixText: _tr('AFN', '؋', '؋'),
                      filled: true,
                      border: OutlineInputBorder(borderRadius: AppRadius.medium, borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),

            TextFormField(
              controller: _sizeVariantController,
              decoration: InputDecoration(
                labelText: _tr('Size / Quantity (optional)', 'اندازه / مقدار (اختیاری)', 'اندازه / مقدار (اختیاري)'),
                hintText: _tr('e.g. 300ml, 1L, 50g', 'مثال: 300ml، 1L، 50g', 'لکه: 300ml، 1L، 50g'),
                filled: true,
                border: OutlineInputBorder(borderRadius: AppRadius.medium, borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: AppSpacing.m),

            // Stock
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _tr('Initial Stock *', 'موجودی فعلی *', 'اوسنۍ زېرمه *'),
                      filled: true,
                      border: OutlineInputBorder(borderRadius: AppRadius.medium, borderSide: BorderSide.none),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return _tr('Required', 'الزامی', 'اړین');
                      if (double.tryParse(v) == null) return _tr('Invalid', 'نامعتبر', 'ناسم');
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: TextFormField(
                    controller: _minStockController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _tr('Min Alert', 'حداقل موجودی', 'د کمښت حد'),
                      filled: true,
                      border: OutlineInputBorder(borderRadius: AppRadius.medium, borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),

            // Unit dropdown
            DropdownButtonFormField<String>(
              value: _selectedUnit,
              decoration: InputDecoration(
                labelText: _tr('Unit', 'واحد', 'واحد'),
                filled: true,
                border: OutlineInputBorder(borderRadius: AppRadius.medium, borderSide: BorderSide.none),
              ),
              items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedUnit = v);
              },
            ),
            const SizedBox(height: AppSpacing.sectionGap),

            // Save button
            AppButton(
              text: _isEditing ? _tr('Update Product', 'ذخیره تغییرات', 'محصول تازه کړئ') : _tr('Add Product', 'ذخیره محصول', 'محصول خوندي کړئ'),
              isLoading: _isSaving,
              onPressed: _save,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: cs.primary),
        const SizedBox(width: AppSpacing.s),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSurface.withOpacity(0.8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Future<void> _scanBarcode() async {
    final result = await Navigator.pushNamed(context, '/sales/barcode');
    if (!mounted || result is! Map<String, dynamic>) return;

    final scanned = result['barcode']?.toString();
    if (scanned == null || scanned.trim().isEmpty) return;

    setState(() {
      _barcodeController.text = scanned.trim();
    });
    await _autofillFromBarcode();
  }

  Future<void> _autofillFromBarcode() async {
    final raw = _barcodeController.text.trim();
    if (raw.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('Enter a barcode first', 'اول بارکد را وارد کنید', 'لومړی بارکوډ دننه کړئ'))),
      );
      return;
    }

    setState(() => _isAutofilling = true);

    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);

    try {
      final local = await db.productsDao.getProductByBarcode(shopId, raw);
      if (local != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_tr('Barcode already exists in your inventory', 'این بارکد قبلاً در موجودی شما ثبت شده', 'دا بارکوډ مخکې ستاسو په زېرمه کې شته'))),
        );
        return;
      }

      final candidate = await BarcodeLookupService.instance.lookupCandidateForPrefill(
        db: db,
        shopId: shopId,
        barcode: raw,
      );

      if (candidate == null) {
        final probe = await BarcodeLookupService.instance.debugProbeBarcode(raw);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_tr('No API data found ($probe)', 'برای این بارکد داده‌ای پیدا نشد ($probe)', 'د دې بارکوډ لپاره معلومات ونه موندل شول ($probe)'))),
        );
        return;
      }

      final nextUnit = _units.contains(candidate.unit) ? candidate.unit : 'piece';

      setState(() {
        _barcodeController.text = candidate.barcode;
        _nameDariController.text = candidate.nameDari;
        _nameEnController.text = candidate.nameEn;
        _sizeVariantController.text = candidate.quantityLabel ?? '';
        _selectedUnit = nextUnit;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            candidate.source == BarcodeLookupSource.community
                ? _tr('Auto-filled from community data', 'از داده‌های اشتراکی تکمیل شد', 'له ګډو معلوماتو اتومات ډک شو')
                : _tr('Auto-filled from Open Food API', 'از Open Food API تکمیل شد', 'له Open Food API اتومات ډک شو'),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isAutofilling = false);
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);
    final syncEnabled = !(await GuestModeService.isGuestMode());
    final now = DateTime.now();
    final nowIso = now.toUtc().toIso8601String();
    final productId = _isEditing ? widget.product!.id : const Uuid().v4();
    final nameDari = _nameDariController.text.trim();
    final nameEn = _nameEnController.text.trim().isEmpty ? null : _nameEnController.text.trim();
    final barcode = _barcodeController.text.trim().isEmpty ? null : _barcodeController.text.trim();
    final price = double.parse(_priceController.text);
    final costPrice = _costPriceController.text.isEmpty ? null : double.parse(_costPriceController.text);
    final sizeVariant = _sizeVariantController.text.trim().isEmpty ? null : _sizeVariantController.text.trim();
    final stock = double.parse(_stockController.text);
    final minStock = double.tryParse(_minStockController.text) ?? 5.0;

    try {
      if (_isEditing) {
        await db.productsDao.updateProduct(
          productId,
          ProductsCompanion(
            id: Value(productId),
            shopId: Value(shopId),
            nameDari: Value(nameDari),
            nameEn: Value(nameEn),
            barcode: Value(barcode),
            price: Value(price),
            costPrice: Value(costPrice),
            sizeVariant: Value(sizeVariant),
            stockQuantity: Value(stock),
            minStockAlert: Value(minStock),
            unit: Value(_selectedUnit),
            updatedAt: Value(now),
          ),
        );

        if (syncEnabled) {
          await SyncService.instance.enqueueOperation(
            shopId: shopId,
            targetTable: 'products',
            recordId: productId,
            operation: 'UPDATE',
            payload: {
              'id': productId,
              'shop_id': shopId,
              'name': nameDari,
              'name_dari': nameDari,
              'name_en': nameEn,
              'barcode': barcode,
              'price': price,
              'cost_price': costPrice,
              'size_variant': sizeVariant,
              'stock_quantity': stock,
              'min_stock_alert': minStock,
              'unit': _selectedUnit,
              'updated_at': nowIso,
            },
          );
        }
      } else {
        await db.productsDao.insertProduct(
          ProductsCompanion(
            id: Value(productId),
            shopId: Value(shopId),
            nameDari: Value(nameDari),
            nameEn: Value(nameEn),
            barcode: Value(barcode),
            price: Value(price),
            costPrice: Value(costPrice),
            sizeVariant: Value(sizeVariant),
            stockQuantity: Value(stock),
            minStockAlert: Value(minStock),
            unit: Value(_selectedUnit),
          ),
        );

        if (syncEnabled) {
          await SyncService.instance.enqueueOperation(
            shopId: shopId,
            targetTable: 'products',
            recordId: productId,
            operation: 'INSERT',
            payload: {
              'id': productId,
              'shop_id': shopId,
              'name': nameDari,
              'name_dari': nameDari,
              'name_en': nameEn,
              'barcode': barcode,
              'price': price,
              'cost_price': costPrice,
              'size_variant': sizeVariant,
              'stock_quantity': stock,
              'min_stock_alert': minStock,
              'unit': _selectedUnit,
              'created_at': nowIso,
              'updated_at': nowIso,
            },
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? _tr('Product updated', 'محصول ویرایش شد', 'محصول تازه شو') : _tr('Product added', 'محصول اضافه شد', 'محصول زیات شو')),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_tr('Error: $e', 'خطا: $e', 'تېروتنه: $e')), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
        title: Text(_tr('Delete Product', 'حذف محصول', 'محصول حذف کړئ')),
        content: Text(_tr('Are you sure you want to delete this product? This cannot be undone.', 'آیا مطمئن هستید که این محصول حذف شود؟ این عمل قابل بازگشت نیست.', 'ایا تاسو ډاډه یاست چې دا محصول حذف کړئ؟ دا بېرته نه راګرځي.')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(_tr('Cancel', 'لغو', 'لغوه'))),
          AppButton(
            text: _tr('Delete', 'حذف', 'حذف'),
            onPressed: () async {
              Navigator.pop(context);
              final db = ref.read(databaseProvider);
              final shopId = ref.read(currentShopIdProvider);
              await db.productsDao.softDeleteProduct(widget.product!.id);

              final syncEnabled = !(await GuestModeService.isGuestMode());
              if (syncEnabled) {
                await SyncService.instance.enqueueOperation(
                  shopId: shopId,
                  targetTable: 'products',
                  recordId: widget.product!.id,
                  operation: 'DELETE',
                  payload: {'id': widget.product!.id},
                );
              }

              if (mounted) {
                Navigator.pop(context, true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_tr('Product deleted', 'محصول حذف شد', 'محصول حذف شو')), backgroundColor: AppColors.danger),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
