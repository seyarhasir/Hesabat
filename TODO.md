# Hesabat — Development Todo List (0 to 100)
## Afghanistan's First Offline-First Business Management App

---

## PHASE 0: FOUNDATION (Steps 0-10)

### Step 0: Project Initialization & Planning
- [x] Create project directory structure following PRD section 9.1
- [x] Initialize Flutter project with `flutter create hesabat --org com.hesabat`
- [x] Set up Git repository with `.gitignore` for Flutter/Supabase
- [ ] Create `README.md` with project overview and setup instructions
- [x] Define minimum SDK versions (Android 8.0 / iOS 14.0)
- [ ] Create `analysis_options.yaml` with strict linting rules
- [ ] Set up VS Code workspace settings and extensions recommendations

### Step 1: Supabase Project Setup ($0 Infrastructure)
- [ ] Create Supabase free tier account
- [ ] Create new Supabase project (note project reference ID)
- [ ] Enable Row Level Security (RLS) on all future tables
- [ ] Set up UptimeRobot monitor to prevent project pausing (ping every 5 min)
- [ ] Configure Cloudflare DNS (free tier) for custom domain (optional)
- [ ] Document all Supabase credentials in secure password manager
- [ ] Install Supabase CLI: `npm install -g supabase`
- [ ] Link local project: `supabase login` → `supabase init` → `supabase link`

### Step 2: Flutter Dependencies & Configuration
- [x] Add all dependencies from PRD Appendix to `pubspec.yaml`:
  - State: `flutter_riverpod`, `riverpod_annotation`
  - Database: `drift`, `drift_flutter`, `sqlite3_flutter_libs`, `sqlcipher_flutter_libs`
  - Backend: `supabase_flutter`, `dio`, `connectivity_plus`
  - Features: `mobile_scanner`, `url_launcher`, `flutter_local_notifications`, `pdf`, `fl_chart`, `image_picker`
  - Storage: `flutter_secure_storage`, `hive_flutter`
  - Navigation: `go_router`, `intl`, `share_plus`, `path_provider`
- [x] Add dev dependencies: `build_runner`, `drift_dev`, `riverpod_generator`, `flutter_lints`
- [x] Run `flutter pub get` and resolve any dependency conflicts
- [ ] Configure `android/app/build.gradle` for SQLCipher (native libs)
- [ ] Configure iOS `Podfile` for secure storage permissions

### Step 3: Local Database Schema (Drift/SQLite)
- [ ] Create `lib/core/database/app_database.dart` with Drift configuration
- [ ] Define all tables from PRD Section 6:
  - `shops` table with UUID primary keys
  - `products` table with shop-type fields (expiry_date, dosage, etc.)
  - `customers` table with total_owed running balance
  - `sales` and `sale_items` tables with offline sync support
  - `debts` and `debt_payments` tables with status tracking
  - `inventory_adjustments` with reason enums
  - `categories`, `exchange_rates`, `subscriptions`, `whatsapp_logs`
  - `devices`, `sync_queue` for multi-device support
- [ ] Add `sync_status` column to all local tables (`pending | synced | conflict`)
- [ ] Create DAOs: `sales_dao.dart`, `debts_dao.dart`, `products_dao.dart`, `customers_dao.dart`
- [ ] Set up SQLCipher encryption with secure key storage
- [ ] Generate database code: `flutter pub run build_runner build`

### Step 4: Supabase Database Migrations
- [ ] Create `supabase/migrations/001_initial_schema.sql` with all tables from PRD 6.1-6.9
- [ ] Create `supabase/migrations/002_rls_policies.sql` with shop isolation policies
- [ ] Create `supabase/migrations/003_triggers.sql` for:
  - Auto-updating `customers.total_owed` on debt changes
  - Auto-updating `debts.amount_remaining` calculated column
  - `updated_at` timestamp auto-update triggers
- [ ] Create `supabase/migrations/004_shop_types.sql` with shop type enum and templates
- [ ] Create `supabase/migrations/005_exchange_rates.sql` with rate caching table
- [ ] Push migrations: `supabase db push`
- [ ] Verify RLS policies are working with test queries

### Step 5: Project Architecture Setup
- [x] Create folder structure per PRD Section 9.1:
  ```
  lib/
  ├── core/
  │   ├── database/ (done in Step 3)
  │   ├── sync/
  │   ├── network/
  │   ├── auth/
  │   └── utils/
  ├── features/
  │   ├── onboarding/
  │   ├── sales/
  │   ├── qarz/
  │   ├── inventory/
  │   ├── customers/
  │   ├── reports/
  │   └── settings/
  └── shared/
      ├── widgets/
      ├── theme/
      └── l10n/
  ```
- [x] Create base classes: `AppColors`, `AppTypography`, `AppTheme` (PRD 9.4)
- [x] Set up Riverpod providers structure with `ProviderScope`
- [x] Create `main.dart` with MaterialApp router configuration

### Step 6: Localization & RTL Support
- [x] Create `lib/shared/l10n/app_fa.arb` (Dari - RTL)
- [x] Create `lib/shared/l10n/app_ps.arb` (Pashto - RTL)
- [x] Create `lib/shared/l10n/app_en.arb` (English - LTR)
- [x] Add 50+ translation keys covering:
  - Onboarding flows
  - Sales recording
  - Qarz management
  - Inventory terms
  - Currency formatting (AFN/USD/PKR)
