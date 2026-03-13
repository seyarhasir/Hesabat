-- Initial Schema for Hesabat
-- Creates all core tables with UUID primary keys and timestamps

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 1. SHOPS TABLE
-- ============================================
CREATE TABLE shops (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  name_dari TEXT,
  phone TEXT,
  city TEXT DEFAULT 'Kabul',
  district TEXT,
  shop_type TEXT CHECK (shop_type IN ('grocery','pharmacy','hardware','electronics','clothing','bakery','restaurant','general')) DEFAULT 'general',
  currency_pref TEXT DEFAULT 'AFN',
  secondary_currency TEXT CHECK (secondary_currency IN ('USD','PKR', NULL)),
  language_pref TEXT DEFAULT 'fa',  -- fa=Dari, ps=Pashto, en=English
  subscription_status TEXT DEFAULT 'trial' CHECK (subscription_status IN ('trial','active','expired','cancelled')),
  trial_ends_at TIMESTAMPTZ DEFAULT now() + INTERVAL '30 days',
  subscription_ends_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 2. CATEGORIES TABLE
-- ============================================
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  shop_id UUID REFERENCES shops(id) ON DELETE CASCADE NOT NULL,
  name_dari TEXT NOT NULL,
  name_pashto TEXT,
  name_en TEXT,
  icon TEXT,
  color TEXT,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 3. PRODUCTS TABLE
-- ============================================
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  shop_id UUID REFERENCES shops(id) ON DELETE CASCADE NOT NULL,
  name_dari TEXT NOT NULL,
  name_pashto TEXT,
  name_en TEXT,
  barcode TEXT,
  price DECIMAL(12,2) NOT NULL DEFAULT 0,
  cost_price DECIMAL(12,2),
  stock_quantity DECIMAL(12,3) DEFAULT 0,
  min_stock_alert DECIMAL(12,3) DEFAULT 5,
  unit TEXT DEFAULT 'piece',  -- piece, kg, litre, pack, strip, bottle, etc.
  category_id UUID REFERENCES categories(id),
  image_url TEXT,
  
  -- Shop-type specific fields
  expiry_date DATE,
  prescription_required BOOLEAN DEFAULT false,
  dosage TEXT,
  manufacturer TEXT,
  color TEXT,
  size_variant TEXT,
  imei TEXT,
  serial_number TEXT,
  weight_grams INTEGER,
  
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 4. CUSTOMERS TABLE
-- ============================================
CREATE TABLE customers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  shop_id UUID REFERENCES shops(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  phone TEXT,
  total_owed DECIMAL(12,2) DEFAULT 0,
  notes TEXT,
  last_interaction_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 5. SALES TABLE
-- ============================================
CREATE TABLE sales (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  shop_id UUID REFERENCES shops(id) ON DELETE CASCADE NOT NULL,
  customer_id UUID REFERENCES customers(id),
  total_amount DECIMAL(12,2) NOT NULL,
  total_afn DECIMAL(12,2) NOT NULL,
  discount DECIMAL(12,2) DEFAULT 0,
  payment_method TEXT CHECK (payment_method IN ('cash','credit','mixed')) DEFAULT 'cash',
  currency TEXT DEFAULT 'AFN',
  exchange_rate DECIMAL(10,4) DEFAULT 1,
  is_credit BOOLEAN DEFAULT false,
  note TEXT,
  created_offline BOOLEAN DEFAULT false,
  local_id TEXT,
  synced_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 6. SALE ITEMS TABLE
-- ============================================
CREATE TABLE sale_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sale_id UUID REFERENCES sales(id) ON DELETE CASCADE NOT NULL,
  product_id UUID REFERENCES products(id),
  product_name_snapshot TEXT NOT NULL,
  quantity DECIMAL(12,3) NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  subtotal DECIMAL(12,2) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 7. DEBTS TABLE
-- ============================================
CREATE TABLE debts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  shop_id UUID REFERENCES shops(id) ON DELETE CASCADE NOT NULL,
  customer_id UUID REFERENCES customers(id) NOT NULL,
  sale_id UUID REFERENCES sales(id),
  amount_original DECIMAL(12,2) NOT NULL,
  amount_paid DECIMAL(12,2) DEFAULT 0,
  amount_remaining DECIMAL(12,2) GENERATED ALWAYS AS (amount_original - amount_paid) STORED,
  status TEXT DEFAULT 'open' CHECK (status IN ('open','partial','paid','written_off')),
  due_date DATE,
  last_reminder_sent_at TIMESTAMPTZ,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 8. DEBT PAYMENTS TABLE
-- ============================================
CREATE TABLE debt_payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  debt_id UUID REFERENCES debts(id) ON DELETE CASCADE NOT NULL,
  shop_id UUID REFERENCES shops(id) ON DELETE CASCADE NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  payment_method TEXT DEFAULT 'cash',
  currency TEXT DEFAULT 'AFN',
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 9. INVENTORY ADJUSTMENTS TABLE
-- ============================================
CREATE TABLE inventory_adjustments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  shop_id UUID REFERENCES shops(id) ON DELETE CASCADE NOT NULL,
  product_id UUID REFERENCES products(id) NOT NULL,
  quantity_before DECIMAL(12,3) NOT NULL,
  quantity_after DECIMAL(12,3) NOT NULL,
  quantity_change DECIMAL(12,3) GENERATED ALWAYS AS (quantity_after - quantity_before) STORED,
  reason TEXT CHECK (reason IN ('new_stock','damaged','expired','manual_count','theft','other')) NOT NULL,
  notes TEXT,
  adjusted_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 10. EXCHANGE RATES TABLE
-- ============================================
CREATE TABLE exchange_rates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  from_currency TEXT NOT NULL,
  to_currency TEXT NOT NULL,
  rate DECIMAL(12,6) NOT NULL,
  fetched_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(from_currency, to_currency)
);

-- ============================================
-- 11. DEVICES TABLE (Multi-device support)
-- ============================================
CREATE TABLE devices (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  shop_id UUID REFERENCES shops(id) ON DELETE CASCADE NOT NULL,
  device_id TEXT NOT NULL,
  platform TEXT CHECK (platform IN ('android','ios')) NOT NULL,
  app_version TEXT,
  last_sync_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(shop_id, device_id)
);

-- ============================================
-- 12. SUBSCRIPTIONS TABLE
-- ============================================
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  shop_id UUID REFERENCES shops(id) ON DELETE CASCADE NOT NULL,
  plan TEXT CHECK (plan IN ('trial','basic','pro','annual_basic')) NOT NULL,
  amount_paid DECIMAL(12,2),
  payment_method TEXT,
  payment_ref TEXT,
  starts_at TIMESTAMPTZ,
  ends_at TIMESTAMPTZ,
  status TEXT DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 13. WHATSAPP LOGS TABLE
-- ============================================
CREATE TABLE whatsapp_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  shop_id UUID REFERENCES shops(id) ON DELETE CASCADE NOT NULL,
  customer_id UUID REFERENCES customers(id),
  message_type TEXT CHECK (message_type IN ('reminder','receipt','welcome','custom')) NOT NULL,
  message_preview TEXT,
  status TEXT DEFAULT 'sent',
  sent_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

-- Products indexes
CREATE INDEX idx_products_shop_id ON products(shop_id);
CREATE INDEX idx_products_barcode ON products(barcode);
CREATE INDEX idx_products_category ON products(category_id);

-- Customers indexes
CREATE INDEX idx_customers_shop_id ON customers(shop_id);
CREATE INDEX idx_customers_phone ON customers(phone);

-- Sales indexes
CREATE INDEX idx_sales_shop_id ON sales(shop_id);
CREATE INDEX idx_sales_customer_id ON sales(customer_id);
CREATE INDEX idx_sales_created_at ON sales(created_at);

-- Debts indexes
CREATE INDEX idx_debts_shop_id ON debts(shop_id);
CREATE INDEX idx_debts_customer_id ON debts(customer_id);
CREATE INDEX idx_debts_status ON debts(status);

-- Exchange rates index
CREATE INDEX idx_exchange_rates_lookup ON exchange_rates(from_currency, to_currency);

-- ============================================
-- SEED DEFAULT EXCHANGE RATES
-- ============================================
INSERT INTO exchange_rates (from_currency, to_currency, rate) VALUES
  ('AFN', 'USD', 0.013),
  ('AFN', 'PKR', 3.6),
  ('USD', 'AFN', 76.0),
  ('PKR', 'AFN', 0.28),
  ('USD', 'PKR', 276.0),
  ('PKR', 'USD', 0.0036)
ON CONFLICT (from_currency, to_currency) DO NOTHING;
