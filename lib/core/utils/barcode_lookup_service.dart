import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:openfoodfacts/openfoodfacts.dart' as off;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import '../network/connectivity_service.dart';

enum BarcodeLookupSource { local, community, api, manual }

class BarcodeLookupCandidate {
  final String barcode;
  final String nameEn;
  final String nameDari;
  final String? quantityLabel;
  final String? manufacturer;
  final String unit;
  final List<String> categoriesTags;
  final BarcodeLookupSource source;

  const BarcodeLookupCandidate({
    required this.barcode,
    required this.nameEn,
    required this.nameDari,
    this.quantityLabel,
    required this.unit,
    required this.categoriesTags,
    required this.source,
    this.manufacturer,
  });
}

class BarcodeLookupOutcome {
  final BarcodeLookupSource source;
  final Product? localProduct;
  final BarcodeLookupCandidate? candidate;

  const BarcodeLookupOutcome._({
    required this.source,
    this.localProduct,
    this.candidate,
  });

  factory BarcodeLookupOutcome.local(Product product) =>
      BarcodeLookupOutcome._(source: BarcodeLookupSource.local, localProduct: product);

  factory BarcodeLookupOutcome.community(Product product) =>
      BarcodeLookupOutcome._(source: BarcodeLookupSource.community, localProduct: product);

  factory BarcodeLookupOutcome.apiCandidate(BarcodeLookupCandidate candidate) =>
      BarcodeLookupOutcome._(source: BarcodeLookupSource.api, candidate: candidate);

  factory BarcodeLookupOutcome.manual() =>
      const BarcodeLookupOutcome._(source: BarcodeLookupSource.manual);
}

class BarcodeLookupService {
  BarcodeLookupService._();
  static final BarcodeLookupService instance = BarcodeLookupService._();

  static bool _sdkConfigured = false;

  SupabaseClient get _supabase => Supabase.instance.client;

  void _configureSdkIfNeeded() {
    if (_sdkConfigured) return;
    off.OpenFoodAPIConfiguration.userAgent = off.UserAgent(name: 'Hesabat');
    off.OpenFoodAPIConfiguration.globalLanguages = <off.OpenFoodFactsLanguage>[
      off.OpenFoodFactsLanguage.ENGLISH,
      off.OpenFoodFactsLanguage.ARABIC,
    ];
    _sdkConfigured = true;
  }

  Future<BarcodeLookupOutcome> lookup({
    required AppDatabase db,
    required String shopId,
    required String barcode,
  }) async {
    final normalizedBarcode = _normalizeBarcodeInput(barcode);
    if (normalizedBarcode.isEmpty) return BarcodeLookupOutcome.manual();

    final local = await db.productsDao.getProductByBarcode(shopId, normalizedBarcode);
    if (local != null) return BarcodeLookupOutcome.local(local);

    final community = await _fetchFromCommunity(normalizedBarcode);
    if (community != null) {
      final saved = await saveCandidateLocally(
        db: db,
        shopId: shopId,
        candidate: community,
      );
      return BarcodeLookupOutcome.community(saved);
    }

    final shop = await db.shopsDao.getShopById(shopId);
    final type = (shop?.shopType ?? 'general').toLowerCase();
    final isBeautyFirst = type == 'pharmacy' || type == 'cosmetics';

    BarcodeLookupCandidate? candidate;
    if (isBeautyFirst) {
      candidate = await _fetchFromApi(normalizedBarcode, beauty: true);
      candidate ??= await _fetchFromApi(normalizedBarcode, beauty: false);
    } else {
      candidate = await _fetchFromApi(normalizedBarcode, beauty: false);
      candidate ??= await _fetchFromApi(normalizedBarcode, beauty: true);
    }

    if (candidate == null) return BarcodeLookupOutcome.manual();
    return BarcodeLookupOutcome.apiCandidate(candidate);
  }