- [x] Configure `MaterialApp` with `localizationsDelegates`
- [x] Test RTL layout mirroring for Dari/Pashto
- [x] Generate localization files: `flutter gen-l10n`

### Step 7: Shared Widgets Library
- [ ] Create `app_button.dart` with variants: primary, secondary, danger, success
- [ ] Create `app_text_field.dart` with RTL support and numeric keypad mode
- [ ] Create `loading_indicator.dart` with Afghan-themed colors
- [ ] Create `sync_status_bar.dart` showing offline/online/syncing states
- [ ] Create `currency_display.dart` showing AFN with original currency in parens
- [ ] Create `debt_badge.dart` with color coding (green/yellow/red)
- [ ] Create `product_card.dart` with barcode and stock indicator
- [ ] Create `customer_list_tile.dart` with debt amount and last contact

### Step 8: Utility Services
- [ ] Create `currency_formatter.dart` with AFN/USD/PKR formatting
- [ ] Create `date_formatter.dart` with Afghan calendar support (Solar Hijri)
- [ ] Create `pdf_generator.dart` for receipts and reports (using `pdf` package)
- [ ] Create `connectivity_service.dart` using `connectivity_plus`
- [ ] Create `exchange_rate_service.dart` with 7-day offline caching (Hive)
- [ ] Create `notification_service.dart` for local notifications (low stock, daily summary)

### Step 9: Environment Configuration
- [x] Create `.env.example` template (never commit real keys)
- [x] Create `.env` with:
  - `SUPABASE_URL`
  - `SUPABASE_ANON_KEY`
  - `EXCHANGE_RATE_API_KEY`
- [x] Add `flutter_dotenv` dependency for environment loading
- [x] Configure `.gitignore` to exclude `.env` and `supabase/config.toml`
- [ ] Document environment setup in `README.md`

### Step 10: Development Tools Setup
- [ ] Configure `build_runner` watch mode for code generation
- [ ] Set up Flutter DevTools for performance monitoring
- [ ] Configure Android emulator (API 26, 30, 34) for testing
- [ ] Set up iOS simulator testing (if Mac available)
- [ ] Create `Makefile` or `justfile` with common commands:
  - `make generate` (build_runner)
  - `make db-migrate` (supabase db push)
  - `make test` (flutter test)
  - `make build-apk` (release build)

---

## PHASE 1: AUTHENTICATION & ONBOARDING (Steps 11-20)

### Step 11: Supabase Auth Integration
- [ ] Create `auth_service.dart` wrapping Supabase Auth
- [ ] Implement phone number input with +93 auto-prefix
- [ ] Implement OTP verification (6-digit, 10-min expiry, 3 attempts)
- [ ] Store JWT in `flutter_secure_storage` (iOS Keychain / Android Keystore)
- [ ] Implement automatic token refresh (7-day expiry, 90-day refresh)
- [ ] Create `auth_provider.dart` with Riverpod for auth state
- [ ] Handle auth state persistence across app restarts

### Step 12: Auth Screens
- [ ] Create `phone_input_screen.dart` with numeric keypad only
- [ ] Create `otp_verification_screen.dart` with 6-digit input
- [ ] Create `splash_screen.dart` with auto-redirect to auth or home
- [ ] Add loading states and error handling for all auth flows
- [ ] Implement 15-minute lockout after 3 failed OTP attempts
- [ ] Add "Resend OTP" functionality with countdown timer

### Step 13: Shop Setup Wizard - Step 1 (Language)
- [ ] Create `language_selection_screen.dart`
- [ ] Display 3 options: Dari (فارسی), Pashto (پښتو), English
- [ ] Show RTL preview for Dari/Pashto selection
- [ ] Persist language preference to local database
- [ ] Auto-apply selected locale to app immediately

### Step 14: Shop Setup Wizard - Step 2 (Shop Info)
- [ ] Create `shop_setup_screen.dart`
- [ ] Shop name input (with Dari keyboard support)
- [ ] Shop type selector with icons (grocery, pharmacy, hardware, electronics, clothing, bakery, restaurant, general)
- [ ] City/district dropdown (Kabul districts first, then other cities)
- [ ] Phone number confirmation (pre-filled from auth)

### Step 15: Shop Setup Wizard - Step 3 (Currency)
- [ ] Create `currency_preference_screen.dart`
- [ ] Primary currency selector (default AFN)
- [ ] Secondary currency toggle (USD, PKR, or none)
- [ ] Exchange rate display with last-updated timestamp
- [ ] Persist preferences to `shops` table (local and remote)

### Step 16: Shop Setup Wizard - Step 4 (First Products)
- [ ] Create `first_product_screen.dart`
- [ ] Show 3 empty product slots to fill
- [ ] Options to add: barcode scan, manual entry, or skip
- [ ] For barcode scan: integrate `mobile_scanner` package
- [ ] For manual: minimal form (name, price, stock)
- [ ] Seed selected shop type's default categories if products added

