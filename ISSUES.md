# Hesabat — Data Layer Issues Report

> Researched by reading every screen in the auth/onboarding/settings flow plus all service/provider files.
> Each issue is tagged with severity: 🔴 Critical | 🟠 High | 🟡 Medium | 🔵 Low

---

## Table of Contents
1. [Data Flow Overview](#data-flow-overview)
2. [Layer-by-Layer Analysis](#layer-by-layer-analysis)
3. [Issues List](#issues-list)
4. [Root Cause Summary](#root-cause-summary)

---

## Data Flow Overview

```
App Start
  └─ SplashScreen
       ├─ [authenticated] → /home  (loads profile from LOCAL only)
       └─ [not authenticated] → /onboarding/language

Onboarding Flow (first time)
  language_selection_screen → /auth/phone
  phone_input_screen → /auth/otp
  otp_verification_screen
       ├─ [shop exists in Supabase by owner_id] → /home
       └─ [no shop] → /onboarding/shop-setup
            shop_setup_screen (collects shopName, shopType)
            city_district_screen (collects city, district)
            currency_preference_screen (collects currency)
            first_product_screen → _completeSetup() → /home

Sign Out
  settings_screen._signOut()
    → authProvider.signOut() → auth_service.clearAuth()
    → ShopProfileService.clear()
    → navigate to /auth
```

---

## Layer-by-Layer Analysis

### Layer 1: Supabase (Cloud DB)

| Table | Status | Notes |
|-------|--------|-------|
| `shops` | ✅ Schema OK | `id` is UUID, `owner_id` FK to `auth.users` |
| `admin_created_accounts` | ⚠️ Underused | Has `shop_id` FK but app never reads it |
| All other tables | ✅ OK | Properly reference `shop_id` as UUID |

**Key fact**: The `shops` table uses `uuid_generate_v4()` for `id`. Any non-UUID string inserted as `id` will fail with a PostgreSQL type error.

---

### Layer 2: ShopProfileService (Local Secure Storage)

**Storage key**: `shop_profile_v1` in `FlutterSecureStorage`

| Method | Status | Notes |
|--------|--------|-------|
| `save()` | ✅ OK | Saves JSON to secure storage |
| `load()` | ✅ OK | Reads and parses JSON |
| `clear()` | ✅ OK | Deletes key |
| `fetchFromCloud()` | ⚠️ Issue | Fetches by `owner_id` — fails if owner_id mismatch |
| `saveToCloud()` | 🔴 Critical | Sends local non-UUID `id` in payload; silently fails |

---

### Layer 3: AuthService (Auth + Session)

| Method | Status | Notes |
|--------|--------|-------|
| `getCurrentMode()` | ✅ OK | Checks session/storage |
| `signInWithPhone()` | ✅ OK | Calls edge function |
| `verifyOtp()` | 🟠 Issue | Calls `fetchFromCloud()` but result not used to set `currentShopIdProvider` |
| `_ensureSupabaseSession()` | 🔴 Critical | Creates NEW auth user — UUID differs from admin-set `owner_id` |
| `clearAuth()` | 🟡 Issue | Deletes shop profile key (redundant with `ShopProfileService.clear()`) |

---

### Layer 4: currentShopIdProvider (In-Memory State)

**Default value**: `'demo_shop'`

| Where it's set | Status | Notes |
|----------------|--------|-------|
| `splash_screen.dart` | ✅ Set from local profile | Only if local profile exists |
| `first_product_screen.dart` | 🔴 Wrong value | Set to local generated ID, not Supabase UUID |
| `otp_verification_screen.dart` | 🔴 Never set | After sign-in, stays as `'demo_shop'` |
| `auth_service.verifyOtp()` | 🔴 Never set | `fetchFromCloud()` result not used |

---

### Layer 5: Onboarding Screens

| Screen | Data Saved | Layer | Status |
|--------|-----------|-------|--------|
| `language_selection_screen` | Language preference | SharedPreferences (via provider) | ✅ OK |
| `shop_setup_screen` | shopName, shopType | Route arguments only (in-memory) | ✅ OK |
| `city_district_screen` | city, district | Route arguments only (in-memory) | ✅ OK |
| `currency_preference_screen` | currency | Route arguments only (in-memory) | ✅ OK |
| `first_product_screen` | Full profile | Local + Cloud | 🔴 Multiple issues |

---

### Layer 6: Settings & Home Screens

| Screen | How it reads shop data | Status |
|--------|----------------------|--------|
| `settings_screen.dart` | `FutureBuilder(ShopProfileService.load())` | 🟡 No refresh, no cloud fallback |
| `home_screen.dart` AppBar | `FutureBuilder(ShopProfileService.load())` | 🟡 No refresh, no cloud fallback |
| `home_screen.dart` dashboard | `ref.watch(currentShopIdProvider)` | 🔴 Uses `'demo_shop'` after sign-in |
| `subscription_screen.dart` | `FutureBuilder(ShopProfileService.load())` | 🟡 No refresh, no cloud fallback |

---

## Issues List

---

### 🔴 ISSUE-01 — `_ensureSupabaseSession` Creates New Auth User With Different UUID

**File**: `lib/core/auth/auth_service.dart` → `_ensureSupabaseSession()`  
**Severity**: Critical  
**Symptom**: User sees onboarding again on every sign-in after sign-out

**What happens**:
1. Admin creates a shop in Supabase with `owner_id = "3e96d7c5-..."` (a pre-set UUID)
2. User signs in for the first time
3. `_ensureSupabaseSession()` tries to sign in with email/password — fails (no auth user yet)
4. It then calls `supabase.auth.signUp()` which creates a **brand new** auth user with a **new UUID** (e.g., `"a1b2c3d4-..."`)
5. `otp_verification_screen.dart` checks: `shops.select('id').eq('owner_id', user.id)` using the **new UUID**
6. No shop found → `hasShop = false` → user is sent to onboarding again

**The mismatch**:
```
Admin-created shop:  owner_id = "3e96d7c5-3df1-4292-a17e-dc49a165f8c1"
New auth user:       id       = "<some new UUID>"   ← DIFFERENT!
```

**Why onboarding shows again on 2nd sign-in**:
- After onboarding, `saveToCloud()` tries to INSERT a shop but fails (see ISSUE-02)
- No shop is ever saved with the new auth user's `owner_id`
- On next sign-in, shop check still returns nothing → onboarding again

---

### 🔴 ISSUE-02 — `saveToCloud()` Sends Non-UUID `id` in Payload, Silently Fails

**File**: `lib/core/settings/shop_profile_service.dart` → `saveToCloud()`  
**Severity**: Critical  
**Symptom**: Shop data never actually saved to Supabase after onboarding

**What happens**:
```dart
// first_product_screen.dart generates a local string ID:
final shopId = 'shop_${normalized}';  // e.g. "shop_otp_test_shop_772654965"

// saveToCloud() sends this in the data payload:
final data = {
  'id': profile.shopId,  // ← "shop_otp_test_shop_772654965" (NOT a UUID!)
  'owner_id': user.id,
  ...
};

// If no existing shop found → INSERT:
await supabase.from('shops').insert(data);
// ❌ FAILS: PostgreSQL rejects non-UUID for uuid column
// Error is caught silently by try/catch → no shop saved
```

**For the UPDATE path** (when shop already exists):
```dart
await supabase.from('shops').update(data).eq('id', response['id']);
// data includes 'id': 'shop_otp_test_shop_772654965'
// This tries to change the UUID primary key to a string → fails or corrupts
```

**Result**: The entire `saveToCloud()` call silently fails. No data reaches Supabase.

---

### 🔴 ISSUE-03 — `currentShopIdProvider` Never Updated After Sign-In

**File**: `lib/features/auth/screens/otp_verification_screen.dart`  
**Severity**: Critical  
**Symptom**: Home screen dashboard shows no data (uses `'demo_shop'` as shopId)

**What happens**:
- `currentShopIdProvider` defaults to `'demo_shop'`
- After sign-in, the provider is **never updated** to the real shop UUID
- All DB queries in `home_screen.dart` use `ref.watch(currentShopIdProvider)` → `'demo_shop'`
- No sales, debts, or products are found because they're stored under the real shop UUID

**Where it IS set correctly**:
- `splash_screen.dart`: sets it from local profile (only works if local profile exists)
- `first_product_screen.dart`: sets it to the **wrong** local ID (see ISSUE-04)

**Where it is MISSING**:
- `otp_verification_screen.dart`: after successful sign-in, never sets the provider
- `auth_service.verifyOtp()`: calls `fetchFromCloud()` but never uses the result to set the provider

---

### 🔴 ISSUE-04 — Onboarding Creates Wrong Local `shopId` (Not Supabase UUID)

**File**: `lib/features/onboarding/screens/first_product_screen.dart` → `_completeSetup()`  
**Severity**: Critical  
**Symptom**: Local data and cloud data use different IDs; sync is broken

**What happens**:
```dart
// Generates a human-readable local ID:
final normalized = shopName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
final shopId = 'shop_${normalized}';  // e.g. "shop_ahmad_grocery"

// Saves profile locally with this ID:
await ShopProfileService.save(profile);  // shopId = "shop_ahmad_grocery"

// Sets the provider to this wrong ID:
ref.read(currentShopIdProvider.notifier).state = shopId;  // "shop_ahmad_grocery"
```

**The real Supabase shop ID is**: `"6d5b7fc2-ec17-408e-8b43-764479fdfac0"` (UUID)

**Cascading impact**:
- All local SQLite records (sales, products, debts) are created with `shop_id = "shop_ahmad_grocery"`
- Supabase expects `shop_id` to be a UUID FK → sync fails for all records
- After sign-out and sign-in, `fetchFromCloud()` returns the real UUID, creating a mismatch with existing local data

---

### 🔴 ISSUE-05 — `subscriptionStatus` Hardcoded to `'active'` During Onboarding

**File**: `lib/features/onboarding/screens/first_product_screen.dart` → `_completeSetup()`  
**Severity**: Critical  
**Symptom**: Settings shows wrong subscription status; subscription gating doesn't work

**What happens**:
```dart
final profile = ShopProfile(
  ...
  subscriptionStatus: 'active',  // ← HARDCODED! Real value is 'trial'
);
```

**Real Supabase data**:
```json
{ "subscription_status": "trial" }
```

**Impact**:
- `profile.isSubscriptionActive` returns `true` (no expiry check for 'active' without `subscriptionEndsAt`)
- User appears to have unlimited access even if trial has expired
- `trial_ends_at` from Supabase is never loaded into local profile

---

### 🟠 ISSUE-06 — `splash_screen.dart` Never Fetches From Cloud When Authenticated

**File**: `lib/features/auth/screens/splash_screen.dart` → `_checkAuthAndNavigate()`  
**Severity**: High  
**Symptom**: After sign-out/sign-in, settings shows stale or empty data

**What happens**:
```dart
final profile = await ShopProfileService.load();  // LOCAL ONLY
if (profile != null) {
  ref.read(currentShopIdProvider.notifier).state = profile.shopId;
}
// Never calls ShopProfileService.fetchFromCloud() even when authenticated
```

**Expected behavior**: When authenticated and local profile is missing or stale, fetch from cloud.

---

### 🟠 ISSUE-07 — `otp_verification_screen.dart` Doesn't Load Profile Before Navigating to `/home`

**File**: `lib/features/auth/screens/otp_verification_screen.dart`  
**Severity**: High  
**Symptom**: Home screen has no shop name, no data, uses `'demo_shop'` shopId

**What happens**:
```dart
// auth_service.verifyOtp() calls fetchFromCloud() internally
// But otp_verification_screen never:
// 1. Reads the fetched profile
// 2. Sets currentShopIdProvider
// 3. Waits for profile to be available before navigating

Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
// ← Navigates immediately without ensuring profile/shopId is ready
```

---

### 🟠 ISSUE-08 — `admin_created_accounts.shop_id` Never Used for Shop Lookup

**File**: `lib/features/auth/screens/otp_verification_screen.dart`, `lib/core/auth/auth_service.dart`  
**Severity**: High  
**Symptom**: Shop lookup fails even though admin linked the account to a shop

**What happens**:
- Admin creates account in `admin_created_accounts` with `shop_id = "6d5b7fc2-..."`
- App never reads `admin_created_accounts.shop_id` to find the user's shop
- Instead, app looks up shop by `owner_id` (auth user UUID) which may not match

**The correct approach**: After verifying passcode, look up `admin_created_accounts` to get the `shop_id`, then use that to load the shop profile.

---

### 🟠 ISSUE-09 — `saveToCloud()` UPDATE Path Includes `id` Field in Payload

**File**: `lib/core/settings/shop_profile_service.dart` → `saveToCloud()`  
**Severity**: High  
**Symptom**: Update silently fails or corrupts the shop record

**What happens**:
```dart
final data = {
  'id': profile.shopId,  // ← Should NOT be in update payload
  'owner_id': user.id,
  'name': profile.shopName,
  ...
};
await supabase.from('shops').update(data).eq('id', response['id']);
// Tries to change the primary key UUID to a local string → error
```

**Fix**: Remove `'id'` from the `data` map when doing an UPDATE.

---

### 🟠 ISSUE-10 — No "Onboarding Completed" Flag

**File**: Entire onboarding flow  
**Severity**: High  
**Symptom**: If cloud save fails, user sees onboarding on every sign-in

**What happens**:
- The only check for "has user completed onboarding" is: does a shop exist in Supabase?
- If `saveToCloud()` fails (see ISSUE-02), no shop is saved
- Every sign-in → `hasShop = false` → onboarding shown again
- User fills onboarding repeatedly but data never persists

**Fix**: Store an `onboarding_completed` flag in local secure storage. Even if cloud save fails, the flag prevents re-showing onboarding.

---

### 🟡 ISSUE-11 — `clearAuth()` Deletes Shop Profile (Double-Delete)

**File**: `lib/core/auth/auth_service.dart` → `clearAuth()`  
**Severity**: Medium  
**Symptom**: Minor redundancy; profile deleted twice on sign-out

**What happens**:
```dart
// In auth_service.clearAuth():
await _storage.delete(key: _shopProfileKey);  // ← deletes profile

// In settings_screen._signOut():
await ShopProfileService.clear();  // ← also deletes profile
```

Both use the same key `'shop_profile_v1'`. The double-delete is harmless but indicates the responsibility is unclear. More importantly, `clearAuth()` should NOT be responsible for deleting the shop profile — that's `ShopProfileService`'s job.

---

### 🟡 ISSUE-12 — Settings/Home/Subscription Screens Use `FutureBuilder` Without Cloud Fallback

**Files**:  
- `lib/features/settings/screens/settings_screen.dart`  
- `lib/features/home/screens/home_screen.dart`  
- `lib/features/settings/screens/subscription_screen.dart`  
**Severity**: Medium  
**Symptom**: Screens show hardcoded fallback values (`'My Shop'`, `'General Store'`) when local profile is missing

**What happens**:
```dart
FutureBuilder<ShopProfile?>(
  future: ShopProfileService.load(),  // LOCAL ONLY
  builder: (context, snapshot) {
    final profile = snapshot.data;
    final shopName = profile?.shopName?.isNotEmpty == true
        ? profile!.shopName
        : 'My Shop';  // ← hardcoded fallback shown when profile is null
  },
)
```

**Fix**: If local profile is null and user is authenticated, fetch from cloud before showing fallback.

---

### 🟡 ISSUE-13 — `shop_setup_screen.dart` Passes Display Name as `shopType` (Not Code)

**File**: `lib/features/onboarding/screens/shop_setup_screen.dart`  
**Severity**: Medium  
**Symptom**: Fragile type mapping; could break if display names change

**What happens**:
```dart
// Passes the display name 'General' not the code 'general':
arguments: {
  'shopName': _shopNameController.text.trim(),
  'shopType': _shopTypes.firstWhere(...)['name'] ?? 'General',  // 'General' not 'general'
}

// saveToCloud() then maps it:
final typeMap = {
  'General': 'general',  // works only because keys match display names exactly
  ...
};
```

Works currently but is fragile. Should pass the `code` field directly.

---

### 🔵 ISSUE-14 — `home_screen.dart` Has Unused `_handleLogout` Method

**File**: `lib/features/home/screens/home_screen.dart`  
**Severity**: Low  
**Symptom**: Dead code; logout in home screen is never triggered

**What happens**: `_handleLogout()` is defined but never called. Sign-out is only accessible from Settings screen.

---

### 🔵 ISSUE-15 — `language_selection_screen.dart` Routes to `/auth/phone` (Bypasses Returning Users)

**File**: `lib/features/onboarding/screens/language_selection_screen.dart`  
**Severity**: Low  
**Symptom**: Returning users who are not authenticated must go through language selection again

**What happens**:
- After sign-out, `splash_screen.dart` routes to `/onboarding/language`
- User must re-select language before they can sign in
- Language preference is already saved — this step is unnecessary for returning users

---

## Root Cause Summary

The two bugs the user reported trace back to **three root causes**:

### Bug 1: "Settings shows hardcoded data after onboarding"
**Root causes**: ISSUE-02 + ISSUE-04 + ISSUE-05
- `saveToCloud()` silently fails (non-UUID id)
- Local profile has wrong shopId and hardcoded 'active' status
- Screens fall back to hardcoded strings when profile is wrong

### Bug 2: "Onboarding shows again after sign-out and sign-in"
**Root causes**: ISSUE-01 + ISSUE-02 + ISSUE-10
- New auth user UUID ≠ admin-set `owner_id` in shops table
- `saveToCloud()` fails → no shop ever saved under new auth user's UUID
- No local "onboarding completed" flag to prevent re-showing

### The Core Architectural Problem
The app was designed assuming the user creates their own shop during onboarding. But the actual flow is:
- **Admin pre-creates** the shop in Supabase with a specific `owner_id`
- **User signs in** and gets a new Supabase auth UUID that doesn't match `owner_id`
- The `admin_created_accounts` table has a `shop_id` field that links account → shop, but **the app never reads it**

The fix requires using `admin_created_accounts.shop_id` to look up the shop after authentication, instead of relying on `shops.owner_id` matching the auth user's UUID.

---

## Files That Need Changes (When Fixing)

| File | Issues | Priority |
|------|--------|----------|
| `lib/core/auth/auth_service.dart` | ISSUE-01, ISSUE-08, ISSUE-11 | 🔴 Fix first |
| `lib/features/auth/screens/otp_verification_screen.dart` | ISSUE-03, ISSUE-07, ISSUE-08 | 🔴 Fix first |
| `lib/core/settings/shop_profile_service.dart` | ISSUE-02, ISSUE-09 | 🔴 Fix first |
| `lib/features/onboarding/screens/first_product_screen.dart` | ISSUE-04, ISSUE-05 | 🔴 Fix first |
| `lib/features/auth/screens/splash_screen.dart` | ISSUE-06 | 🟠 Fix second |
| `lib/features/settings/screens/settings_screen.dart` | ISSUE-12 | 🟡 Fix third |
| `lib/features/home/screens/home_screen.dart` | ISSUE-03, ISSUE-12 | 🟡 Fix third |
| `lib/features/settings/screens/subscription_screen.dart` | ISSUE-12 | 🟡 Fix third |
| `lib/features/onboarding/screens/shop_setup_screen.dart` | ISSUE-13 | 🔵 Nice to have |

---