  /// Lookup candidate data for form prefill without creating any local product.
  Future<BarcodeLookupCandidate?> lookupCandidateForPrefill({
    required AppDatabase db,
    required String shopId,
    required String barcode,
  }) async {
    final normalizedBarcode = _normalizeBarcodeInput(barcode);
    if (normalizedBarcode.isEmpty) return null;

    final community = await _fetchFromCommunity(normalizedBarcode);
    if (community != null) return community;

    final shop = await db.shopsDao.getShopById(shopId);
    final type = (shop?.shopType ?? 'general').toLowerCase();
    final isBeautyFirst = type == 'pharmacy' || type == 'cosmetics';

    BarcodeLookupCandidate? candidate;
    if (isBeautyFirst) {
      candidate = await _fetchFromApi(normalizedBarcode, beauty: true);
      candidate ??= await _fetchFromApi(normalizedBarcode, beauty: false);
    } else {
      candidate = await _fetchFromApi(normalizedBarcode, beauty: false);
      candidate ??= await _fetchFromApi(normalizedBarcode, beauty: true);
    }

    return candidate;
  }

  /// Debug helper for runtime diagnostics on device.
  Future<String> debugProbeBarcode(String barcode) async {
    final normalized = _normalizeBarcodeInput(barcode);
    if (normalized.isEmpty) return 'invalid_barcode';

    final uri = Uri.https(
      'world.openfoodfacts.org',
      '/api/v2/product/$normalized.json',
      {'fields': 'status,status_verbose,product_name,product_name_en,code'},
    );

    try {
      final json = await _fetchJsonMap(uri);
      if (json == null) return 'http_null_response';

      final statusRaw = json['status'];
      final status = statusRaw is num ? statusRaw.toInt() : int.tryParse('$statusRaw') ?? 0;
      final statusVerbose = (json['status_verbose'] ?? '').toString();

      final productRaw = json['product'];
      String name = '';
      String quantity = '';
      if (productRaw is Map) {
        final product = Map<String, dynamic>.from(productRaw);
        name = (product['product_name_en'] ?? product['product_name'] ?? '').toString().trim();
        quantity = (product['quantity'] ?? '').toString().trim();
      }

      return 'http_status=$status verbose=$statusVerbose name=${name.isEmpty ? '-empty-' : name} quantity=${quantity.isEmpty ? '-empty-' : quantity}';
    } catch (e) {
      return 'probe_error=$e';
    }
  }

  Future<Product> saveCandidateLocally({
    required AppDatabase db,
    required String shopId,
    required BarcodeLookupCandidate candidate,
  }) async {
    final categoryId = await _guessCategoryId(
      db: db,
      shopId: shopId,
      categoriesTags: candidate.categoriesTags,
    );

    final id = 'local_prod_${DateTime.now().microsecondsSinceEpoch}';

    await db.productsDao.insertProduct(
      ProductsCompanion.insert(
        id: Value(id),
        shopId: shopId,
        nameDari: candidate.nameDari.trim().isEmpty ? candidate.nameEn : candidate.nameDari,
        nameEn: Value(candidate.nameEn.trim().isEmpty ? null : candidate.nameEn),
        barcode: Value(candidate.barcode),
        unit: Value(candidate.unit),
        sizeVariant: Value(candidate.quantityLabel?.trim().isEmpty ?? true ? null : candidate.quantityLabel),
        categoryId: Value(categoryId),
        manufacturer: Value(candidate.manufacturer?.trim().isEmpty ?? true ? null : candidate.manufacturer),
        imageUrl: const Value(null),
        syncStatus: const Value('pending'),
      ),
    );

    final product = await db.productsDao.getProductById(id);
    if (product == null) {
      throw StateError('Failed to load saved product');
    }
    return product;
  }