### Step 17: Shop Type Catalog Seeding
- [ ] Create `catalog_seeder.dart` service
- [ ] Fetch `product_templates` from Supabase filtered by shop_type
- [ ] Insert up to 500 products into local SQLite with `sync_status: 'pending'`
- [ ] Fetch `category_templates` and seed local categories
- [ ] Show progress indicator during seeding
- [ ] Make seeding skippable but recommended

### Step 18: Onboarding State Management
- [ ] Create `onboarding_provider.dart` tracking wizard progress
- [ ] Persist onboarding completion status
- [ ] Track onboarding completion rate (KPI for analytics)
- [ ] Allow wizard to be skippable after step 2
- [ ] Create "Resume Setup" prompt if wizard incomplete

### Step 19: Navigation & Routing
- [ ] Set up `go_router` with declarative routes
- [ ] Define route guards (auth required, onboarding required)
- [ ] Create route constants file
- [ ] Implement deep linking for WhatsApp callbacks
- [ ] Set up navigation animations appropriate for RTL

### Step 20: Onboarding Polish
- [ ] Add onboarding progress indicator (step X of 5)
- [ ] Add helpful tooltips in Dari/Pashto
- [ ] Test onboarding on small screens (Tecno Spark size)
- [ ] Optimize for one-hand usage (thumb-friendly buttons)
- [ ] Add haptic feedback on critical actions

---

## PHASE 2: CORE SALES SYSTEM (Steps 21-30)

### Step 21: Product Catalog - Local Database
- [ ] Implement `products_dao.dart` with CRUD operations
- [ ] Add FTS5 full-text search for product names (Dari/Pashto/English)
- [ ] Implement fuzzy search for typo tolerance
- [ ] Add recent products query (last 20 sold)
- [ ] Implement product filtering by category
- [ ] Add barcode lookup index

### Step 22: Product Catalog - UI
- [ ] Create `product_list_screen.dart` with search bar
- [ ] Create `product_detail_screen.dart` with all fields
- [ ] Create `add_product_screen.dart` with dynamic fields based on shop type:
  - Grocery: weight/volume
  - Pharmacy: expiry date, dosage, prescription_required
  - Hardware: manufacturer, piece/set count
  - Electronics: IMEI, serial number, color, size
- [ ] Implement image picker for product photos (compressed to <50KB)
- [ ] Add barcode scanning for product lookup/creation

### Step 23: Sale Recording - Data Model
- [ ] Create `Sale` and `SaleItem` model classes
- [ ] Implement `sales_dao.dart` with transaction support
- [ ] Create sale recording logic with automatic:
  - Stock decrement
  - Debt creation (if credit)
  - Customer total_owed update
  - AFN conversion and storage
- [ ] Add `local_id` generation for offline sales

### Step 24: Sale Recording - Barcode Flow
- [ ] Create `barcode_scan_screen.dart` with `mobile_scanner`
- [ ] Implement continuous scanning mode (scan multiple items rapidly)
- [ ] Show product popup with large +/- buttons for quantity
- [ ] Display running cart total in AFN
- [ ] Add "Complete Sale" button when done scanning

### Step 25: Sale Recording - Manual Flow
- [ ] Create `quick_sale_screen.dart` with numeric keypad
- [ ] Implement product search with fuzzy matching
- [ ] Show recent products as quick-tap chips
- [ ] Add manual price override capability
- [ ] Support quantity entry with unit display (kg, piece, etc.)

### Step 26: Sale Confirmation Screen
- [ ] Create `sale_confirmation_screen.dart`
- [ ] Display cart items with subtotals
- [ ] Payment method selector: Cash / Credit (Qarz) / Mixed
- [ ] If Credit: customer selector/create new customer flow
- [ ] Discount input (AFN amount or percentage toggle)
- [ ] Currency selector (AFN/USD/PKR) with conversion display
- [ ] Final total with breakdown

### Step 27: Customer Management
- [ ] Create `customers_dao.dart` with CRUD and search
- [ ] Create `customer_list_screen.dart` with debt sorting
- [ ] Create `add_customer_screen.dart` (name, phone, notes)
- [ ] Implement customer search by name or phone
- [ ] Show customer debt history and last interaction

### Step 28: Receipt Generation
- [ ] Create `receipt_generator.dart` using `pdf` package
- [ ] Design professional receipt template in Dari/English
- [ ] Include: shop name, items, prices, total, payment method, date
- [ ] Add "Sent via حسابات" watermark for free tier
- [ ] Generate shareable PDF for WhatsApp
- [ ] Save receipt to device storage option

### Step 29: Sales Provider & State
- [ ] Create `sale_provider.dart` with Riverpod
- [ ] Manage cart state (add/remove items, update quantities)
- [ ] Handle sale confirmation async operation
- [ ] Implement optimistic UI updates
- [ ] Add sale recording analytics events

### Step 30: Sales Testing
- [ ] Write unit tests for sale calculation logic
- [ ] Write widget tests for sale screens
- [ ] Test barcode scanning on real device
- [ ] Test offline sale recording and queueing
- [ ] Verify stock decrements correctly
- [ ] Test multi-currency conversions

---

## PHASE 3: QARZ (DEBT) MANAGEMENT (Steps 31-40)

