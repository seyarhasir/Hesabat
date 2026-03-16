import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  // Limits for guest mode
  static const int maxProducts = 10;
  
  /// Check if guest mode is currently active
  static Future<bool> isGuestMode() async {
    return false;
  }
  
  /// Activate guest mode
  static Future<void> activateGuestMode() async {
    // Guest mode is disabled.
  }
  
  /// Deactivate guest mode and clear data
  static Future<void> deactivateGuestMode() async {
    // Guest mode is disabled.
  }
  
  /// Get current product count in guest mode
  static Future<int> getProductsCount() async {
    return 0;
  }
  
  /// Increment product count
  static Future<bool> canAddProduct() async {
    return true;
  }
  
  static Future<void> incrementProductCount() async {
    // Guest mode is disabled.
  }
  
  /// Get current sales count in guest mode
  static Future<int> getSalesCount() async {
    return 0;
  }
  
  /// Check if can add sale
  static Future<bool> canAddSale() async {
    return true;
  }
  
  static Future<void> incrementSalesCount() async {
    // Guest mode is disabled.
  }
  
  /// Get remaining limits for display
  static Future<Map<String, int>> getRemainingLimits() async {
    return {
      'productsRemaining': -1,
      'salesRemaining': -1,
    };
  }
  
  /// Check if feature is available in guest mode
  static bool isFeatureAvailable(String feature) {
    const disabledFeatures = ['sync', 'whatsapp', 'cloud_backup', 'multi_device'];
    return !disabledFeatures.contains(feature);
  }
}