  Future<void> saveCandidateToCommunity(BarcodeLookupCandidate candidate) async {
    if (!ConnectivityService.instance.isOnline) return;

    final payload = {
      'barcode': candidate.barcode,
      'name_en': candidate.nameEn,
      'name_dari': candidate.nameDari,
      'manufacturer': candidate.manufacturer,
      'unit': candidate.unit,
      'categories_tags': candidate.categoriesTags,
      'source': candidate.source == BarcodeLookupSource.api ? 'api' : 'community',
      'updated_at': DateTime.now().toIso8601String(),
      // DO NOT STORE IMAGES.
      'image_url': null,
      'image_front_url': null,
    };

    try {
      await _supabase
          .from('community_products')
          .upsert(payload, onConflict: 'barcode', ignoreDuplicates: true);
    } catch (_) {
      // Non-blocking by design: never prevent user flow on community write failures.
    }
  }

  Future<BarcodeLookupCandidate?> _fetchFromCommunity(String barcode) async {
    try {
      final res = await _supabase
          .from('community_products')
          .select('barcode,name_en,name_dari,manufacturer,unit,categories_tags')
          .eq('barcode', barcode)
          .maybeSingle();

      if (res == null) return null;
      final map = Map<String, dynamic>.from(res);
      return _candidateFromCommunityMap(map);
    } catch (_) {
      return null;
    }
  }

  BarcodeLookupCandidate? _candidateFromCommunityMap(Map<String, dynamic> map) {
    final barcode = (map['barcode'] ?? '').toString().trim();
    final nameEn = (map['name_en'] ?? '').toString().trim();
    final nameDari = (map['name_dari'] ?? '').toString().trim();
    if (barcode.isEmpty || (nameEn.isEmpty && nameDari.isEmpty)) return null;

    final tagsRaw = map['categories_tags'];
    final tags = tagsRaw is List
        ? tagsRaw.map((e) => e.toString()).where((e) => e.isNotEmpty).toList()
        : <String>[];

    return BarcodeLookupCandidate(
      barcode: barcode,
      nameEn: nameEn,
      nameDari: nameDari.isEmpty ? nameEn : nameDari,
      quantityLabel: map['quantity']?.toString().trim().isEmpty == true ? null : map['quantity']?.toString().trim(),
      manufacturer: map['manufacturer']?.toString(),
      unit: _normalizeUnit(map['unit']?.toString()),
      categoriesTags: tags,
      source: BarcodeLookupSource.community,
    );
  }

  Future<BarcodeLookupCandidate?> _fetchFromApi(String barcode, {required bool beauty}) async {
    _configureSdkIfNeeded();

    final config = off.ProductQueryConfiguration(
      barcode,
      language: off.OpenFoodFactsLanguage.ENGLISH,
      fields: [
        off.ProductField.BARCODE,
        off.ProductField.NAME,
        off.ProductField.NAME_IN_LANGUAGES,
        off.ProductField.BRANDS,
        off.ProductField.QUANTITY,
        off.ProductField.CATEGORIES_TAGS,
      ],
      version: off.ProductQueryVersion.v3,
      productTypeFilter: beauty ? off.ProductTypeFilter(off.ProductType.beauty) : off.ProductTypeFilter(off.ProductType.food),
    );

    final uriHelper = beauty
        ? const off.UriProductHelper(domain: 'openbeautyfacts.org')
        : const off.UriProductHelper(domain: 'openfoodfacts.org');

    try {
      final result = await off.OpenFoodAPIClient.getProductV3(config, uriHelper: uriHelper)
          .timeout(const Duration(seconds: 10), onTimeout: off.ProductResultV3.new);
      final p = result.product;
      if (p == null) {
        return await _fetchFromApiHttpFallback(barcode, beauty: beauty);
      }

      final arName = _pickPreferredName(p.productNameInLanguages, preferredLocale: 'ar');
      final enName = _pickPreferredName(p.productNameInLanguages, preferredLocale: 'en');
      final productName = (p.productName ?? '').trim();
      final nameEn = enName?.trim().isNotEmpty == true
          ? enName!.trim()
          : (productName.isNotEmpty ? productName : _pickAnyName(p.productNameInLanguages) ?? '');
      if (nameEn.isEmpty) {
        return await _fetchFromApiHttpFallback(barcode, beauty: beauty);
      }
      final nameDari = arName?.trim().isNotEmpty == true ? arName!.trim() : nameEn;
      final tags = (p.categoriesTags ?? const <String>[]).map((e) => e.toString()).toList();

      return BarcodeLookupCandidate(
        barcode: barcode,
        nameEn: nameEn,
        nameDari: nameDari,
        quantityLabel: p.quantity?.trim().isEmpty == true ? null : p.quantity?.trim(),
        manufacturer: p.brands?.trim(),
        unit: _extractUnitFromQuantity(p.quantity),
        categoriesTags: tags,
        source: BarcodeLookupSource.api,
      );
    } catch (_) {
      return await _fetchFromApiHttpFallback(barcode, beauty: beauty);
    }
  }