### Step 31: Debt Data Layer
- [ ] Create `debts_dao.dart` with comprehensive queries:
  - Total outstanding by shop
  - Debts by customer with aging
  - Overdue debts (>30 days)
  - Partial payment support
- [ ] Implement debt status logic: open → partial → paid
- [ ] Create database triggers for `amount_remaining` calculation
- [ ] Add `debt_payments` recording with transaction support

### Step 32: Qarz Dashboard Screen
- [ ] Create `qarz_dashboard_screen.dart`
- [ ] Hero number: Total outstanding owed (large, prominent)
- [ ] Customer list with sort options:
  - Amount owed (highest first)
  - Oldest debt first
  - Last contact date
- [ ] Color-coded debt cards: 🟢 <7 days | 🟡 7-30 days | 🔴 >30 days
- [ ] Search bar for customer name/phone

### Step 33: Customer Debt Detail
- [ ] Create `customer_debt_screen.dart`
- [ ] Show customer info and total owed
- [ ] List all individual debts with sale references
- [ ] Show payment history per debt
- [ ] "Record Payment" prominent button
- [ ] "Send Reminder" WhatsApp button

### Step 34: Debt Payment Recording
- [ ] Create `record_payment_screen.dart`
- [ ] Amount input with currency selector
- [ ] Payment method: Cash / Bank Transfer / Other
- [ ] Partial payment support with remaining balance display
- [ ] Auto-mark debt as "paid" when balance = 0
- [ ] Confetti animation on full payment 🎉
- [ ] Update `customers.total_owed` atomically

### Step 35: WhatsApp Integration
- [ ] Create `whatsapp_service.dart` using `url_launcher`
- [ ] Generate professional Dari reminder message:
  ```
  محترم [نام]،
  قرضه شما به دکان [نام دکان] به مبلغ [مقدار] افغانی است.
  لطفاً در اسرع وقت پرداخت کنید.
  تشکر.
  ```
- [ ] Create `whatsapp_reminder_button.dart` widget
- [ ] Deep link to WhatsApp with pre-filled message
- [ ] Log all WhatsApp attempts to `whatsapp_logs` table
- [ ] Handle WhatsApp not installed gracefully

### Step 36: Debt Receipts
- [ ] Create debt payment receipt PDF template
- [ ] Include: original debt, payment amount, remaining balance
- [ ] Share via WhatsApp or save locally
- [ ] Print support (if printer connected)

### Step 37: Debt Analytics
- [ ] Calculate collection rate (% of debts paid within 30 days)
- [ ] Show debt aging chart (fl_chart)
- [ ] Track average days to payment
- [ ] Identify "at-risk" customers (multiple overdue debts)

### Step 38: Debt Notifications
- [ ] Daily notification for overdue debts (>30 days)
- [ ] Weekly summary of new debts created
- [ ] Payment due date reminders (if due_date set)
- [ ] Configurable notification times (default 9am)

### Step 39: Qarz Provider
- [ ] Create `qarz_provider.dart` with Riverpod
- [ ] Manage debt list state with filtering
- [ ] Handle payment recording with optimistic updates
- [ ] Implement debt search and sort state
- [ ] Track "last_reminder_sent_at" per debt

### Step 40: Qarz Testing
- [ ] Test debt creation on sale completion
- [ ] Test partial payments and balance calculations
- [ ] Test WhatsApp message generation and deep linking
- [ ] Test debt aging color coding
- [ ] Verify RLS: customers only see their shop's debts

---

## PHASE 4: INVENTORY MANAGEMENT (Steps 41-50)

### Step 41: Inventory Data Layer
- [ ] Extend `products_dao.dart` with inventory methods:
  - Stock quantity updates
  - Low stock queries (below min_stock_alert)
  - Inventory valuation (stock × cost_price)
- [ ] Create `inventory_adjustments` recording
- [ ] Implement adjustment reasons enum:
  - new_stock, damaged, expired, manual_count, theft, other

### Step 42: Inventory Screens
- [ ] Create `inventory_screen.dart` with category tabs
- [ ] Create `stock_take_screen.dart` for rapid scanning
- [ ] Create `add_stock_screen.dart` for receiving new inventory
- [ ] Create `inventory_adjustment_screen.dart` for corrections

### Step 43: Low Stock Alerts
- [ ] Implement local notification for low stock (immediate)
- [ ] Create daily 8am digest notification with all low-stock items
- [ ] Add red badge to Inventory tab icon
- [ ] Create `low_stock_report.dart` PDF generator
- [ ] Show low stock indicator on product cards

### Step 44: Stock Take Mode
- [ ] Implement rapid barcode scanning for stock counting
- [ ] Compare scanned count vs system count
- [ ] Generate adjustment records for discrepancies
- [ ] Show variance report at end of stock take
- [ ] Support manual count entry for non-barcoded items

### Step 45: Product Categories
- [ ] Create `categories_dao.dart` for CRUD operations
- [ ] Implement category management UI
- [ ] Show category-specific fields based on shop type
- [ ] Add category icons and color coding
- [ ] Support category reordering

