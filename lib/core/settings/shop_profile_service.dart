import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShopProfile {
  final String shopId;
  final String shopName;
  final String shopType;
  final String city;
  final String? district;
  final String currency;
  final String subscriptionStatus;
  final DateTime? trialEndsAt;
  final DateTime? subscriptionEndsAt;

  const ShopProfile({
    required this.shopId,
    required this.shopName,
    required this.shopType,
    required this.city,
    this.district,
    required this.currency,
    required this.subscriptionStatus,
    this.trialEndsAt,
    this.subscriptionEndsAt,
  });

  bool get isSubscriptionActive {
    final now = DateTime.now();

    // Explicitly expired/blocked
    if (subscriptionStatus == 'expired' || subscriptionStatus == 'suspended') {
      return false;
    }

    // Paid plans (legacy: basic, new: active)
    if (subscriptionStatus == 'active' || subscriptionStatus == 'basic') {
      if (subscriptionEndsAt != null) {
        return subscriptionEndsAt!.isAfter(now);
      }
      return true;
    }

    // If in trial, check trial date
    if (subscriptionStatus == 'trial') {
      if (trialEndsAt != null) {
        return trialEndsAt!.isAfter(now);
      }
      return true;
    }

    // Unknown value: default to active to avoid unintended lockout
    return true;
  }

  bool get canWrite => isSubscriptionActive;

  Map<String, dynamic> toJson() => {
        'shopId': shopId,
        'shopName': shopName,
        'shopType': shopType,
        'city': city,
        'district': district,
        'currency': currency,
        'subscriptionStatus': subscriptionStatus,
        'trialEndsAt': trialEndsAt?.toIso8601String(),
        'subscriptionEndsAt': subscriptionEndsAt?.toIso8601String(),
      };

  factory ShopProfile.fromJson(Map<String, dynamic> json) => ShopProfile(
        shopId: (json['shopId'] ?? 'main_shop').toString(),
        shopName: (json['shopName'] ?? 'My Shop').toString(),
        shopType: (json['shopType'] ?? 'General Store').toString(),
        city: (json['city'] ?? 'Kabul').toString(),
        district: json['district']?.toString(),
        currency: (json['currency'] ?? 'AFN').toString(),
        subscriptionStatus: (json['subscriptionStatus'] ?? 'active').toString(),
        trialEndsAt: json['trialEndsAt'] != null ? DateTime.parse(json['trialEndsAt'].toString()) : null,
        subscriptionEndsAt: json['subscriptionEndsAt'] != null ? DateTime.parse(json['subscriptionEndsAt'].toString()) : null,
      );
}

class ShopProfileService {
  static const _storage = FlutterSecureStorage();
  static const _shopProfileKey = 'shop_profile_v1';
  static const _onboardingCompletedKey = 'onboarding_completed';

  /// ISSUE-10: Check if onboarding was completed
  static Future<bool> isOnboardingCompleted() async {
    final value = await _storage.read(key: _onboardingCompletedKey);
    return value == 'true';
  }

  /// ISSUE-10: Mark onboarding as completed
  static Future<void> setOnboardingCompleted() async {
    await _storage.write(key: _onboardingCompletedKey, value: 'true');
  }

  /// Clear onboarding flag (on sign-out)
  static Future<void> clearOnboardingFlag() async {
    await _storage.delete(key: _onboardingCompletedKey);
  }

  static Future<void> save(ShopProfile profile) async {
    await _storage.write(
      key: _shopProfileKey,
      value: jsonEncode(profile.toJson()),
    );
  }

  static Future<void> saveToCloud(SupabaseClient supabase, ShopProfile profile) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    // Map local shop type to DB constraint (accepts both display names and codes)
    final typeMap = {
      'Grocery': 'grocery',
      'Pharmacy': 'pharmacy',
      'Hardware': 'hardware',
      'Electronics': 'electronics',
      'Clothing': 'clothing',
      'Bakery': 'bakery',
      'Restaurant': 'restaurant',
      'General': 'general',
      'grocery': 'grocery',
      'pharmacy': 'pharmacy',
      'hardware': 'hardware',
      'electronics': 'electronics',
      'clothing': 'clothing',
      'bakery': 'bakery',
      'restaurant': 'restaurant',
      'general': 'general',
    };