  Future<BarcodeLookupCandidate?> _fetchFromApiHttpFallback(String barcode, {required bool beauty}) async {
    final hosts = beauty
        ? const ['world.openbeautyfacts.org', 'openbeautyfacts.org']
        : const ['world.openfoodfacts.org', 'openfoodfacts.org'];

    for (final host in hosts) {
      final v2 = Uri.https(host, '/api/v2/product/$barcode.json', {
        'fields': 'code,product_name,product_name_en,product_name_ar,quantity,brands,categories_tags,status',
      });
      final v0 = Uri.https(host, '/api/v0/product/$barcode.json');

      final jsonV2 = await _fetchJsonMap(v2);
      final parsedV2 = _parseOffJson(barcode, jsonV2);
      if (parsedV2 != null) return parsedV2;

      final jsonV0 = await _fetchJsonMap(v0);
      final parsedV0 = _parseOffJson(barcode, jsonV0);
      if (parsedV0 != null) return parsedV0;
    }

    return null;
  }

  Future<Map<String, dynamic>?> _fetchJsonMap(Uri uri) async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(uri).timeout(const Duration(seconds: 10));
      request.headers.set('user-agent', 'Hesabat/1.0 (mobile app)');
      request.headers.set('accept', 'application/json');

      final response = await request.close().timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        client.close(force: true);
        return null;
      }

      final body = await utf8.decodeStream(response);
      client.close(force: true);

      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  BarcodeLookupCandidate? _parseOffJson(String barcode, Map<String, dynamic>? json) {
    if (json == null) return null;

    final statusRaw = json['status'];
    final status = statusRaw is num ? statusRaw.toInt() : int.tryParse('$statusRaw') ?? 0;
    if (status != 1) return null;

    final productRaw = json['product'];
    if (productRaw is! Map) return null;
    final product = Map<String, dynamic>.from(productRaw);

    final nameEn = (product['product_name_en'] ?? product['product_name'] ?? '').toString().trim();
    final nameDari = (product['product_name_ar'] ?? nameEn).toString().trim();
    final fallbackName = (json['product_name'] ?? '').toString().trim();

    final resolvedEn = nameEn.isNotEmpty ? nameEn : (nameDari.isNotEmpty ? nameDari : fallbackName);
    final resolvedDari = nameDari.isNotEmpty ? nameDari : resolvedEn;
    if (resolvedEn.isEmpty && resolvedDari.isEmpty) return null;

    final quantity = product['quantity']?.toString();
    final brands = product['brands']?.toString().trim();
    final rawTags = product['categories_tags'];
    final tags = rawTags is List
        ? rawTags.map((e) => e.toString()).where((e) => e.isNotEmpty).toList()
        : <String>[];

    return BarcodeLookupCandidate(
      barcode: barcode,
      nameEn: resolvedEn,
      nameDari: resolvedDari,
      quantityLabel: quantity?.trim().isEmpty == true ? null : quantity?.trim(),
      manufacturer: brands?.isEmpty == true ? null : brands,
      unit: _extractUnitFromQuantity(quantity),
      categoriesTags: tags,
      source: BarcodeLookupSource.api,
    );
  }

  Future<String?> _guessCategoryId({
    required AppDatabase db,
    required String shopId,
    required List<String> categoriesTags,
  }) async {
    if (categoriesTags.isEmpty) return null;

    final categories = await (db.select(db.categories)..where((c) => c.shopId.equals(shopId))).get();
    if (categories.isEmpty) return null;

    final tokens = categoriesTags
        .map((t) => t.toLowerCase().replaceAll('en:', '').replaceAll('-', ' ').replaceAll('_', ' '))
        .toList();

    for (final c in categories) {
      final names = [c.nameEn, c.nameDari, c.namePashto]
          .whereType<String>()
          .map((e) => e.toLowerCase())
          .toList();
      final hit = tokens.any((t) => names.any((n) => t.contains(n) || n.contains(t)));
      if (hit) return c.id;
    }
    return null;
  }

  String _extractUnitFromQuantity(String? quantity) {
    if (quantity == null || quantity.trim().isEmpty) return 'piece';
    final normalized = quantity.toLowerCase().replaceAll(' ', '');

    final patterns = [
      RegExp(r'(kg|g|mg|l|ml|cl|oz|lb|pcs|pc|piece|tablet|tab|capsule|cap)$'),
      RegExp(r'(kg|g|mg|l|ml|cl|oz|lb|pcs|pc|piece|tablet|tab|capsule|cap)'),
    ];

    for (final p in patterns) {
      final m = p.firstMatch(normalized);
      if (m != null) return _normalizeUnit(m.group(1));
    }

    return 'piece';
  }

  String _normalizeUnit(String? raw) {
    final value = (raw ?? '').toLowerCase().trim();
    switch (value) {
      case 'kg':
      case 'g':
      case 'mg':
      case 'l':
      case 'ml':
      case 'cl':
      case 'oz':
      case 'lb':
        return value;
      case 'pc':
      case 'pcs':
      case 'piece':
        return 'piece';
      case 'tablet':
      case 'tab':
        return 'tablet';
      case 'capsule':
      case 'cap':
        return 'capsule';
      default:
        return 'piece';
    }
  }

  String? _pickPreferredName(dynamic namesMap, {required String preferredLocale}) {
    if (namesMap == null) return null;

    if (namesMap is Map<off.OpenFoodFactsLanguage, String>) {
      final byEnum = switch (preferredLocale) {
        'ar' => namesMap[off.OpenFoodFactsLanguage.ARABIC],
        'en' => namesMap[off.OpenFoodFactsLanguage.ENGLISH],
        _ => null,
      };
      if (byEnum != null && byEnum.trim().isNotEmpty) return byEnum;
    }

    if (namesMap is Map) {
      final preferred = namesMap[preferredLocale] ?? namesMap[preferredLocale.toUpperCase()];
      if (preferred is String && preferred.trim().isNotEmpty) return preferred;

      for (final entry in namesMap.entries) {
        final key = entry.key;
        final value = entry.value;
        if (value is! String || value.trim().isEmpty) continue;

        if (key is off.OpenFoodFactsLanguage) {
          if ((preferredLocale == 'ar' && key == off.OpenFoodFactsLanguage.ARABIC) ||
              (preferredLocale == 'en' && key == off.OpenFoodFactsLanguage.ENGLISH)) {
            return value;
          }
        }

        final k = key.toString().toLowerCase();
        if (k == preferredLocale) return value;
      }
    }

    return null;
  }

  String? _pickAnyName(dynamic namesMap) {
    if (namesMap is Map<off.OpenFoodFactsLanguage, String>) {
      for (final value in namesMap.values) {
        if (value.trim().isNotEmpty) return value.trim();
      }
      return null;
    }

    if (namesMap is Map) {
      for (final value in namesMap.values) {
        if (value is String && value.trim().isNotEmpty) return value.trim();
      }
    }

    return null;
  }

  String _normalizeBarcodeInput(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';

    // OpenFoodFacts barcodes are typically digits; users may paste with spaces/hyphens.
    final normalized = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
    return normalized;
  }
}