### Step 46: Expiry Date Tracking (Pharmacy/Bakery)
- [ ] Add expiry date field to product form (shop type conditional)
- [ ] Create expiry alert notifications (30, 15, 7 days before)
- [ ] Generate expiry report PDF
- [ ] Show expiry date on product detail screen
- [ ] Sort inventory by expiry date (nearest first)

### Step 47: Inventory Reports
- [ ] Current stock valuation report
- [ ] Fast/slow moving products report
- [ ] Stock adjustment history report
- [ ] All reports exportable as PDF
- [ ] All reports work offline

### Step 48: Inventory Provider
- [ ] Create `inventory_provider.dart` with Riverpod
- [ ] Manage product list with filtering and search
- [ ] Handle stock adjustments with optimistic updates
- [ ] Implement low stock state monitoring
- [ ] Track inventory sync status

### Step 49: Barcode Management
- [ ] Support EAN-13 and UPC-A barcode formats
- [ ] Handle barcode collision detection
- [ ] Allow manual barcode entry for damaged labels
- [ ] Generate barcodes for products without (optional)

### Step 50: Inventory Testing
- [ ] Test stock decrement on sale
- [ ] Test low stock alert triggering
- [ ] Test stock take variance detection
- [ ] Test expiry date alerts
- [ ] Verify inventory adjustments are logged

---

## PHASE 5: REPORTS & ANALYTICS (Steps 51-60)

### Step 51: Daily Summary
- [ ] Create `daily_summary_screen.dart`
- [ ] Calculate and display:
  - Total sales today (AFN)
  - Cash received vs new qarz extended
  - Qarz collected today
  - Top 3 selling products
  - Net profit estimate (if cost prices entered)
- [ ] Schedule 9pm daily summary notification
- [ ] Make summary viewable anytime from home screen

### Step 52: Sales Reports
- [ ] Create `sales_report_screen.dart`
- [ ] Time range selectors: Daily / Weekly / Monthly / Custom
- [ ] Key metrics: Revenue, transaction count, avg sale value
- [ ] Payment method split chart (pie chart)
- [ ] Sales trend line chart (fl_chart)
- [ ] Export to PDF with professional formatting

### Step 53: Qarz Reports
- [ ] Create `qarz_report_screen.dart`
- [ ] Snapshot: Total owed, by customer, aging buckets
- [ ] Collection rate trend over time
- [ ] New debts vs payments chart
- [ ] At-risk customer list
- [ ] Export to PDF

### Step 54: Inventory Reports
- [ ] Create `inventory_report_screen.dart`
- [ ] Current stock value calculation
- [ ] Low stock items list
- [ ] Fast/slow movers identification
- [ ] Category breakdown pie chart
- [ ] Export to PDF

### Step 55: Profit Reports
- [ ] Create `profit_report_screen.dart` (Monthly view)
- [ ] Calculate Revenue, COGS, Gross Profit
- [ ] Profit margin percentage
- [ ] Profit trend chart
- [ ] Export to PDF

### Step 56: Customer Reports
- [ ] Create `customer_report_screen.dart` (Monthly)
- [ ] Top customers by revenue
- [ ] New vs returning customers
- [ ] At-risk customer identification
- [ ] Customer purchase history
- [ ] Export to PDF

### Step 57: Report Charts (fl_chart)
- [ ] Implement line charts for trends
- [ ] Implement bar charts for comparisons
- [ ] Implement pie charts for splits
- [ ] Ensure charts work with RTL layouts
- [ ] Optimize chart performance for low-end devices

### Step 58: Report Provider
- [ ] Create `reports_provider.dart` with Riverpod
- [ ] Cache report data locally
- [ ] Implement date range filtering
- [ ] Handle report generation async
- [ ] Track report view analytics

### Step 59: PDF Export System
- [ ] Create reusable `pdf_report_base.dart` template
- [ ] Add shop logo/header to all reports
- [ ] Support Dari/English bilingual reports
- [ ] Optimize PDF size for WhatsApp sharing
- [ ] Add "Generated by Hesabat" footer

### Step 60: Reports Testing
- [ ] Test all report calculations for accuracy
- [ ] Test PDF generation and sharing
- [ ] Test date range filtering
- [ ] Verify offline report availability
- [ ] Test chart rendering on small screens

---

## PHASE 6: MULTI-CURRENCY & SYNC (Steps 61-70)

### Step 61: Exchange Rate Service
- [ ] Create `exchange_rate_service.dart`
- [ ] Fetch rates from ExchangeRate-API (1 request/day)
- [ ] Cache rates in Hive for 7-day offline operation
- [ ] Store rates in local SQLite `exchange_rates` table
- [ ] Background sync via `Workmanager` or similar
- [ ] Show last-updated timestamp in UI

### Step 62: Multi-Currency UI
- [ ] Create `currency_selector.dart` widget
- [ ] Show AFN equivalent when foreign currency selected
- [ ] Format amounts with proper symbols (؋, $, ₨)
- [ ] Handle currency conversion in real-time
- [ ] Store both original and AFN amounts in database

### Step 63: Offline-First Architecture
- [ ] Create `sync_service.dart` core engine
- [ ] Implement `sync_queue` local table for pending operations
- [ ] Create `connectivity_service.dart` monitoring
- [ ] Implement "write local first" pattern for all mutations
- [ ] Add sync status indicators throughout UI

