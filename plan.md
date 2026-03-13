# UI/UX Overhaul Plan — Hesabat

## Code Review Findings

### What's Working Correctly
- Project structure follows PRD section 9.1 properly
- Database schema (Drift tables, DAOs) is well-defined with proper UUID generation, foreign keys, sync_status columns
- Supabase migrations (001-006) and Edge Functions (4) are ready for deployment
- Auth flow logic (guest mode + OTP) is correctly structured
- Onboarding wizard (4 screens) has proper step progression
- Localization files (en, fa, ps) exist with ARB format
- SQLCipher encryption is configured via custom override package
- Riverpod providers are set up correctly

### Issues Found
1. **Dark theme is a stub** — `darkTheme` just returns `lightTheme`
2. **Deprecated APIs** — `ColorScheme.light()` uses deprecated `background`/`onBackground` params
3. **No bottom navigation** — Home screen uses a 2x3 grid instead of proper tab-based navigation
4. **Hardcoded colors everywhere** — Screens use `AppColors.xxx` directly instead of `Theme.of(context).colorScheme`
5. **`withOpacity()` usage** — Should use `Color.withValues()` or explicit alpha in newer Flutter
6. **Splash screen blocks for 2 seconds** — Fixed delay regardless of auth state check speed
7. **No font family specified** — Uses system default, should use Open Sans as the CSS variables suggest
8. **AppButton is always full-width by default** — `isFullWidth` defaults to `false` but every usage wraps it in full width context
9. **Home screen grid cards have shadows/borders** — User wants clean, flat, no shadows

---

## Implementation Plan

### Step 1: Rewrite `app_colors.dart` with your color tokens

Map the CSS variables to Flutter colors — both light and dark:

**Light theme colors:**
- `primary`: `#1E9DF1` (bright blue, Twitter-like)
- `background`: `#FFFFFF` (pure white)
- `surface/card`: `#F7F8F8`
- `foreground/textPrimary`: `#0F1419`
- `textSecondary/muted`: `#0F1419` (light), `#72767A` (dark)
- `border`: `#E1EAEF`
- `accent`: `#E3ECF6`
- `destructive`: `#F4212E`
- `success/chart-2`: `#00B87A`
- `warning/chart-3`: `#F7B928`
- `input`: `#F7F9FA`

**Dark theme colors:**
- `primary`: `#1C9CF0`
- `background`: `#000000`
- `surface/card`: `#17181C`
- `foreground`: `#E7E9EA`
- `textSecondary/muted`: `#72767A`
- `border`: `#242628`
- `accent`: `#061622`
- `destructive`: `#F4212E`
- `input`: `#22303C`

### Step 2: Rewrite `app_theme.dart` with proper light + dark themes

- Remove all gradients and shadows (elevation: 0 everywhere)
- Set `borderRadius` to `1.3rem` = ~20.8px (use 20)
- Use `ColorScheme.fromSeed` or explicit `ColorScheme` without deprecated params
- AppBar: transparent background, surface-colored, no shadow
- Cards: no elevation, thin border instead
- Buttons: flat, no elevation, rounded 20px
- BottomNavigationBar: clean, no elevation, thin top border
- Input fields: filled with `input` color, thin border
- Add `fontFamily: 'Open Sans'` (or keep system default if you don't want to bundle the font)

### Step 3: Rewrite `app_button.dart`

- Remove all shadow/elevation
- Use theme colors from `Theme.of(context)` instead of hardcoded `AppColors`
- Consistent border radius (20px)
- Clean, flat appearance
- Make full-width by default (used everywhere as full-width)

### Step 4: Rewrite `app_text_field.dart`

- Use `input` background color (`#F7F9FA` light / `#22303C` dark)
- Thin border, 20px radius
- No shadow
- Use theme colors

### Step 5: Redesign `home_screen.dart` with Bottom Navigation

Replace the current grid layout with a proper `Scaffold` + `BottomNavigationBar`:

**Bottom nav tabs (5 tabs):**
1. Home (dashboard summary)
2. Sales (new sale + history)
3. Inventory (products)
4. Qarz (debts)
5. Settings

**Home tab content:**
- Clean greeting header
- Today's summary cards (Total Sales, Outstanding Debts, Low Stock) — simple, flat cards with just numbers
- Quick action row (New Sale, Add Product) as prominent buttons
- Recent activity list

### Step 6: Redesign `splash_screen.dart`

- Clean white/black background (matches theme mode)
- Simple app icon + name, no gradient background
- Minimal loading indicator

### Step 7: Redesign `auth_selection_screen.dart`

- Clean layout with proper spacing
- Flat buttons, no colored containers with borders
- Use accent background for info box, not warning

### Step 8: Redesign onboarding screens

- Consistent clean styling across all 4 steps
- Progress bar using primary color on muted track
- Flat selection cards with subtle border
- No shadows or gradients

### Step 9: Update `demo_banner.dart`

- Remove box shadow
- Use accent color background instead of warning
- Cleaner, slimmer design

### Step 10: Update all remaining shared widgets

- `sync_status_bar.dart` — flat, clean
- `currency_display.dart` — use theme colors
- `debt_badge.dart` — use theme colors
- `product_card.dart` — flat, no shadow, thin border
- `customer_list_tile.dart` — use theme colors

---

## Files to modify (in order):

1. `lib/shared/theme/app_colors.dart` — Full rewrite with light/dark color sets
2. `lib/shared/theme/app_theme.dart` — Full rewrite with light + dark theme, no shadows
3. `lib/shared/widgets/app_button.dart` — Flat, clean, theme-aware
4. `lib/shared/widgets/app_text_field.dart` — Use theme colors, flat
5. `lib/shared/widgets/demo_banner.dart` — Remove shadow, cleaner
6. `lib/shared/widgets/sync_status_bar.dart` — Theme-aware
7. `lib/shared/widgets/currency_display.dart` — Theme-aware
8. `lib/shared/widgets/debt_badge.dart` — Theme-aware
9. `lib/shared/widgets/product_card.dart` — Flat, no shadow
10. `lib/shared/widgets/customer_list_tile.dart` — Theme-aware
11. `lib/features/auth/screens/splash_screen.dart` — Clean design
12. `lib/features/auth/screens/auth_selection_screen.dart` — Clean design
13. `lib/features/auth/screens/phone_input_screen.dart` — Clean design
14. `lib/features/auth/screens/otp_verification_screen.dart` — Clean design
15. `lib/features/onboarding/screens/language_selection_screen.dart` — Clean design
16. `lib/features/onboarding/screens/shop_setup_screen.dart` — Clean design
17. `lib/features/onboarding/screens/currency_preference_screen.dart` — Clean design
18. `lib/features/onboarding/screens/first_product_screen.dart` — Clean design
19. `lib/features/home/screens/home_screen.dart` — Full redesign with bottom nav
20. `lib/main.dart` — Update theme mode handling, add bottom nav shell route