    final dbShopType = typeMap[profile.shopType] ?? 'general';

    // ISSUE-09 fix: Never include 'id' in the data payload.
    // For INSERT, let Supabase generate the UUID via uuid_generate_v4().
    // For UPDATE, changing the PK would corrupt the record.
    final data = {
      'owner_id': user.id,
      'name': profile.shopName,
      'shop_type': dbShopType,
      'city': profile.city,
      'district': profile.district,
      'currency_pref': profile.currency,
      'subscription_status': profile.subscriptionStatus,
      'updated_at': DateTime.now().toIso8601String(),
    };

    try {
      // Primary path: update existing row by owner_id.
      final response = await supabase
          .from('shops')
          .select('id')
          .eq('owner_id', user.id)
          .maybeSingle();

      if (response != null && response['id'] != null) {
        // ISSUE-09 fix: Update without 'id' in payload
        await supabase.from('shops').update(data).eq('id', response['id']);

        // Update local profile with real Supabase UUID
        final realShopId = response['id'].toString();
        if (profile.shopId != realShopId) {
          final updatedProfile = ShopProfile(
            shopId: realShopId,
            shopName: profile.shopName,
            shopType: profile.shopType,
            city: profile.city,
            district: profile.district,
            currency: profile.currency,
            subscriptionStatus: profile.subscriptionStatus,
            trialEndsAt: profile.trialEndsAt,
            subscriptionEndsAt: profile.subscriptionEndsAt,
          );
          await save(updatedProfile);
        }
      } else {
        // ISSUE-02 fix: INSERT without 'id' — let Supabase auto-generate UUID
        final inserted = await supabase
            .from('shops')
            .insert(data)
            .select('id')
            .single();

        // Save the real UUID back to local profile
        final realShopId = inserted['id'].toString();
        final updatedProfile = ShopProfile(
          shopId: realShopId,
          shopName: profile.shopName,
          shopType: profile.shopType,
          city: profile.city,
          district: profile.district,
          currency: profile.currency,
          subscriptionStatus: profile.subscriptionStatus,
          trialEndsAt: profile.trialEndsAt,
          subscriptionEndsAt: profile.subscriptionEndsAt,
        );
        await save(updatedProfile);
      }
    } catch (e) {
      print('HESABAT: Error saving shop to cloud: $e');
    }
  }

  static Future<ShopProfile?> fetchFromCloud(SupabaseClient supabase) async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final data = await supabase
          .from('shops')
          .select()
          .eq('owner_id', user.id)
          .maybeSingle();

      if (data == null) return null;

      final profile = ShopProfile(
        shopId: data['id'].toString(),
        shopName: (data['name'] ?? 'My Shop').toString(),
        shopType: (data['shop_type'] ?? 'general').toString().capitalize(),
        city: (data['city'] ?? 'Kabul').toString(),
        district: data['district']?.toString(),
        currency: (data['currency_pref'] ?? 'AFN').toString(),
        subscriptionStatus: (data['subscription_status'] ?? 'trial').toString(),
        trialEndsAt: data['trial_ends_at'] != null ? DateTime.parse(data['trial_ends_at'].toString()) : null,
        subscriptionEndsAt: data['subscription_ends_at'] != null ? DateTime.parse(data['subscription_ends_at'].toString()) : null,
      );

      await save(profile);
      return profile;
    } catch (e) {
      print('HESABAT: Error fetching shop from cloud: $e');
      return null;
    }
  }

  static Future<ShopProfile?> load() async {
    final raw = await _storage.read(key: _shopProfileKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return ShopProfile.fromJson(decoded);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// ISSUE-12 fix: Load from local storage first, fall back to cloud if null.
  static Future<ShopProfile?> loadWithCloudFallback() async {
    final local = await load();
    if (local != null) return local;

    // Try cloud if authenticated
    try {
      final supabase = Supabase.instance.client;
      if (supabase.auth.currentUser != null) {
        return await fetchFromCloud(supabase);
      }
    } catch (e) {
      print('HESABAT: Cloud fallback failed: $e');
    }
    return null;
  }

  static Future<void> clear() async {
    await _storage.delete(key: _shopProfileKey);
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