### Step 64: Sync Engine Implementation
- [ ] Batch sync operations (500 records max per batch)
- [ ] Implement retry strategy: 30s, 2min, 10min, 1hour
- [ ] Handle sync conflicts per PRD Section 8.3 rules
- [ ] Show sync progress indicator
- [ ] Implement "force sync" manual trigger

### Step 65: Conflict Resolution UI
- [ ] Create `conflict_resolution_screen.dart`
- [ ] Show local vs server version side-by-side
- [ ] Allow user to choose: Use Local / Use Server / Merge
- [ ] Handle different conflict types:
  - Sales: append-only (no conflict)
  - Stock: sum adjustments
  - Debt: server authoritative
  - Customer: last-updated wins
  - Product price: user choice

### Step 66: Supabase Edge Functions
- [ ] Create `supabase/functions/exchange-rates/index.ts`
  - Fetch and store daily exchange rates
  - Scheduled via pg_cron at 6am Afghanistan time
- [ ] Create `supabase/functions/hesabpay-webhook/index.ts`
  - Receive payment confirmations
  - Verify HMAC-SHA256 signature
  - Activate subscriptions
- [ ] Create `supabase/functions/sync-conflicts/index.ts`
  - Resolve sync conflicts server-side
  - Apply RLS policies

### Step 67: Edge Function Deployment
- [ ] Deploy all functions: `supabase functions deploy`
- [ ] Set secrets via CLI:
  - `EXCHANGE_RATE_API_KEY`
  - `HESABPAY_WEBHOOK_SECRET`
- [ ] Test functions locally with `supabase functions serve`
- [ ] Configure pg_cron schedule for exchange rates

### Step 68: Multi-Device Support
- [ ] Create `devices` table tracking
- [ ] Implement device registration on app launch
- [ ] Handle device limit enforcement (1 for Basic, 3 for Pro)
- [ ] Show active devices in settings
- [ ] Implement device deactivation/removal

### Step 69: Sync Provider
- [ ] Create `sync_provider.dart` with Riverpod
- [ ] Expose sync status (idle, syncing, error, conflict)
- [ ] Show pending operations count
- [ ] Handle sync error recovery
- [ ] Implement "sync now" button

### Step 70: Sync Testing
- [ ] Test offline sale recording and later sync
- [ ] Test conflict scenarios with multiple devices
- [ ] Test sync retry logic
- [ ] Test large batch sync (500+ records)
- [ ] Verify data integrity after sync

---

## PHASE 7: SUBSCRIPTION & SETTINGS (Steps 71-80)

### Step 71: Subscription Data Model
- [ ] Extend `shops` table with subscription fields
- [ ] Create `subscriptions` table for billing records
- [ ] Implement trial tracking (30 days from signup)
- [ ] Create subscription status logic:
  - trial → active → expired → cancelled
- [ ] Add feature gating based on plan

### Step 72: Subscription Screens
- [ ] Create `subscription_screen.dart`
- [ ] Show current plan and features
- [ ] Display upgrade/downgrade options
- [ ] Show billing history
- [ ] Implement plan comparison table

### Step 73: HesabPay Integration
- [ ] Create `hesabpay_service.dart`
- [ ] Generate payment links with metadata
- [ ] Handle payment success/cancel callbacks
- [ ] Poll for payment status (fallback)
- [ ] Integrate with subscription activation

### Step 74: Feature Gating
- [ ] Implement `feature_flags.dart` utility
- [ ] Gate features by plan:
  - Free Trial: 50 products max, 10 WhatsApp reminders, watermark
  - Basic: Unlimited products, 100 WhatsApp reminders, no watermark
  - Pro: 3 devices, unlimited WhatsApp, AI insights (V2)
- [ ] Show upgrade prompts for gated features
- [ ] Graceful degradation when subscription expires

### Step 75: Settings Screens
- [ ] Create `settings_screen.dart` main menu
- [ ] Create `language_settings.dart` (change language anytime)
- [ ] Create `currency_settings.dart` (update preferences)
- [ ] Create `notification_settings.dart` (toggle alerts)
- [ ] Create `shop_profile_screen.dart` (edit shop info)
- [ ] Create `data_management_screen.dart` (export/delete)

### Step 76: Data Export/Delete
- [ ] Implement full data export (JSON/CSV)
- [ ] Generate comprehensive PDF report of all data
- [ ] Implement account deletion (GDPR compliance)
- [ ] Add "Export before delete" warning
- [ ] Secure data deletion confirmation

### Step 77: About & Support
- [ ] Create `about_screen.dart` with app version
- [ ] Add help/FAQ section in Dari/Pashto/English
- [ ] Create contact support button (WhatsApp/email)
- [ ] Add privacy policy and terms of service
- [ ] Show "Powered by Supabase" attribution

### Step 78: Settings Provider
- [ ] Create `settings_provider.dart` with Riverpod
- [ ] Manage all user preferences
- [ ] Persist settings to local database
- [ ] Sync settings to cloud when online
- [ ] Handle settings migration on app updates

### Step 79: Subscription Testing
- [ ] Test trial expiration flow
- [ ] Test upgrade from trial to basic
- [ ] Test HesabPay webhook handling
- [ ] Test feature gating enforcement
- [ ] Test subscription renewal logic

