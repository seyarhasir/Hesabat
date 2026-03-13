# حسابات — Hesabat
## Product Requirements Document (PRD) v1.0.0
**The Smart Shop — Afghanistan's First Offline-First Business Management App**

| Field | Detail |
|---|---|
| Document Type | Product Requirements Document |
| Version | 1.0.0 — March 2026 |
| Platform | Flutter (iOS & Android) + Supabase Edge Functions (Serverless) |
| Target Market | Afghanistan — Kabul (Phase 1) |
| Monthly Infrastructure Cost | **$0 at launch** |

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Problem Statement](#2-problem-statement)
3. [Product Vision & Goals](#3-product-vision--goals)
4. [User Personas](#4-user-personas)
5. [$0 Technology Stack](#5-0-technology-stack)
6. [Database Schema](#6-database-schema)
7. [Feature Specifications](#7-feature-specifications)
8. [Offline-First Sync Architecture](#8-offline-first-sync-architecture)
9. [Flutter App Architecture](#9-flutter-app-architecture)
10. [Python Backend Architecture](#10-python-backend-architecture)
11. [Shop Type System & Product Catalog Filters](#11-shop-type-system--product-catalog-filters)
12. [Subscription & Monetization](#12-subscription--monetization)
13. [Go-To-Market Strategy](#13-go-to-market-strategy)
14. [Development Roadmap](#14-development-roadmap)
15. [Non-Functional Requirements](#15-non-functional-requirements)
16. [Security Requirements](#16-security-requirements)
17. [Testing Strategy](#17-testing-strategy)
18. [Success Metrics & KPIs](#18-success-metrics--kpis)
19. [Open Questions](#19-open-questions)
20. [Appendix — Dependencies](#20-appendix--dependencies)

---

## 1. Executive Summary

Hesabat (The Smart Shop) is an offline-first Android and iOS mobile application built with Flutter, designed specifically for small and medium shop owners across Afghanistan. It replaces the universal paper notebook system with a lightweight, voice-enabled, multilingual business management platform.

> **Mission:** Give every Afghan shopkeeper — regardless of literacy or internet access — a digital business command center in their pocket.

**The Core Problem:** 500,000+ Afghan shops lose 10–30% of revenue annually from untracked debts (qarz) and invisible inventory gaps. No existing solution works offline, speaks Dari/Pashto, or costs less than a few energy drinks per month.

**The Solution:** A zero-barrier, voice-first, offline-capable app that pays for itself within the first week of use.

**The Business Model:** Pure SaaS — 400 AFN/month per shop. Zero physical infrastructure. Zero warehouse. Zero delivery.

| Milestone | Paying Shops | Monthly Revenue |
|---|---|---|
| Month 6 | 100 shops | 40,000 AFN (~$290) |
| Month 12 | 400 shops | 160,000 AFN (~$1,155) |
| Year 2 | 3,000 shops | 1,200,000 AFN (~$8,640) |
| Year 3 | 10,000 shops | 4,000,000 AFN (~$28,800) |

---

## 2. Problem Statement

### 2.1 The Current Reality

Walk into any small shop in Kabul — a grocery in Karte Char, a pharmacy in Wazir Akbar Khan, a hardware store in Kote Sangi — and you will find the same tool managing the entire business: a worn paper notebook.

| Problem | Business Impact | Frequency |
|---|---|---|
| Forgotten Qarz (Debt) | 10–30% of credit sales never collected | Daily |
| Invisible Inventory | Stockouts discovered by customer, not owner | Weekly |
| No Financial Visibility | Owner has no idea if business is profitable | Always |
| Multi-Currency Confusion | AFN/USD/PKR math errors cause losses | Daily |
| No Customer Receipts | Disputes with no paper trail | Weekly |

### 2.2 Why Existing Solutions Fail

- **Traditional POS systems:** $1,000–$5,000 upfront, require constant electricity, English-only, zero offline capability
- **Excel/Google Sheets:** Requires laptop, internet, computer literacy — none reliably available
- **Pakistani/Indian apps (KhataBook, OkCredit):** Urdu/Hindi only, no Dari/Pashto, no AFN, no offline-first architecture
- **Paper notebooks:** Zero cost but catastrophic for debt recovery and inventory management

### 2.3 The Validated Pain Hierarchy

1. **Qarz recovery** — "I have money on paper but cannot collect it" (Primary pain)
2. **Inventory awareness** — "I lose customers because I run out without knowing" (Secondary pain)
3. **Daily profit calculation** — "I work all day but don't know if I made money" (Tertiary pain)
4. **Customer receipts** — "Customers dispute amounts, I have no proof" (Quaternary pain)

---

## 3. Product Vision & Goals

> **Vision:** "By 2028, every shopkeeper in Afghanistan — from Kabul to Kandahar — manages their business digitally, recovers every debt, never runs out of stock unknowingly, and knows their profit at the end of every day. Hesabat makes this possible for 400 AFN a month."

### 3.1 Product Goals

| Goal | Metric | Target (Month 12) |
|---|---|---|
| Solve Qarz problem | % of credit sales tracked and recovered | > 85% recovery rate |
| Solve Inventory problem | Stockout incidents reported by users | Reduced by 70% |
| Daily financial clarity | Daily summary views per active user | > 1 per day |
| Grow paying users | Monthly paying shops | 400 shops |
| Retain users | Monthly churn rate | < 8% per month |

### 3.2 Non-Goals (Out of Scope for V1)

- No e-commerce or online storefront
- No employee payroll management
- No tax filing or formal accounting
- No hardware integrations beyond mobile camera for barcode scanning
- No web app — mobile only for V1

---

## 4. User Personas

### 4.1 Primary — Ahmad, Grocery Owner

| Attribute | Detail |
|---|---|
| Age | 38 years old |
| Location | Karte Char, Kabul |
| Shop Type | General grocery (kiryana) store |
| Education | Grade 8, basic reading in Dari |
| Device | Samsung Galaxy A15 (Android 14, ~$80) |
| Internet | Roshan SIM, 4G when available, often 2G or none |
| Tech Comfort | Uses WhatsApp daily, knows how to video call |
| Monthly Revenue | Approx. 80,000–120,000 AFN |
| Credit Extended | 30–40% of sales are on qarz |
| Biggest Fear | Not being able to collect debts from neighbors |

### 4.2 Secondary — Fatima, Pharmacy Owner

| Attribute | Detail |
|---|---|
| Age | 44 years old |
| Location | Wazir Akbar Khan, Kabul |
| Shop Type | Small pharmacy (daroo khana) |
| Device | iPhone SE (iOS), gifted by relative abroad |
| Internet | Home WiFi + MTN SIM data |
| Tech Comfort | Uses mobile banking app, active on Facebook |
| Monthly Revenue | Approx. 150,000–200,000 AFN |
| Key Need | Track medicine expiry dates + stock levels |

### 4.3 Tertiary — Karim, Hardware Shop Owner

| Attribute | Detail |
|---|---|
| Age | 52 years old |
| Location | Kote Sangi, Kabul |
| Shop Type | Hardware and building materials |
| Education | Grade 6, low digital literacy |
| Device | Tecno Spark Android (~$60) |
| Internet | Very limited — WiFi at home only |
| Key Need | Simple debt tracking only — no complexity |
| Special Requirement | Must work 100% without internet at all times |

---

## 5. $0 Technology Stack

> **Core Principle:** Every service used at launch must have a free tier sufficient to support the first 500–1,000 users. We pay nothing until we are making money. Every free tier limit is listed so you know exactly when you will need to upgrade.

### 5.1 The $0 Serverless Stack Overview

```
Flutter (iOS & Android)
        ↓
Supabase Free Tier
├── PostgreSQL database (500MB)
├── Auth — phone + OTP (50,000 MAU)
├── Storage — product images (1GB)
├── Realtime — offline sync
├── Edge Functions — all backend logic (500K invocations/month)
└── pg_cron — scheduled jobs (exchange rates daily)
        ↓
Cloudflare Free (DNS + SSL + DDoS)
        ↓
GitHub Actions Free (CI/CD)
        ↓
UptimeRobot Free (keeps Supabase project alive — pings every 5 min)
```

**Zero servers. Zero VPS. Zero Python. Zero Docker. Zero extra services.**

Everything runs inside Supabase. The only language you write besides Dart is TypeScript
for Edge Functions — and TypeScript is very similar to Dart in syntax.

### 5.2 Free Tier Breakdown — Every Limit Explained

| Service | Free Tier Limit | When You'll Hit It | Cost After |
|---|---|---|---|
| **Supabase DB** | 500MB PostgreSQL | ~3,000–5,000 active shops | $25/month (Pro) |
| **Supabase Auth** | 50,000 MAU | ~50,000 shops (Year 4+) | Included in Pro |
| **Supabase Storage** | 1GB | ~20,000 product images at 50KB each | Included in Pro |
| **Supabase Edge Functions** | 500,000 invocations/month | Never for V1 (few calls/day) | Included in Pro |
| **Supabase Realtime** | 200 concurrent connections | ~200 shops online simultaneously | Included in Pro |
| **Supabase Bandwidth** | 2GB/month | Watch at ~500 active shops | Included in Pro |
| **Cloudflare** | Unlimited bandwidth, SSL, DDoS | Never | Always free |
| **GitHub Actions** | 2,000 CI/CD minutes/month | Never for solo dev | Always free |
| **UptimeRobot** | 50 monitors, 5-min intervals | Never | Always free |
| **ExchangeRate-API** | 1,500 requests/month | Never (1 request/day) | Always free |
| **Google Play Store** | $25 one-time | Before Android launch | One-time only |
| **Apple App Store** | $99/year | Before iOS launch | $99/year |
| **TOTAL MONTH 1** | | | **$0** |

> **The Supabase Pause Problem:** Free projects pause after 7 days of inactivity. Fix: add your Supabase project URL to UptimeRobot (free). It pings every 5 minutes — project never pauses. Setup takes 3 minutes.

### 5.3 Mobile App — Flutter

| Component | Library | Version | Free? | Purpose |
|---|---|---|---|---|
| Framework | Flutter | 3.19+ | ✅ Always free | Cross-platform iOS & Android |
| Language | Dart | 3.3+ | ✅ Always free | Single codebase |
| State Management | Riverpod | 2.5+ | ✅ Always free | Reactive state |
| Local Database | Drift (SQLite) | 2.18+ | ✅ Always free | Offline-first storage |
| Supabase Client | supabase_flutter | 2.5+ | ✅ Always free | Auth + realtime sync |
| Barcode Scanning | mobile_scanner | 5.2+ | ✅ Always free | Camera barcode scan |
| Voice Input | speech_to_text | 6.6+ | ✅ Always free | On-device STT |
| Navigation | go_router | 13.2+ | ✅ Always free | Declarative routing |
| Localization | flutter_localizations | SDK | ✅ Always free | Dari/Pashto/English |
| Charts | fl_chart | 0.68+ | ✅ Always free | Revenue charts |
| PDF Generation | pdf (dart) | 3.10+ | ✅ Always free | On-device receipts |
| WhatsApp | url_launcher | 6.2+ | ✅ Always free | Deep link to WhatsApp |
| Local Notifications | flutter_local_notifications | 17+ | ✅ Always free | Offline alerts |
| HTTP Client | dio | 5.4+ | ✅ Always free | External API calls (exchange rates fallback) |
| Local Cache | hive_flutter | 1.1+ | ✅ Always free | Exchange rate cache |
| Secure Storage | flutter_secure_storage | 9.0+ | ✅ Always free | JWT token storage |

### 5.4 Backend — Supabase Edge Functions (Serverless TypeScript)

| Component | Technology | Free Tier | Purpose |
|---|---|---|---|
| Runtime | Deno (TypeScript) | ✅ Always free | Edge function runtime |
| Deployment | Supabase CLI | ✅ Always free | `supabase functions deploy` |
| Scheduled Jobs | pg_cron (built into Supabase) | ✅ Always free | Daily exchange rate sync |
| Auth | Supabase Auth (built-in) | ✅ Always free | JWT + RLS — no extra code |
| Database Access | Supabase JS client (in Edge Functions) | ✅ Always free | Direct DB access |
| Webhook Receiver | Edge Function HTTP endpoint | ✅ Always free | HesabPay payment webhooks |
| Error Tracking | Sentry free tier (JS SDK) | ✅ 5K errors/month | Bug monitoring |
| AI (V2) | OpenAI API | Pay-per-use | Deferred to V2 |
| No Docker | — | — | Not needed — serverless |
| No Redis | — | — | Not needed — no background workers |
| No VPS | — | — | Not needed — Supabase hosts everything |

### 5.5 Database & Infrastructure — Supabase Free

| Feature | Supabase Free Limit | Notes |
|---|---|---|
| PostgreSQL database | 500MB | Enough for ~10,000 shops |
| Authentication | 50,000 MAU | More than enough for Year 1 |
| File Storage | 1GB | Product images (compress to ~50KB each) |
| Realtime | 200 concurrent connections | Enough for early stage |
| Edge Functions | 500,000 invocations/month | More than enough |
| Bandwidth | 2GB/month | Watch this as you scale |
| Backups | 1 day point-in-time | Upgrade to Pro when you have revenue |

> **Free Tier Strategy:** Compress all product images to < 50KB before upload. Use Supabase storage transforms (built-in, free) to serve thumbnails. This keeps you under the 1GB storage limit much longer.

### 5.6 What You Do NOT Need (Common Expensive Mistakes to Avoid)

- ❌ **AWS / Google Cloud / Azure / Railway / Render** — All unnecessary. Supabase Edge Functions replace all server needs for V1.
- ❌ **Paid CI/CD (CircleCI, etc.)** — GitHub Actions free tier is enough
- ❌ **Paid error monitoring (Datadog, New Relic)** — Sentry free tier is enough
- ❌ **Redis / Upstash** — Not needed. No background workers in serverless architecture.
- ❌ **Paid SMS provider** — Using WhatsApp OTP (free) instead of expensive SMS
- ❌ **Paid push notifications** — flutter_local_notifications is on-device and free; Firebase FCM has a free tier for remote push when needed
- ❌ **Algolia search** — SQLite FTS5 (built into Drift) is free and fast enough for V1

---

## 6. Database Schema

All tables use UUID primary keys. All tables include `created_at` and `updated_at` timestamps. Row Level Security (RLS) is enabled on all tables — each shop can ONLY read/write its own data.

### 6.1 shops
```sql
CREATE TABLE shops (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id        UUID REFERENCES auth.users(id) NOT NULL,  -- Supabase Auth user
  name            TEXT NOT NULL,
  name_dari       TEXT,
  phone           TEXT,
  city            TEXT DEFAULT 'Kabul',
  district        TEXT,
  shop_type       TEXT CHECK (shop_type IN ('grocery','pharmacy','hardware','general','other')),
  currency_pref   TEXT DEFAULT 'AFN',
  language_pref   TEXT DEFAULT 'fa',  -- fa=Dari, ps=Pashto, en=English
  subscription_status TEXT DEFAULT 'trial' CHECK (subscription_status IN ('trial','active','expired','cancelled')),
  trial_ends_at   TIMESTAMPTZ DEFAULT now() + INTERVAL '30 days',
  subscription_ends_at TIMESTAMPTZ,
  created_at      TIMESTAMPTZ DEFAULT now(),
  updated_at      TIMESTAMPTZ DEFAULT now()
);
```

### 6.2 products
```sql
CREATE TABLE products (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id         UUID REFERENCES shops(id) ON DELETE CASCADE,
  name_dari       TEXT NOT NULL,
  name_pashto     TEXT,
  name_en         TEXT,
  barcode         TEXT,
  price           DECIMAL(12,2) NOT NULL,
  cost_price      DECIMAL(12,2),  -- for profit calculation
  stock_quantity  DECIMAL(12,3) DEFAULT 0,
  min_stock_alert DECIMAL(12,3) DEFAULT 5,
  unit            TEXT DEFAULT 'piece',  -- piece, kg, litre, pack
  category_id     UUID REFERENCES categories(id),
  image_url       TEXT,
  expiry_date     DATE,           -- for pharmacies
  is_active       BOOLEAN DEFAULT true,
  created_at      TIMESTAMPTZ DEFAULT now(),
  updated_at      TIMESTAMPTZ DEFAULT now()
);
```

### 6.3 customers
```sql
CREATE TABLE customers (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id         UUID REFERENCES shops(id) ON DELETE CASCADE,
  name            TEXT NOT NULL,
  phone           TEXT,
  total_owed      DECIMAL(12,2) DEFAULT 0,  -- running balance
  notes           TEXT,
  last_interaction_at TIMESTAMPTZ,
  created_at      TIMESTAMPTZ DEFAULT now(),
  updated_at      TIMESTAMPTZ DEFAULT now()
);
```

### 6.4 sales
```sql
CREATE TABLE sales (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id         UUID REFERENCES shops(id) ON DELETE CASCADE,
  customer_id     UUID REFERENCES customers(id),
  total_amount    DECIMAL(12,2) NOT NULL,
  total_afn       DECIMAL(12,2) NOT NULL,   -- always stored in AFN for reports
  discount        DECIMAL(12,2) DEFAULT 0,
  payment_method  TEXT CHECK (payment_method IN ('cash','credit','mixed')),
  currency        TEXT DEFAULT 'AFN',
  exchange_rate   DECIMAL(10,4) DEFAULT 1,
  is_credit       BOOLEAN DEFAULT false,
  note            TEXT,
  created_offline BOOLEAN DEFAULT false,    -- was this created without internet?
  local_id        TEXT,                     -- device-side temp ID for sync
  synced_at       TIMESTAMPTZ,
  created_at      TIMESTAMPTZ DEFAULT now(),
  updated_at      TIMESTAMPTZ DEFAULT now()
);
```

### 6.5 sale_items
```sql
CREATE TABLE sale_items (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sale_id     UUID REFERENCES sales(id) ON DELETE CASCADE,
  product_id  UUID REFERENCES products(id),
  product_name_snapshot TEXT NOT NULL,  -- store name at time of sale
  quantity    DECIMAL(12,3) NOT NULL,
  unit_price  DECIMAL(12,2) NOT NULL,
  subtotal    DECIMAL(12,2) NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT now()
);
```

### 6.6 debts
```sql
CREATE TABLE debts (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id               UUID REFERENCES shops(id) ON DELETE CASCADE,
  customer_id           UUID REFERENCES customers(id),
  sale_id               UUID REFERENCES sales(id),
  amount_original       DECIMAL(12,2) NOT NULL,
  amount_paid           DECIMAL(12,2) DEFAULT 0,
  amount_remaining      DECIMAL(12,2) GENERATED ALWAYS AS (amount_original - amount_paid) STORED,
  status                TEXT DEFAULT 'open' CHECK (status IN ('open','partial','paid','written_off')),
  due_date              DATE,
  last_reminder_sent_at TIMESTAMPTZ,
  notes                 TEXT,
  created_at            TIMESTAMPTZ DEFAULT now(),
  updated_at            TIMESTAMPTZ DEFAULT now()
);
```

### 6.7 debt_payments
```sql
CREATE TABLE debt_payments (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  debt_id         UUID REFERENCES debts(id) ON DELETE CASCADE,
  shop_id         UUID REFERENCES shops(id),
  amount          DECIMAL(12,2) NOT NULL,
  payment_method  TEXT DEFAULT 'cash',
  currency        TEXT DEFAULT 'AFN',
  notes           TEXT,
  created_at      TIMESTAMPTZ DEFAULT now()
);
```

### 6.8 inventory_adjustments
```sql
CREATE TABLE inventory_adjustments (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id         UUID REFERENCES shops(id) ON DELETE CASCADE,
  product_id      UUID REFERENCES products(id),
  quantity_before DECIMAL(12,3),
  quantity_after  DECIMAL(12,3),
  quantity_change DECIMAL(12,3) GENERATED ALWAYS AS (quantity_after - quantity_before) STORED,
  reason          TEXT CHECK (reason IN ('new_stock','damaged','expired','manual_count','theft','other')),
  notes           TEXT,
  adjusted_at     TIMESTAMPTZ DEFAULT now()
);
```

### 6.9 Supporting Tables

```sql
-- Product categories (per shop, customizable)
CREATE TABLE categories (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id     UUID REFERENCES shops(id) ON DELETE CASCADE,
  name_dari   TEXT NOT NULL,
  name_pashto TEXT,
  name_en     TEXT,
  icon        TEXT,   -- emoji or icon name
  color       TEXT,   -- hex color
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- Exchange rates cache (global, not per shop)
CREATE TABLE exchange_rates (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  from_currency TEXT NOT NULL,
  to_currency   TEXT NOT NULL,
  rate          DECIMAL(12,6) NOT NULL,
  fetched_at    TIMESTAMPTZ DEFAULT now(),
  UNIQUE(from_currency, to_currency)
);

-- Subscription billing records
CREATE TABLE subscriptions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id         UUID REFERENCES shops(id) ON DELETE CASCADE,
  plan            TEXT CHECK (plan IN ('trial','basic','pro','annual_basic')),
  amount_paid     DECIMAL(12,2),
  payment_method  TEXT,
  payment_ref     TEXT,  -- HesabPay transaction ID
  starts_at       TIMESTAMPTZ,
  ends_at         TIMESTAMPTZ,
  status          TEXT DEFAULT 'active',
  created_at      TIMESTAMPTZ DEFAULT now()
);

-- WhatsApp message audit log
CREATE TABLE whatsapp_logs (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id         UUID REFERENCES shops(id) ON DELETE CASCADE,
  customer_id     UUID REFERENCES customers(id),
  message_type    TEXT CHECK (message_type IN ('reminder','receipt','welcome','custom')),
  message_preview TEXT,
  status          TEXT DEFAULT 'sent',
  sent_at         TIMESTAMPTZ DEFAULT now()
);

-- AI insights per shop
CREATE TABLE ai_insights (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id         UUID REFERENCES shops(id) ON DELETE CASCADE,
  insight_type    TEXT CHECK (insight_type IN ('weekly_summary','low_stock','debt_alert','demand_forecast','anomaly')),
  content_dari    TEXT NOT NULL,
  content_en      TEXT,
  is_read         BOOLEAN DEFAULT false,
  generated_at    TIMESTAMPTZ DEFAULT now()
);

-- Multi-device tracking
CREATE TABLE devices (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id     UUID REFERENCES shops(id) ON DELETE CASCADE,
  device_id   TEXT NOT NULL,   -- Flutter device identifier
  platform    TEXT CHECK (platform IN ('android','ios')),
  app_version TEXT,
  last_sync_at TIMESTAMPTZ,
  created_at  TIMESTAMPTZ DEFAULT now(),
  UNIQUE(shop_id, device_id)
);

-- Offline sync queue
CREATE TABLE sync_queue (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id           UUID REFERENCES shops(id),
  device_id         TEXT,
  table_name        TEXT NOT NULL,
  record_id         TEXT NOT NULL,   -- local UUID before server assigns real UUID
  operation         TEXT CHECK (operation IN ('INSERT','UPDATE','DELETE')),
  payload           JSONB NOT NULL,
  synced_at         TIMESTAMPTZ,
  conflict_resolved BOOLEAN DEFAULT false,
  error_message     TEXT,
  created_at        TIMESTAMPTZ DEFAULT now()
);
```

### 6.10 Row Level Security (RLS)

```sql
-- Enable RLS on every table
ALTER TABLE shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;
-- ... (all tables)

-- Universal shop isolation policy pattern
CREATE POLICY shop_isolation ON products
  USING (shop_id IN (
    SELECT id FROM shops WHERE owner_id = auth.uid()
  ));

-- Shops table — only owner can read their own shop
CREATE POLICY own_shop_only ON shops
  USING (owner_id = auth.uid());
```

> **Critical:** This means even if your API has a bug, one shop CANNOT see another shop's data. Security is enforced at the database level.

---

## 7. Feature Specifications

### 7.1 Onboarding & Authentication

#### Authentication Model: Admin-Controlled Signup + Guest Demo Mode

**Production Flow (Paid Users Only):**
- **No self-registration** — Only admin can create accounts via admin panel
- User receives phone number + temporary password from sales agent/admin
- User enters phone number → receives WhatsApp OTP → sets their own password
- **Cost: $0** — No SMS provider needed, uses WhatsApp OTP
- Maximum 3 attempts before 15-minute lockout
- On success: JWT token issued, stored in Flutter Secure Storage
- Session refreshes automatically

**Why this model for Hesabat SaaS:**
- Controlled rollout — you approve every shop before they get access
- Sales-led growth — agents set up accounts during door-to-door visits
- Prevents free riders — no unauthorized access
- WhatsApp OTP is free and trusted by Afghan shopkeepers

**Guest/Demo Mode (For Testing):**
- Available in pre-production builds only
- Limited features: max 10 products, 5 sales, no sync, no WhatsApp
- Data stored locally only (no Supabase account created)
- Watermark on all screens: "DEMO MODE — Contact us for full access"
- Easy to reset/clear data

#### Shop Setup Wizard (5 Steps)
1. **Language selection** — Dari / Pashto / English (RTL layout activates automatically)
2. **Shop name and type** — grocery / pharmacy / hardware / general / other
3. **City and district** — dropdown for Kabul districts first, other cities
4. **Currency preference** — AFN primary, optional secondary: USD or PKR
5. **Add first 3 products** — barcode scan or voice to immediately show value

The wizard is skippable after step 2. Completion rate tracked as primary onboarding KPI.

---

### 7.2 Sales Recording — Zero-Typing Entry

#### 7.2.1 Barcode Scan Sale (Flow)
1. Tap **Sale** button → barcode scanner opens (camera)
2. Scan product barcode → product auto-populates (name, price, stock check)
3. Large +/− buttons to adjust quantity (one-hand friendly)
4. Scan more items to build cart
5. Select payment: **Cash / Credit (Qarz) / Mixed**
6. If credit → select or create customer (name + phone required)
7. Optional discount toggle (AFN amount OR percentage)
8. Currency selector: AFN / USD / PKR — auto-converts via cached rate
9. Confirm → receipt generated + stock decremented + debt created if credit

**Target: Complete in under 15 seconds for practiced user.**

#### 7.2.3 Quick Manual Sale
- Type/browse product name in Dari/Pashto/English (fuzzy search with SQLite FTS5)
- Numeric keypad only — no QWERTY shown
- Recent products list — one-tap repeat for common items

---

### 7.3 Qarz (Debt) Management — The Core Feature

> This is the #1 reason shopkeepers recommend the app to each other. Perfect this first.

#### 7.3.1 Debt Dashboard
- **Hero number:** Total outstanding owed to shop (large, prominent, AFN)
- Customer list sortable by: amount owed (desc) | oldest debt | last contact date
- Per-customer card: name, amount owed, days since last payment, action buttons
- Color coding: 🟢 < 7 days | 🟡 7–30 days | 🔴 > 30 days
- Search by name or phone number

#### 7.3.2 WhatsApp Debt Reminder (Viral Feature)
1. Tap **Send Reminder** on any customer
2. App generates professional Dari message:
   > `محترم [نام]، قرضه شما به دکان [نام دکان] به مبلغ [مقدار] افغانی است. لطفاً در اسرع وقت پرداخت کنید. تشکر.`
3. WhatsApp opens automatically with pre-filled message
4. Shopkeeper just taps **Send** — zero typing
5. Log entry created in whatsapp_logs with timestamp

**Why this is viral:** Every receipt/reminder says "Sent via حسابات" on the free plan. Customers ask: "Which app is this?" — the shopkeeper becomes your salesperson.

#### 7.3.3 Debt Payment Recording
- Tap customer → debt detail screen
- **Record Payment** → enter amount received
- Partial payments supported — running balance updates instantly
- PDF receipt generated on-device → shareable via WhatsApp
- Debt auto-marked **Paid** when balance = 0 → confetti animation 🎉
- customers.total_owed updated automatically via database trigger

---

### 7.4 Inventory Management

#### 7.4.1 Product Catalog
- Add via: barcode scan | voice | manual entry
- Pre-loaded database: ~500 common Afghan grocery/pharmacy products in Dari
- Fields: name (Dari/Pashto/English), price, cost price, stock, min alert, barcode, category, photo
- Bulk edit via spreadsheet-style table view

#### 7.4.2 Low Stock Alerts
- Every product has `min_stock_alert` threshold (default: 5 units)
- Stock drops below threshold → local notification + red badge on Inventory tab
- **Daily 8am digest:** list of all low-stock items as morning notification
- Low stock PDF report — shareable with supplier via WhatsApp

#### 7.4.3 Stock Take Mode
- Scan all products rapidly to reconcile physical vs system count
- Every adjustment logged with: reason, timestamp, before/after quantity
- Reasons: New Stock Received / Damaged / Expired / Manual Count / Other

---

### 7.5 Reports & Analytics (100% Offline)

#### Daily Summary (shown at 9pm as notification + always viewable)
- Total sales today (AFN)
- Cash received vs new qarz extended
- Qarz collected today
- Top 3 selling products
- Net profit estimate (if cost prices entered)

#### Available Reports

| Report | Time Range | Key Metrics |
|---|---|---|
| Sales Report | Daily/Weekly/Monthly/Custom | Revenue, transaction count, avg sale, payment method split |
| Qarz Report | Snapshot + trend | Total owed, by customer, aging, collection rate |
| Inventory Report | Current snapshot | Stock value, low items, fast/slow movers |
| Profit Report | Monthly | Revenue, COGS, gross profit |
| Customer Report | Monthly | Top customers, new vs returning, at-risk |

All reports exportable as PDF. All reports work 100% offline from local SQLite data.

---

### 7.6 Multi-Currency

- Supported: **AFN** (primary), **USD**, **PKR**
- Exchange rates fetched once daily from ExchangeRate-API (free, 1 request/day)
- Rates cached in Hive locally — work offline for up to 7 days
- Every transaction stores: original currency/amount + AFN equivalent
- All totals and reports in AFN by default with original currency shown in parentheses
- Last-updated timestamp always visible to user
- Currency toggle per-transaction — no setting change required

---

## 8. Offline-First Sync Architecture

### 8.1 Core Principle

```
Write to SQLite (local) FIRST → show user immediately → sync to Supabase in background

The user NEVER waits for a network response to complete any transaction.
```

Every table in local SQLite has a `sync_status` column: `pending | synced | conflict`

### 8.2 Sync Flow

```
[User records sale offline]
        ↓
SQLite write (immediate) → UI updates
        ↓
Record added to local sync_queue
        ↓
ConnectivityPlus detects internet
        ↓
Sync engine sends batch to Supabase
        ↓
Supabase responds with server UUIDs
        ↓
Local records updated: sync_status = 'synced'
        ↓
Green sync indicator shown to user
```

### 8.3 Conflict Resolution Rules

| Data Type | Strategy | Rationale |
|---|---|---|
| Sales | Append-only — never overwrite | Every sale is a unique event |
| Stock quantity | Sum all device adjustments since last sync | Each device sees its own changes |
| Debt balance | Server is authoritative — prompt user if different | Money data must be exact |
| Customer info | Last-updated-at wins | Simple, predictable |
| Product prices | Prompt user to choose if conflict | Price changes are intentional |

### 8.4 Retry Strategy
- First failure: retry after 30 seconds
- Second failure: retry after 2 minutes
- Third failure: retry after 10 minutes
- Fourth failure: retry after 1 hour
- After 6 hours: show sync warning banner to user

---

## 9. Flutter App Architecture

### 9.1 Folder Structure

```
lib/
├── core/
│   ├── database/           # Drift schema, DAOs, migrations
│   │   ├── app_database.dart
│   │   ├── daos/
│   │   │   ├── sales_dao.dart
│   │   │   ├── debts_dao.dart
│   │   │   ├── products_dao.dart
│   │   │   └── customers_dao.dart
│   │   └── tables/
│   ├── sync/               # Offline sync engine
│   │   ├── sync_service.dart
│   │   ├── sync_queue.dart
│   │   └── conflict_resolver.dart
│   ├── network/            # Dio client, interceptors
│   │   ├── api_client.dart
│   │   └── connectivity_service.dart
│   ├── auth/               # Supabase auth wrapper
│   │   ├── auth_service.dart
│   │   └── auth_provider.dart
│   # ai/                   # V2 — AI services
│   └── utils/
│       ├── currency_formatter.dart
│       ├── date_formatter.dart
│       └── pdf_generator.dart
├── features/
│   ├── onboarding/
│   │   ├── screens/
│   │   │   ├── language_selection_screen.dart
│   │   │   ├── shop_setup_screen.dart
│   │   │   └── first_product_screen.dart
│   │   └── providers/
│   ├── sales/
│   │   ├── screens/
│   │   │   ├── sale_screen.dart        # Main sale entry
│   │   │   ├── barcode_scan_screen.dart
│   │   │   └── sale_confirmation_screen.dart
│   │   ├── widgets/
│   │   │   ├── cart_item_widget.dart
│   │   │   ├── voice_record_button.dart
│   │   │   └── currency_selector.dart
│   │   └── providers/
│   │       └── sale_provider.dart
│   ├── qarz/
│   │   ├── screens/
│   │   │   ├── qarz_dashboard_screen.dart
│   │   │   ├── customer_debt_screen.dart
│   │   │   └── record_payment_screen.dart
│   │   ├── widgets/
│   │   │   ├── debt_card_widget.dart
│   │   │   └── whatsapp_reminder_button.dart
│   │   └── providers/
│   ├── inventory/
│   │   ├── screens/
│   │   └── providers/
│   ├── customers/
│   ├── reports/
│   │   ├── screens/
│   │   │   ├── reports_home_screen.dart
│   │   │   ├── sales_report_screen.dart
│   │   │   └── qarz_report_screen.dart
│   │   └── providers/
│   ├── settings/
│   │   ├── screens/
│   │   │   ├── settings_screen.dart
│   │   │   └── subscription_screen.dart
│   │   └── providers/
│   # ai_insights/          # V2 — AI insight cards
├── shared/
│   ├── widgets/
│   │   ├── app_button.dart
│   │   ├── app_text_field.dart
│   │   ├── loading_indicator.dart
│   │   └── sync_status_bar.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_theme.dart
│   └── l10n/
│       ├── app_fa.arb          # Dari translations
│       ├── app_ps.arb          # Pashto translations
│       └── app_en.arb          # English translations
└── main.dart
```

### 9.2 State Management (Riverpod Pattern)

Every feature follows this exact pattern:

```dart
// 1. Repository — data access only
class SalesRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final SyncQueue _syncQueue;

  Future<void> recordSale(Sale sale) async {
    // ALWAYS write local first
    await _db.salesDao.insert(sale.copyWith(syncStatus: 'pending'));
    // Queue for background sync
    await _syncQueue.add(table: 'sales', record: sale);
    // Sync in background — don't await
    unawaited(_syncQueue.processNext());
  }
}

// 2. Notifier — business logic
@riverpod
class SaleNotifier extends _$SaleNotifier {
  @override
  SaleState build() => SaleState.initial();

  Future<void> addItem(Product product, double quantity) async {
    // pure business logic, no UI
  }

  Future<SaleResult> confirmSale(PaymentMethod method) async {
    // calls repository, returns result
  }
}

// 3. Widget — pure UI, zero business logic
class SaleScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(saleNotifierProvider);
    // render UI based on state
  }
}
```

### 9.3 Localization (RTL Support)

```dart
// main.dart — full RTL + i18n setup
MaterialApp.router(
  localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('fa'), // Dari — RTL
    Locale('ps'), // Pashto — RTL
    Locale('en'), // English — LTR
  ],
  // Flutter automatically mirrors all widgets for RTL locales
  // No manual RTL handling needed for standard widgets
)
```

### 9.4 App Theme

```dart
// app_colors.dart
class AppColors {
  static const primary     = Color(0xFF1A56A0); // Blue — primary actions
  static const success     = Color(0xFF1A7A4A); // Green — payments, positive
  static const warning     = Color(0xFFC0580A); // Orange — low stock, due debts
  static const danger      = Color(0xFFB91C1C); // Red — overdue, errors
  static const background  = Color(0xFFF8FAFC); // App background
  static const surface     = Color(0xFFFFFFFF); // Cards
  static const textPrimary = Color(0xFF1A1A2E); // Body text
  static const textSecondary = Color(0xFF64748B); // Labels
}
```

---

## 10. Serverless Backend — Supabase Edge Functions

> There is no server. No Python. No Docker. No VPS. No Redis. No Celery.
> All backend logic runs as TypeScript Edge Functions hosted by Supabase — for free.

### 10.1 What Are Edge Functions?

Supabase Edge Functions are small TypeScript/Deno functions that:
- Run on Supabase's global infrastructure (no deployment config needed)
- Are triggered by HTTP requests OR by a schedule (pg_cron)
- Have direct access to your PostgreSQL database and Supabase Auth
- Deploy with a single command: `supabase functions deploy function-name`
- Cost: **$0** — 500,000 invocations/month on free tier

### 10.2 Project Folder Structure

```
hesabat/
├── supabase/
│   ├── functions/
│   │   ├── exchange-rates/
│   │   │   └── index.ts          # Fetches AFN/USD/PKR rates daily
│   │   ├── hesabpay-webhook/
│   │   │   └── index.ts          # Receives payment confirmation from HesabPay
│   │   ├── sync-conflicts/
│   │   │   └── index.ts          # Resolves offline sync conflicts
│   │   └── _shared/
│   │       ├── cors.ts            # Shared CORS headers
│   │       └── auth.ts            # Shared JWT verification helper
│   ├── migrations/
│   │   ├── 001_initial_schema.sql
│   │   ├── 002_shop_types.sql
│   │   └── 003_product_templates.sql
│   ├── seed/
│   │   ├── grocery_products.sql
│   │   ├── pharmacy_products.sql
│   │   ├── hardware_products.sql
│   │   └── category_templates.sql
│   └── config.toml
├── lib/                           # Flutter app
└── pubspec.yaml
```

### 10.3 Edge Function: Exchange Rates (Daily Sync)

This replaces the entire Python Celery beat scheduler + rate_sync worker.

```typescript
// supabase/functions/exchange-rates/index.ts
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

Deno.serve(async (_req) => {
  try {
    // Fetch from ExchangeRate-API (free tier — 1,500 req/month)
    const res = await fetch(
      `https://v6.exchangerate-api.com/v6/${Deno.env.get('EXCHANGE_RATE_API_KEY')}/latest/AFN`
    )
    const data = await res.json()

    // Upsert AFN → USD and AFN → PKR rates
    const { error } = await supabase
      .from('exchange_rates')
      .upsert([
        { from_currency: 'AFN', to_currency: 'USD', rate: data.conversion_rates.USD, fetched_at: new Date() },
        { from_currency: 'AFN', to_currency: 'PKR', rate: data.conversion_rates.PKR, fetched_at: new Date() },
        { from_currency: 'USD', to_currency: 'AFN', rate: 1 / data.conversion_rates.USD, fetched_at: new Date() },
        { from_currency: 'PKR', to_currency: 'AFN', rate: 1 / data.conversion_rates.PKR, fetched_at: new Date() },
      ], { onConflict: 'from_currency,to_currency' })

    if (error) throw error

    return new Response(JSON.stringify({ success: true }), {
      headers: { 'Content-Type': 'application/json' }
    })
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500 })
  }
})
```

**Schedule this with pg_cron (runs inside Supabase PostgreSQL — free):**
```sql
-- Run exchange rate sync every day at 6:00am Afghanistan time (01:30 UTC)
SELECT cron.schedule(
  'daily-exchange-rates',
  '30 1 * * *',
  $$SELECT net.http_post(
    url := 'https://your-project.supabase.co/functions/v1/exchange-rates',
    headers := jsonb_build_object('Authorization', 'Bearer ' || current_setting('app.service_role_key'))
  )$$
);
```

### 10.4 Edge Function: HesabPay Webhook

This receives payment confirmations from HesabPay and activates subscriptions.
No Python needed — handles the HMAC verification and database update directly.

```typescript
// supabase/functions/hesabpay-webhook/index.ts
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { hmac } from 'https://deno.land/x/hmac@v2.0.1/mod.ts'

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!  // service role bypasses RLS for admin ops
)

Deno.serve(async (req) => {
  const body = await req.text()
  const signature = req.headers.get('x-hesabpay-signature') ?? ''

  // 1. Verify HMAC-SHA256 signature from HesabPay
  const expectedSig = await hmac('sha256', Deno.env.get('HESABPAY_WEBHOOK_SECRET')!, body, 'utf8', 'hex')
  if (signature !== expectedSig) {
    return new Response('Unauthorized', { status: 401 })
  }

  const payload = JSON.parse(body)

  // 2. Only process successful payments
  if (payload.status !== 'SUCCESS') {
    return new Response('ignored', { status: 200 })
  }

  // 3. Activate subscription for the shop
  const { error } = await supabase
    .from('subscriptions')
    .insert({
      shop_id: payload.metadata.shop_id,
      plan: payload.metadata.plan,
      amount_paid: payload.amount,
      payment_method: 'hesabpay',
      payment_ref: payload.transaction_id,
      starts_at: new Date(),
      ends_at: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // +30 days
      status: 'active'
    })

  // 4. Update shop subscription status
  await supabase
    .from('shops')
    .update({
      subscription_status: 'active',
      subscription_ends_at: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)
    })
    .eq('id', payload.metadata.shop_id)

  if (error) return new Response(JSON.stringify({ error }), { status: 500 })
  return new Response(JSON.stringify({ success: true }), { status: 200 })
})
```

### 10.5 Edge Function: Sync Conflict Resolution

Handles the rare case where two devices edited the same record while offline.

```typescript
// supabase/functions/sync-conflicts/index.ts
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

Deno.serve(async (req) => {
  // Verify JWT — only authenticated shop owners can call this
  const jwt = req.headers.get('Authorization')?.replace('Bearer ', '')
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_ANON_KEY')!,
    { global: { headers: { Authorization: `Bearer ${jwt}` } } }
  )

  const { conflicts } = await req.json()
  const results = []

  for (const conflict of conflicts) {
    const { table, local_record, server_record, resolution } = conflict

    if (resolution === 'use_local') {
      // Client chose local version — update server
      const { error } = await supabase
        .from(table)
        .update(local_record)
        .eq('id', local_record.id)
      results.push({ id: local_record.id, resolved: !error })

    } else {
      // Client chose server version — just mark as resolved
      results.push({ id: server_record.id, resolved: true, use_server: true })
    }
  }

  return new Response(JSON.stringify({ results }), {
    headers: { 'Content-Type': 'application/json' }
  })
})
```

### 10.6 What Flutter Calls Directly (No Edge Function Needed)

The beauty of Supabase is that Flutter can talk to the database DIRECTLY for most operations.
Edge Functions are only needed for things that require server-side secrets or scheduling.

| Operation | How Flutter Does It | Edge Function Needed? |
|---|---|---|
| Record a sale | `supabase.from('sales').insert(...)` | ❌ No |
| Track qarz | `supabase.from('debts').insert(...)` | ❌ No |
| Load products | `supabase.from('products').select(...)` | ❌ No |
| Sync offline data | `supabase.from('sales').upsert(...)` | ❌ No |
| Get exchange rates | `supabase.from('exchange_rates').select(...)` | ❌ No (already synced by cron) |
| WhatsApp reminder | `url_launcher` deep link — pure Flutter | ❌ No |
| Generate PDF receipt | `pdf` package — pure Flutter, on-device | ❌ No |
| Authenticate | `supabase.auth.signInWithOtp(...)` | ❌ No |
| Get subscription status | `supabase.from('shops').select(...)` | ❌ No |
| **Receive HesabPay payment** | — | ✅ Yes (needs secret key) |
| **Daily exchange rate fetch** | — | ✅ Yes (needs API key + scheduling) |
| **Resolve sync conflicts** | — | ✅ Yes (needs server authority) |
| **V2: AI features** | — | ✅ Yes (needs OpenAI key) |

**Result: Only 3 Edge Functions needed for V1. Everything else is direct Supabase calls from Flutter.**

### 10.7 Deployment — One Command

```bash
# Install Supabase CLI (one time)
npm install -g supabase

# Login
supabase login

# Link to your project
supabase link --project-ref your-project-id

# Deploy all edge functions
supabase functions deploy exchange-rates
supabase functions deploy hesabpay-webhook
supabase functions deploy sync-conflicts

# Set environment variables (secrets)
supabase secrets set EXCHANGE_RATE_API_KEY=your-key
supabase secrets set HESABPAY_WEBHOOK_SECRET=your-secret

# Run migrations
supabase db push

# That's it. No servers. No Docker. No Nginx.
```

### 10.8 Local Development

```bash
# Run Supabase locally (Docker required for local dev only — not for production)
supabase start

# This spins up a local Supabase instance with:
# - PostgreSQL on localhost:54322
# - Edge Functions runtime on localhost:54321
# - Auth server
# - Storage server

# Serve edge functions locally for testing
supabase functions serve exchange-rates --env-file .env.local
```

---

## 11. Shop Type System & Product Catalog Filters

> **The Core Idea:** When a shopkeeper signs up, they choose their shop type. From that moment, the entire app — product catalog, default categories, units, fields, terminology — is tailored to their specific business. A pharmacy owner never sees "cola" in suggestions. A grocery owner never sees "amoxicillin."

### 11.1 Supported Shop Types (V1)

| Shop Type | Dari Label | Description |
|---|---|---|
| `grocery` | سوپرمارکت / کرایه‌فروشی | General grocery, kiryana store, supermarket |
| `pharmacy` | دواخانه | Medicine, health products, medical supplies |
| `hardware` | آهن‌فروشی / سخت‌افزار | Building materials, tools, hardware |
| `electronics` | الکترونیک | Mobile phones, appliances, accessories |
| `clothing` | لباس‌فروشی | Clothing, fabric, tailoring supplies |
| `bakery` | نانوایی / بیکری | Bread, pastries, food production |
| `restaurant` | رستورانت / کافه | Food service, cafe, fast food |
| `general` | دکان عمومی | Mixed/other — uses default catalog |

> New shop types can be added in V2 without any schema changes. The system is designed to extend easily.

---

### 11.2 How Shop Type Filtering Works

Shop type filtering operates at **three levels**:

#### Level 1 — Pre-loaded Product Catalog (Seeded Data)
When a shop is created, the app seeds their local SQLite database with a **type-specific product catalog**. These are starting suggestions — the shopkeeper can edit, delete, or add their own.

```
Pharmacy signs up → 500 medicine products pre-loaded (Dari names)
Grocery signs up  → 500 grocery items pre-loaded (Dari names)
Hardware signs up → 300 hardware items pre-loaded (Dari names)
```

No cross-contamination. A pharmacist never sees flour in their product list.

#### Level 2 — Category System (Per Shop Type)
Each shop type has its own **default category tree**. Categories are pre-created on signup and fully customizable.

#### Level 3 — Field Visibility (Shop-Type-Specific Fields)
Certain product fields only appear for relevant shop types:

| Field | Grocery | Pharmacy | Hardware | Electronics |
|---|---|---|---|---|
| Expiry Date | ❌ | ✅ Required | ❌ | ❌ |
| Dosage / Strength | ❌ | ✅ Optional | ❌ | ❌ |
| Manufacturer | ❌ | ✅ Optional | ✅ Optional | ✅ Optional |
| Weight / Volume | ✅ | ✅ | ❌ | ❌ |
| Color / Size variants | ❌ | ❌ | ✅ | ✅ |
| Piece / Set count | ❌ | ❌ | ✅ | ✅ |
| Prescription required | ❌ | ✅ | ❌ | ❌ |

---

### 11.3 Default Categories Per Shop Type

#### 🛒 Grocery (`grocery`)
| Category (Dari) | Category (English) | Common Units |
|---|---|---|
| غلات و آرد | Grains & Flour | kg, 50kg bag |
| روغن و چربی | Oils & Fats | litre, kg |
| چای و قهوه | Tea & Coffee | pack, kg, box |
| لبنیات | Dairy Products | litre, piece |
| مواد تمیزکاری | Cleaning Products | bottle, piece, pack |
| نوشیدنی | Beverages | bottle, can, pack |
| تنباکو | Tobacco | pack, piece |
| مواد خشک | Dry Goods | kg, pack |
| تازه‌جات | Fresh Produce | kg, piece |
| سایر | Other | piece |

#### 💊 Pharmacy (`pharmacy`)
| Category (Dari) | Category (English) | Special Fields |
|---|---|---|
| آنتی‌بیوتیک | Antibiotics | expiry_date, prescription_required |
| مسکن‌ها | Pain Relief | expiry_date, dosage |
| ویتامین‌ها | Vitamins & Supplements | expiry_date |
| داروهای قلبی | Cardiac Medications | expiry_date, prescription_required |
| داروهای دیابت | Diabetes Medications | expiry_date, prescription_required |
| پانسمان و زخم | Wound Care | expiry_date |
| وسایل پزشکی | Medical Devices | — |
| داروهای کودکان | Pediatric Medications | expiry_date, dosage |
| شامپو و پوست | Dermatology & Hair | expiry_date |
| سایر داروها | Other Medications | expiry_date |

#### 🔧 Hardware (`hardware`)
| Category (Dari) | Category (English) | Common Units |
|---|---|---|
| میله و آهن | Steel & Iron | kg, metre, piece |
| سیمان و گچ | Cement & Plaster | bag, kg |
| رنگ و پوشش | Paint & Coating | litre, kg, can |
| لوله و اتصالات | Pipes & Fittings | piece, metre |
| ابزار | Tools | piece, set |
| برق و کابل | Electrical & Cable | metre, piece, roll |
| پیچ و مهره | Bolts & Nuts | piece, pack, kg |
| درب و پنجره | Doors & Windows | piece |
| سایر | Other | piece |

#### 📱 Electronics (`electronics`)
| Category (Dari) | Category (English) | Special Fields |
|---|---|---|
| موبایل | Mobile Phones | IMEI, color, storage |
| لپ‌تاپ | Laptops | serial_number, specs |
| لوازم جانبی | Accessories | color, compatibility |
| تلویزیون | TVs & Displays | size, resolution |
| باتری و شارژر | Batteries & Chargers | compatibility |
| سیم‌کارت و نت | SIM & Data | operator |
| سایر | Other | — |

#### 👗 Clothing (`clothing`)
| Category (Dari) | Category (English) | Special Fields |
|---|---|---|
| لباس مردانه | Men's Clothing | size, color |
| لباس زنانه | Women's Clothing | size, color |
| لباس کودکان | Children's Clothing | size, age_range |
| پارچه | Fabric | metre, color |
| کفش | Shoes | size, color |
| اکسسوری | Accessories | color |
| سایر | Other | — |

#### 🍞 Bakery (`bakery`)
| Category (Dari) | Category (English) | Common Units |
|---|---|---|
| نان | Bread | piece, kg |
| شیرینی | Pastries & Sweets | piece, kg, box |
| کیک | Cakes | piece, kg |
| مواد اولیه | Raw Ingredients | kg, litre |
| بسته‌بندی | Packaging | piece, pack |

#### 🍽️ Restaurant / Cafe (`restaurant`)
| Category (Dari) | Category (English) | Notes |
|---|---|---|
| غذای اصلی | Main Dishes | sold by portion |
| نوشیدنی | Beverages | sold by glass/bottle |
| دسر | Desserts | sold by piece |
| صبحانه | Breakfast | sold by plate |
| سفارش خاص | Special Orders | custom |

---

### 11.4 Database Implementation

#### products table additions
```sql
-- Add shop-type-aware fields to products table
ALTER TABLE products ADD COLUMN expiry_date DATE;           -- pharmacy
ALTER TABLE products ADD COLUMN prescription_required BOOLEAN DEFAULT false; -- pharmacy
ALTER TABLE products ADD COLUMN dosage TEXT;                -- pharmacy (e.g. "500mg")
ALTER TABLE products ADD COLUMN manufacturer TEXT;          -- pharmacy, hardware, electronics
ALTER TABLE products ADD COLUMN color TEXT;                 -- clothing, electronics
ALTER TABLE products ADD COLUMN size_variant TEXT;          -- clothing, electronics
ALTER TABLE products ADD COLUMN imei TEXT;                  -- electronics (phones)
ALTER TABLE products ADD COLUMN serial_number TEXT;         -- electronics (laptops)
ALTER TABLE products ADD COLUMN weight_grams INTEGER;       -- grocery, pharmacy
```

#### product_templates table (seeded catalog — NOT per shop)
```sql
-- Global template catalog — seeded once, never modified by shops
CREATE TABLE product_templates (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_type   TEXT NOT NULL,   -- which shop type this belongs to
  name_dari   TEXT NOT NULL,
  name_pashto TEXT,
  name_en     TEXT,
  barcode     TEXT,
  default_unit TEXT,
  category_slug TEXT,          -- maps to default category
  tags        TEXT[],          -- for search
  is_active   BOOLEAN DEFAULT true
);

-- Index for fast lookup by shop type
CREATE INDEX idx_templates_shop_type ON product_templates(shop_type);
CREATE INDEX idx_templates_search ON product_templates USING GIN(to_tsvector('simple', name_dari));
```

#### category_templates table (default categories per shop type)
```sql
CREATE TABLE category_templates (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_type   TEXT NOT NULL,
  name_dari   TEXT NOT NULL,
  name_pashto TEXT,
  name_en     TEXT,
  icon        TEXT,
  color       TEXT,
  sort_order  INTEGER DEFAULT 0
);
```

---

### 11.5 Flutter Implementation

#### ShopType Enum
```dart
// core/models/shop_type.dart
enum ShopType {
  grocery,
  pharmacy,
  hardware,
  electronics,
  clothing,
  bakery,
  restaurant,
  general;

  String get labelDari => switch (this) {
    ShopType.grocery     => 'سوپرمارکت',
    ShopType.pharmacy    => 'دواخانه',
    ShopType.hardware    => 'آهن‌فروشی',
    ShopType.electronics => 'الکترونیک',
    ShopType.clothing    => 'لباس‌فروشی',
    ShopType.bakery      => 'نانوایی',
    ShopType.restaurant  => 'رستورانت',
    ShopType.general     => 'دکان عمومی',
  };

  String get icon => switch (this) {
    ShopType.grocery     => '🛒',
    ShopType.pharmacy    => '💊',
    ShopType.hardware    => '🔧',
    ShopType.electronics => '📱',
    ShopType.clothing    => '👗',
    ShopType.bakery      => '🍞',
    ShopType.restaurant  => '🍽️',
    ShopType.general     => '🏪',
  };

  // Which extra fields to show in product form
  bool get showExpiryDate => this == ShopType.pharmacy || this == ShopType.bakery || this == ShopType.restaurant;
  bool get showDosage => this == ShopType.pharmacy;
  bool get showColorSize => this == ShopType.clothing || this == ShopType.electronics;
  bool get showImei => this == ShopType.electronics;
  bool get showPrescription => this == ShopType.pharmacy;
}
```

#### Product Form — Dynamic Fields Based on Shop Type
```dart
// features/inventory/widgets/product_form.dart
class ProductFormWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopType = ref.watch(shopTypeProvider);

    return Column(children: [
      // Always shown
      NameField(),
      PriceField(),
      StockField(),
      BarcodeField(),

      // Pharmacy only
      if (shopType.showExpiryDate) ExpiryDateField(),
      if (shopType.showDosage) DosageField(),
      if (shopType.showPrescription) PrescriptionToggle(),

      // Clothing / Electronics only
      if (shopType.showColorSize) ColorSizeField(),

      // Electronics only
      if (shopType.showImei) ImeiField(),
    ]);
  }
}
```

#### Seeding on Shop Setup
```dart
// core/database/seeders/catalog_seeder.dart
class CatalogSeeder {
  final AppDatabase _db;

  Future<void> seedForShopType(ShopType shopType) async {
    // 1. Fetch templates from Supabase for this shop type
    final templates = await supabase
      .from('product_templates')
      .select()
      .eq('shop_type', shopType.name)
      .limit(500);

    // 2. Insert into local SQLite as shop's own products
    await _db.batch((batch) {
      for (final t in templates) {
        batch.insert(_db.products, ProductsCompanion.insert(
          shopId: currentShopId,
          nameDari: t['name_dari'],
          namePashto: Value(t['name_pashto']),
          nameEn: Value(t['name_en']),
          barcode: Value(t['barcode']),
          unit: Value(t['default_unit'] ?? 'piece'),
          price: 0,  // shopkeeper sets their own prices
          stockQuantity: 0,
          syncStatus: 'pending',
        ));
      }
    });

    // 3. Seed default categories
    await _seedCategories(shopType);
  }
}
```

---

### 11.6 Onboarding Impact

The shop type selection (step 2 of the wizard) now drives everything downstream:

```
User selects "دواخانه" (Pharmacy)
        ↓
App seeds: 500 medicine products in Dari
        ↓
App creates: 10 pharmacy default categories
        ↓
Product form shows: expiry date, dosage, prescription fields
        ↓
Units default to: piece, strip, bottle, ml, mg
        ↓
Low stock alerts use: expiry date as ADDITIONAL alert type
        ↓
Search suggestions show: medicines, not groceries
```

The shopkeeper opens the app for the first time and it **already speaks their language** — not just linguistically, but professionally.


## 12. Subscription & Monetization

### 12.1 Pricing Plans

| Plan | Price | Features |
|---|---|---|
| **Free Trial** | 0 AFN (30 days) | All features, 1 device, 50 products max |
| **Basic** | 400 AFN/month | All features, 1 device, unlimited products |
| **Annual Basic** | 3,600 AFN/year (~300/month) | Same as Basic — 25% savings |
| **Pro** | 700 AFN/month | All features, 3 devices, daily AI insights, priority support |

### 12.2 Feature Gating

| Feature | Free Trial | Basic | Pro |
|---|---|---|---|
| Products | 50 max | Unlimited | Unlimited |
| Devices | 1 | 1 | 3 |
| WhatsApp reminders/month | 10 | 100 | Unlimited |
| Voice entry (V2) | — | — | — |
| PDF export | 5/month | Unlimited | Unlimited |
| Cloud backup | None | Daily | Daily + export |
| "Sent via حسابات" watermark | ✅ | ❌ | ❌ |

### 12.3 Payment Methods (Afghanistan Reality)

1. **HesabPay** — primary Afghan payment gateway (card + mobile wallet)
2. **Bank transfer** — manual confirmation for shops without HesabPay
3. **Cash** — collected by sales agent in-person, recorded manually in admin panel
4. **Airtime credit** — Phase 2 (MTN/Roshan partnership investigation)

### 12.4 Revenue Projections

| Month | Paying Shops | MRR (AFN) | MRR (USD) |
|---|---|---|---|
| 3 | 25 | 10,000 | ~$72 |
| 6 | 100 | 40,000 | ~$290 |
| 9 | 220 | 88,000 | ~$635 |
| 12 | 400 | 160,000 | ~$1,155 |
| 18 | 1,000 | 400,000 | ~$2,880 |
| 24 | 3,000 | 1,200,000 | ~$8,640 |
| Year 3 | 10,000 | 4,000,000 | ~$28,800 |

---

## 13. Go-To-Market Strategy

### Phase 1 — Neighborhood Playbook (Months 1–3)

> Do NOT advertise. Do NOT run social media. Go door to door.

1. Choose one neighborhood in Kabul (recommended: Karte Char or Taimani)
2. Visit every shop personally with a demo phone loaded with sample data
3. Give free 30-day trial — no signup friction
4. **Set up the app FOR the shopkeeper** in the first 5 minutes of the visit
5. Import their existing qarz notebook data manually as demonstration
6. Follow up after one week: "Did you recover any debts?"
7. When they say yes — ask for referrals to neighboring shops

**Month 1 Target:** 10 paying shops from 50 demos.

### The Viral Mechanic

Every WhatsApp receipt sent from the free plan includes:
> `"ارسال شده از طریق حسابات"`

The customer receives a professional receipt and asks the shopkeeper: "Which app is this?" The shopkeeper becomes your unpaid salesperson.

### Phase 2 — City-Wide (Months 4–9)

- Hire 2–3 part-time sales agents on commission: 50 AFN per activated paid account
- Target all Kabul districts — one district per week
- Partner with wholesale suppliers to reach all their retailer customers at once
- Join existing Afghan shopkeeper WhatsApp groups and share demo videos

### Phase 3 — National (Months 10–18)

- Replicate Kabul playbook in Herat, Mazar, Kandahar, Jalalabad
- Regional distributor model: local entrepreneurs earn revenue share
- Radio advertising on local Afghan stations (highest rural reach)
- NGO partnerships for bundled subscriptions to SME programs

---

## 14. Development Roadmap

### Phase 1 — MVP (Months 1–3, 12 Sprints × 2 Weeks)

| Sprint | Duration | Deliverables |
|---|---|---|
| S1 | 2 weeks | Project setup: Flutter + Drift + Supabase CLI. Phone auth flow. Shop setup wizard. Database migrations. RLS policies. |
| S2 | 2 weeks | Product catalog (CRUD + barcode scan). Basic sale recording (manual). Local SQLite storage. |
| S3 | 2 weeks | Qarz management (create/track/pay). WhatsApp url_launcher reminder. Customer directory. |
| S4 | 2 weeks | Inventory low-stock alerts. Daily summary screen. Multi-currency with cached rates. |
| S5 | 2 weeks | Supabase sync engine (offline → cloud). Conflict resolution UI. |
| S6 | 2 weeks | Dari/Pashto/English localization. RTL polish. PDF receipt generation. Beta with 5 real shops. |

**MVP Definition:** A shopkeeper can record a sale, track qarz, send WhatsApp reminder, and see daily summary — all without internet.

### Phase 2 — Full Launch (Months 4–6)

| Sprint | Duration | Deliverables |
|---|---|---|
| S7 | 2 weeks | Shop type system. Pre-loaded product catalogs (grocery/pharmacy/hardware/electronics/clothing). Dynamic product form fields. |
| S8 | 2 weeks | Advanced reports with fl_chart visualizations. PDF export for all reports. Push notifications. |
| S9 | 2 weeks | Subscription system (HesabPay). Free trial enforcement. Plan upgrade flow. |
| S10 | 2 weeks | Advanced reports with fl_chart visualizations. PDF export for all reports. |
| S11 | 2 weeks | iOS build + App Store submission. Android Play Store submission. Performance pass. |
| S12 | 2 weeks | Sentry monitoring. Admin support dashboard. Production launch. 🚀 |

### Phase 3 — Growth Features (Months 7–12)

| Feature | Priority | Description |
|---|---|---|
| Supplier Debt (Reverse Qarz) | High | Track what the shop owes to its own suppliers |
| Employee Access | High | Staff accounts with sale-entry-only permission |
| Demand Forecasting (V2) | Medium | AI predicts reorder needs — planned for V2 |
| Expiry Date Tracking | Medium | Pharmacy-critical — alert before medicine expires |
| WhatsApp Business API | Medium | Upgrade from url_launcher to direct API |
| Bulk CSV Import | Low | Import product catalog from Excel |
| Customer Loyalty | Low | Simple stamp card / points system |

---

## 15. Non-Functional Requirements

| Requirement | Target | Rationale |
|---|---|---|
| App startup time | < 2 seconds cold start | Shopkeepers open during active sales |
| Sale recording time | < 15 seconds end-to-end | Must beat the paper notebook |
| Offline data persistence | 100% — zero data loss | Power cuts are daily |
| Sync time on reconnect | < 30 seconds for 500 queued records | User needs confidence in sync |
| APK size | < 30MB | Budget Android devices have limited storage |
| Min Android version | Android 8.0 (API 26) | Covers ~95% of Afghan Android devices |
| Min iOS version | iOS 14.0 | Covers ~95% of iPhones in Afghanistan |
| RAM usage | < 150MB active | Budget phones have 2–3GB total |
| Supabase uptime | > 99.9% monthly | Supabase SLA covers Edge Functions + DB |
| Edge Function response | < 500ms p95 (< 300ms warm, ~1s cold start) | Acceptable for webhook/sync use cases |
| Data security | AES-256 local, TLS 1.3 in transit | Financial data requirement |
| Language support | Dari + Pashto + English | Non-negotiable for target market |

---

## 16. Security Requirements

### Authentication
- Phone + OTP only — no passwords stored anywhere
- JWT tokens: 7-day expiry, refresh tokens: 90-day expiry
- All tokens in Flutter Secure Storage (iOS Keychain / Android Keystore)
- Row Level Security at database level — not just API level

### Data Protection
- Local SQLite encrypted with SQLCipher
- All traffic over TLS 1.3 — Supabase enforces this on all connections including Edge Functions
- No PII (phone numbers, names) in Sentry error logs — masked automatically
- Supabase storage: all image URLs are private (signed URLs only, expire in 1 hour)
- Users can request full data export or deletion from Settings screen

### Payment Security
- HesabPay webhook validated with HMAC-SHA256 signature
- Subscription status always server-authoritative — client cannot self-upgrade
- No card data ever reaches our servers — HesabPay hosted checkout only

---

## 17. Testing Strategy

| Test Type | Tool | Coverage Target | Focus |
|---|---|---|---|
| Unit Tests (Flutter) | flutter_test | 80% business logic | Sale math, debt calculations, currency conversion, sync queue |
| Widget Tests (Flutter) | flutter_test | Key screens | Sale entry, qarz dashboard, onboarding |
| Integration Tests (Flutter) | integration_test | Critical journeys | Full sale → debt → payment → WhatsApp flow |
| Edge Function Tests | Deno test + Supabase CLI | All edge functions | HesabPay webhook, exchange rate sync, conflict resolution |
| Offline Tests (Flutter) | flutter_test | All offline scenarios | Sale offline, sync on reconnect, conflict resolution |
| Real Device Testing | Manual | 3 device types | Samsung A15, Tecno Spark (~$60), iPhone SE |

---

## 18. Success Metrics & KPIs

### Product KPIs

| KPI | Month 3 | Month 12 |
|---|---|---|
| Sale entry time (avg) | < 20 seconds | < 12 seconds |
| Onboarding completion rate | > 70% | > 80% |
| Qarz recovery rate (30-day) | > 65% | > 80% |
| Monthly churn rate | < 12% | < 8% |
| Daily Active / Paying ratio | > 60% | > 70% |
| App crash rate (per 1K sessions) | < 5 | < 1 |
| Sync failure rate | < 2% | < 0.5% |

### Business KPIs

| KPI | Month 6 | Month 12 | Month 24 |
|---|---|---|---|
| Paying shops | 100 | 400 | 3,000 |
| MRR (AFN) | 40,000 | 160,000 | 1,200,000 |
| CAC (AFN) | < 500 | < 300 | < 200 |
| LTV (AFN) | > 4,800 | > 4,800 | > 7,200 |
| NPS Score | > 40 | > 55 | > 65 |
| Cities active | Kabul | Kabul + Herat | 5+ cities |

---

## 19. Open Questions

| # | Question | Options | Decide By |
|---|---|---|---|
| 1 | WhatsApp method for MVP | url_launcher (free, simple) vs. WhatsApp Business API (requires Meta approval, free up to 1K convos/month) | Sprint 3 |
| 3 | Payment for rural shops | Cash manual activation vs. Hawala voucher codes | Sprint 9 |
| 4 | iOS launch timing | Same as Android vs. Android-first (saves $99/year App Store fee initially) | Sprint 11 |
| 6 | Minimum Android spec | Android 6 (larger market) vs. Android 8 (better SQLCipher performance) | Sprint 1 |

---

## 20. Appendix — Dependencies

### Flutter pubspec.yaml

```yaml
name: hesabat
description: Hesabat — Afghanistan's Business Management App
version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'
  flutter: ">=3.19.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Local database (offline-first)
  drift: ^2.18.0
  drift_flutter: ^0.2.1
  sqlite3_flutter_libs: ^0.5.24
  sqlcipher_flutter_libs: ^0.5.4  # encrypted SQLite

  # Backend / sync
  supabase_flutter: ^2.5.0
  dio: ^5.4.3
  connectivity_plus: ^6.0.3

  # Features
  mobile_scanner: ^5.2.3           # barcode scanning
  # speech_to_text: ^6.6.2         # V2 — voice input (AI feature)
  url_launcher: ^6.2.6             # WhatsApp deep link
  flutter_local_notifications: ^17.2.2
  pdf: ^3.10.8                     # on-device PDF
  fl_chart: ^0.68.0               # charts
  image_picker: ^1.1.1

  # Storage & security
  flutter_secure_storage: ^9.0.0
  hive_flutter: ^1.1.0            # exchange rate cache

  # Navigation & UI
  go_router: ^13.2.5
  intl: ^0.19.0
  share_plus: ^9.0.0
  path_provider: ^2.1.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.9
  drift_dev: ^2.18.0
  riverpod_generator: ^2.4.0
  flutter_lints: ^3.0.0
```

### Supabase Edge Functions — deno.json (imports)

```json
{
  "imports": {
    "@supabase/supabase-js": "https://esm.sh/@supabase/supabase-js@2",
    "hmac": "https://deno.land/x/hmac@v2.0.1/mod.ts"
  }
}
```

> No package.json. No npm install. No node_modules. Deno imports from URLs directly.

### Environment Variables

#### Flutter app — .env (via flutter_dotenv)
```bash
# Supabase — public keys, safe to include in app
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key   # public — safe in app

# Exchange Rates
EXCHANGE_RATE_API_KEY=your-key
```

#### Supabase Edge Functions — secrets (set via CLI, never in code)
```bash
# Set once via Supabase CLI — stored securely, never in git
supabase secrets set HESABPAY_WEBHOOK_SECRET=your-secret
supabase secrets set EXCHANGE_RATE_API_KEY=your-key
supabase secrets set SENTRY_DSN=your-sentry-dsn

# SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are auto-injected
# by Supabase into every Edge Function — you don't set these manually
```

> **Security note:** The `SUPABASE_SERVICE_ROLE_KEY` (which bypasses RLS) only ever lives inside Edge Functions as an auto-injected secret. It NEVER goes into the Flutter app. The Flutter app only ever uses `SUPABASE_ANON_KEY` — which respects all RLS policies.

### Supabase CLI Commands Reference

```bash
# One-time setup
npm install -g supabase
supabase login
supabase init
supabase link --project-ref your-project-id

# Database
supabase db push                          # push migrations to remote
supabase db pull                          # pull remote schema to local
supabase migration new add_shop_types     # create new migration file
supabase db reset                         # reset local DB (dev only)

# Edge Functions
supabase functions new function-name      # scaffold new function
supabase functions serve function-name    # run locally for testing
supabase functions deploy function-name   # deploy to production
supabase secrets set KEY=value            # set production secret

# Local development
supabase start                            # start local Supabase stack
supabase stop                             # stop local stack
supabase status                           # show local service URLs
```

---

*Hesabat PRD v1.0.0 | March 2026 | CONFIDENTIAL*

*Total infrastructure cost at launch: $0/month forever | No servers | No Python | No Docker | AI features planned for V2*