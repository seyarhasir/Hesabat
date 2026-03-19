import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shop_profile_service.dart';
import '../utils/exchange_rate_service.dart';

class CurrencyPreferenceNotifier extends StateNotifier<String> {
  CurrencyPreferenceNotifier() : super('AFN') {
    load();
  }

  Future<void> load() async {
    final profile = await ShopProfileService.load();
    if (profile != null) {
      state = profile.currency;
    }
  }

  Future<void> setCurrency(String code) async {
    if (state == code) return;
    state = code;
    
    final profile = await ShopProfileService.load();
    if (profile != null) {
      final updated = ShopProfile(
        shopId: profile.shopId,
        shopName: profile.shopName,
        shopType: profile.shopType,
        city: profile.city,
        district: profile.district,
        currency: code,
        subscriptionStatus: profile.subscriptionStatus,
        trialEndsAt: profile.trialEndsAt,
        subscriptionEndsAt: profile.subscriptionEndsAt,
      );
      await ShopProfileService.save(updated);
    }
  }
}

final currencyPreferenceProvider = StateNotifierProvider<CurrencyPreferenceNotifier, String>((ref) {
  return CurrencyPreferenceNotifier();
});

final exchangeRateSnapshotProvider = FutureProvider<ExchangeRateSnapshot>((ref) async {
  // Accessing instance directly is fine as it's a singleton, 
  // but we want this to be reactive if we ever add a 'refresh' mechanism.
  return await ExchangeRateService.instance.getLatestSnapshot(preferFresh: false);
});