### Step 80: Settings Polish
- [ ] Add haptic feedback toggle
- [ ] Implement theme selection (light/dark/system)
- [ ] Add font size adjustment for accessibility
- [ ] Test all settings on small screens
- [ ] Ensure RTL compatibility in all settings screens

---

## PHASE 8: TESTING & QUALITY (Steps 81-90)

### Step 81: Unit Testing
- [ ] Write unit tests for all DAOs (80% coverage target)
- [ ] Test sale calculation logic (subtotals, discounts, currency conversion)
- [ ] Test debt calculation (remaining balance, partial payments)
- [ ] Test inventory adjustments (stock math)
- [ ] Test sync queue ordering and batching

### Step 82: Widget Testing
- [ ] Write widget tests for critical screens:
  - Sale entry flow
  - Qarz dashboard
  - Onboarding wizard
- [ ] Test RTL layout rendering
- [ ] Test responsive design on different screen sizes
- [ ] Test loading and error states

### Step 83: Integration Testing
- [ ] Create integration test for complete sale → debt → payment flow
- [ ] Test offline → online sync journey
- [ ] Test WhatsApp reminder deep linking
- [ ] Test barcode scanning end-to-end
- [ ] Test PDF generation and sharing

### Step 84: Edge Function Testing
- [ ] Write Deno tests for exchange-rates function
- [ ] Test HesabPay webhook with mock payloads
- [ ] Test sync-conflicts resolution logic
- [ ] Test RLS policies with different user contexts
- [ ] Verify HMAC signature validation

### Step 85: Offline Testing
- [ ] Test app functionality in airplane mode
- [ ] Verify data persistence after app restart
- [ ] Test sync queue behavior on reconnection
- [ ] Test conflict resolution with simulated multi-device edits
- [ ] Verify no data loss in any scenario

### Step 86: Performance Testing
- [ ] Measure app startup time (target: <2 seconds)
- [ ] Measure sale recording time (target: <15 seconds)
- [ ] Test with 10,000+ products in database
- [ ] Test with 1,000+ pending sync operations
- [ ] Profile memory usage (target: <150MB active)

### Step 87: Device Testing
- [ ] Test on Samsung Galaxy A15 (primary target device)
- [ ] Test on Tecno Spark (~$60 budget device)
- [ ] Test on iPhone SE (if available)
- [ ] Test on Android API 26 (minimum supported)
- [ ] Test on Android API 34 (latest)

### Step 88: Security Audit
- [ ] Verify SQLCipher encryption is active on local database
- [ ] Test RLS policies prevent cross-shop data access
- [ ] Verify JWT tokens never logged or exposed
- [ ] Test secure storage (Keychain/Keystore) for tokens
- [ ] Audit all Supabase queries for injection vulnerabilities
- [ ] Verify no PII in error logs or analytics
- [ ] Test screenshot prevention on sensitive screens (optional)

### Step 89: Accessibility Testing
- [ ] Test with screen reader (TalkBack/VoiceOver)
- [ ] Verify color contrast ratios (WCAG 2.1 AA)
- [ ] Test font scaling up to 200%
- [ ] Ensure all interactive elements are minimum 48dp
- [ ] Test with one-hand usage scenarios
- [ ] Verify RTL screen reader behavior

### Step 90: Beta Testing
- [ ] Deploy to Google Play Internal Testing (Android)
- [ ] Deploy to TestFlight (iOS, if applicable)
- [ ] Recruit 5 real shopkeepers from Kabul for beta
- [ ] Create beta feedback form in Dari/English
- [ ] Monitor crash reports via Sentry
- [ ] Collect performance metrics from real devices
- [ ] Iterate based on beta feedback

---

## PHASE 9: DEPLOYMENT & LAUNCH (Steps 91-100)

### Step 91: Android Release Preparation
- [ ] Configure `android/app/build.gradle` for release:
  - Set `minSdkVersion 26` (Android 8.0)
  - Enable ProGuard/R8 for code shrinking
  - Configure signing keystore
- [ ] Create app icon in all required densities
- [ ] Write app description in Dari/English for Play Store
- [ ] Capture 5-8 screenshots showing key features
- [ ] Create feature graphic for Play Store
- [ ] Prepare privacy policy for Play Store
- [ ] Build release APK: `flutter build apk --release`
- [ ] Build App Bundle: `flutter build appbundle --release`

### Step 92: Google Play Store Submission
- [ ] Pay $25 one-time developer fee
- [ ] Create new app in Play Console
- [ ] Upload App Bundle (AAB)
- [ ] Fill store listing (title, description, screenshots)
- [ ] Set content rating (Everyone / Business)
- [ ] Configure pricing (Free app, in-app subscriptions)
- [ ] Set up subscription products in Play Console:
  - `basic_monthly`: 400 AFN
  - `basic_annual`: 3,600 AFN
  - `pro_monthly`: 700 AFN
- [ ] Submit for review (1-3 days approval)

