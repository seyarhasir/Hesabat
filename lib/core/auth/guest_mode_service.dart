import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Provider for guest mode state
final guestModeServiceProvider = StateNotifierProvider<GuestModeNotifier, GuestModeState>((ref) {
  return GuestModeNotifier();
});

/// Guest mode state
class GuestModeState {
  final bool isGuest;
  final int productCount;
  final int maxProducts;
  final bool hasReachedProductLimit;

  const GuestModeState({
    this.isGuest = false,
    this.productCount = 0,
    this.maxProducts = 10,
    this.hasReachedProductLimit = false,
  });

  GuestModeState copyWith({
    bool? isGuest,
    int? productCount,
    int? maxProducts,
    bool? hasReachedProductLimit,
  }) {
    return GuestModeState(
      isGuest: isGuest ?? this.isGuest,
      productCount: productCount ?? this.productCount,
      maxProducts: maxProducts ?? this.maxProducts,
      hasReachedProductLimit: hasReachedProductLimit ?? this.hasReachedProductLimit,
    );
  }
}

/// Guest mode notifier
class GuestModeNotifier extends StateNotifier<GuestModeState> {
  GuestModeNotifier() : super(const GuestModeState()) {
    _loadState();
  }

  Future<void> _loadState() async {
    final isGuest = await GuestModeService.isGuestMode();
    final productCount = await GuestModeService.getProductsCount();
    state = GuestModeState(
      isGuest: isGuest,
      productCount: productCount,
      maxProducts: GuestModeService.maxProducts,
      hasReachedProductLimit: productCount >= GuestModeService.maxProducts,
    );
  }

  Future<void> refresh() async {
    await _loadState();
  }

  Future<void> activate() async {
    await GuestModeService.activateGuestMode();
    await _loadState();
  }

  Future<void> deactivate() async {
    await GuestModeService.deactivateGuestMode();
    await _loadState();
  }

  Future<bool> canAddProduct() async {
    return await GuestModeService.canAddProduct();
  }

  Future<void> incrementProduct() async {
    await GuestModeService.incrementProductCount();
    await _loadState();
  }
}

/// Guest mode for testing - limited features, local-only storage
class GuestModeService {
  static const _storage = FlutterSecureStorage();
  static const _guestModeKey = 'guest_mode_active';
  static const _guestProductsCountKey = 'guest_products_count';
  static const _guestSalesCountKey = 'guest_sales_count';
  
  // Limits for guest mode
  static const int maxProducts = 10;
  static const int maxSales = 5;
  
  /// Check if guest mode is currently active
  static Future<bool> isGuestMode() async {
    try {
      final value = await _storage.read(key: _guestModeKey).timeout(const Duration(seconds: 2));
      return value == 'true';
    } catch (_) {
      return false; // Default to not guest if it hangs
    }
  }
  
  /// Activate guest mode
  static Future<void> activateGuestMode() async {
    await _storage.write(key: _guestModeKey, value: 'true');
    await _storage.write(key: _guestProductsCountKey, value: '0');
    await _storage.write(key: _guestSalesCountKey, value: '0');
  }
  
  /// Deactivate guest mode and clear data
  static Future<void> deactivateGuestMode() async {
    await _storage.delete(key: _guestModeKey);
    await _storage.delete(key: _guestProductsCountKey);
    await _storage.delete(key: _guestSalesCountKey);
  }
  
  /// Get current product count in guest mode
  static Future<int> getProductsCount() async {
    try {
      final value = await _storage.read(key: _guestProductsCountKey).timeout(const Duration(seconds: 2));
      return int.tryParse(value ?? '0') ?? 0;
    } catch (_) {
      return 0;
    }
  }
  
  /// Increment product count
  static Future<bool> canAddProduct() async {
    if (!await isGuestMode()) return true;
    final current = await getProductsCount();
    return current < maxProducts;
  }
  
  static Future<void> incrementProductCount() async {
    if (!await isGuestMode()) return;
    final current = await getProductsCount();
    await _storage.write(key: _guestProductsCountKey, value: '${current + 1}');
  }
  
  /// Get current sales count in guest mode
  static Future<int> getSalesCount() async {
    try {
      final value = await _storage.read(key: _guestSalesCountKey).timeout(const Duration(seconds: 2));
      return int.tryParse(value ?? '0') ?? 0;
    } catch (_) {
      return 0;
    }
  }
  
  /// Check if can add sale
  static Future<bool> canAddSale() async {
    if (!await isGuestMode()) return true;
    final current = await getSalesCount();
    return current < maxSales;
  }
  
  static Future<void> incrementSalesCount() async {
    if (!await isGuestMode()) return;
    final current = await getSalesCount();
    await _storage.write(key: _guestSalesCountKey, value: '${current + 1}');
  }
  
  /// Get remaining limits for display
  static Future<Map<String, int>> getRemainingLimits() async {
    if (!await isGuestMode()) {
      return {
        'productsRemaining': -1,
        'salesRemaining': -1,
      };
    }
    final productsUsed = await getProductsCount();
    final salesUsed = await getSalesCount();
    return {
      'productsRemaining': maxProducts - productsUsed,
      'salesRemaining': maxSales - salesUsed,
    };
  }
  
  /// Check if feature is available in guest mode
  static bool isFeatureAvailable(String feature) {
    const disabledFeatures = ['sync', 'whatsapp', 'cloud_backup', 'multi_device'];
    return !disabledFeatures.contains(feature);
  }
}