### Step 93: iOS Release Preparation (Optional for V1)
- [ ] Pay $99/year Apple Developer fee
- [ ] Configure iOS signing certificates
- [ ] Set iOS deployment target to 14.0
- [ ] Configure `Info.plist` permissions (camera, notifications)
- [ ] Build release IPA: `flutter build ios --release`
- [ ] Archive and upload to App Store Connect
- [ ] Prepare App Store screenshots (iPhone SE, 14, 15 sizes)
- [ ] Write App Store description

### Step 94: App Store Submission (Optional for V1)
- [ ] Create new app in App Store Connect
- [ ] Upload build via Xcode or Transporter
- [ ] Fill App Store listing information
- [ ] Set up App Store subscriptions matching Android pricing
- [ ] Submit for review (1-2 days approval)

### Step 95: Production Supabase Configuration
- [ ] Verify all migrations applied to production
- [ ] Confirm RLS policies active on all tables
- [ ] Set production secrets via CLI:
  - `supabase secrets set EXCHANGE_RATE_API_KEY=prod-key`
  - `supabase secrets set HESABPAY_WEBHOOK_SECRET=prod-secret`
  - `supabase secrets set SENTRY_DSN=prod-dsn`
- [ ] Enable Sentry error tracking
- [ ] Configure pg_cron for production exchange rates
- [ ] Test Edge Functions in production environment
- [ ] Set up database backups (daily point-in-time)

### Step 96: Launch Monitoring
- [ ] Configure Sentry for production error tracking
- [ ] Set up UptimeRobot monitoring (already done in Step 1)
- [ ] Create admin dashboard for monitoring:
  - Active shops count
  - Daily sales volume
  - Sync queue health
  - Subscription status distribution
- [ ] Set up alerts for critical errors
- [ ] Prepare incident response runbook

### Step 97: Marketing Materials
- [ ] Create demo video (30-60 seconds) in Dari
- [ ] Design business cards/flyers for door-to-door sales
- [ ] Prepare WhatsApp message templates for viral sharing
- [ ] Create shopkeeper testimonial request form
- [ ] Design "Sent via حسابات" watermark graphics
- [ ] Prepare sales agent training materials

### Step 98: Sales & Support Setup
- [ ] Create support WhatsApp number for shopkeepers
- [ ] Set up email support (support@hesabat.app)
- [ ] Prepare FAQ document in Dari/English
- [ ] Create onboarding checklist for sales agents
- [ ] Design commission tracking system for agents
- [ ] Prepare data import service for existing notebooks

### Step 99: Launch Day Checklist
- [ ] Verify app is live on Play Store
- [ ] Test download and onboarding on fresh device
- [ ] Verify Supabase production health
- [ ] Confirm HesabPay webhooks receiving
- [ ] Test subscription purchase flow end-to-end
- [ ] Send launch announcement to beta testers
- [ ] Begin door-to-door sales in target neighborhood
- [ ] Monitor crash reports and error rates hourly

### Step 100: Post-Launch Iteration
- [ ] Collect feedback from first 10 paying customers
- [ ] Prioritize top 3 feature requests
- [ ] Fix any critical bugs within 24 hours
- [ ] Plan Sprint 7+ based on real usage data
- [ ] Set up weekly metrics review (KPIs from PRD Section 18)
- [ ] Prepare for Phase 2 development (Months 4-6)
- [ ] Document lessons learned
- [ ] Celebrate launch! 🎉

---

## APPENDIX: ONGOING TASKS

### Weekly
- [ ] Review error logs in Sentry
- [ ] Monitor Supabase usage (approaching free tier limits?)
- [ ] Check customer support messages
- [ ] Review sales metrics and conversion rates

### Monthly
- [ ] Analyze churn rate and gather exit feedback
- [ ] Update exchange rate API if needed
- [ ] Review and update product templates
- [ ] Plan feature roadmap based on feedback

### Quarterly
- [ ] Security audit and dependency updates
- [ ] Performance optimization review
- [ ] User satisfaction survey (NPS)
- [ ] Competitive analysis update

---

## SUCCESS METRICS CHECKLIST

Track these from Day 1:

| Metric | Month 3 Target | Month 12 Target | Status |
|---|---|---|---|
| Paying Shops | 25 | 400 | ⬜ |
| MRR (AFN) | 10,000 | 160,000 | ⬜ |
| Sale Entry Time | <20 sec | <12 sec | ⬜ |
| Onboarding Completion | >70% | >80% | ⬜ |
| Qarz Recovery Rate | >65% | >80% | ⬜ |
| Monthly Churn | <12% | <8% | ⬜ |
| Daily Active / Paying | >60% | >70% | ⬜ |
| App Crash Rate | <5/1K | <1/1K | ⬜ |
| Sync Failure Rate | <2% | <0.5% | ⬜ |

---

## EMERGENCY CONTACTS & RESOURCES

- **Supabase Support**: https://supabase.com/support
- **Flutter Docs**: https://docs.flutter.dev
- **Riverpod Docs**: https://riverpod.dev
- **Drift Docs**: https://drift.simonbinder.eu
- **Afghanistan Exchange Rate API**: https://www.exchangerate-api.com

---

*Hesabat Development Roadmap v1.0*
*From 0 to 100: Building Afghanistan's First Offline-First Business Management App*
*Total Infrastructure Cost: $0/month | Target Launch: Month 3*
