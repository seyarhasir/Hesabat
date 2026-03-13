-- Row Level Security (RLS) Policies for Hesabat
-- Ensures each shop can ONLY read/write its own data

-- ============================================
-- ENABLE RLS ON ALL TABLES
-- ============================================

ALTER TABLE shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE sale_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE debts ENABLE ROW LEVEL SECURITY;
ALTER TABLE debt_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_adjustments ENABLE ROW LEVEL SECURITY;
ALTER TABLE exchange_rates ENABLE ROW LEVEL SECURITY;
ALTER TABLE devices ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE whatsapp_logs ENABLE ROW LEVEL SECURITY;

-- ============================================
-- SHOPS TABLE POLICIES
-- ============================================

-- Shop owners can only see their own shop
CREATE POLICY own_shop_only ON shops
  FOR ALL
  USING (owner_id = auth.uid());

-- ============================================
-- CATEGORIES TABLE POLICIES
-- ============================================

CREATE POLICY shop_isolation_categories ON categories
  FOR ALL
  USING (shop_id IN (
    SELECT id FROM shops WHERE owner_id = auth.uid()
  ));

-- ============================================
-- PRODUCTS TABLE POLICIES
-- ============================================

CREATE POLICY shop_isolation_products ON products
  FOR ALL
  USING (shop_id IN (
    SELECT id FROM shops WHERE owner_id = auth.uid()
  ));

-- ============================================
-- CUSTOMERS TABLE POLICIES
-- ============================================

CREATE POLICY shop_isolation_customers ON customers
  FOR ALL
  USING (shop_id IN (
    SELECT id FROM shops WHERE owner_id = auth.uid()
  ));

-- ============================================
-- SALES TABLE POLICIES
-- ============================================

CREATE POLICY shop_isolation_sales ON sales
  FOR ALL
  USING (shop_id IN (
    SELECT id FROM shops WHERE owner_id = auth.uid()
  ));

-- ============================================
-- SALE ITEMS TABLE POLICIES
-- ============================================

CREATE POLICY shop_isolation_sale_items ON sale_items
  FOR ALL
  USING (sale_id IN (
    SELECT id FROM sales WHERE shop_id IN (
      SELECT id FROM shops WHERE owner_id = auth.uid()
    )
  ));

-- ============================================
-- DEBTS TABLE POLICIES
-- ============================================

CREATE POLICY shop_isolation_debts ON debts
  FOR ALL
  USING (shop_id IN (
    SELECT id FROM shops WHERE owner_id = auth.uid()
  ));

-- ============================================
-- DEBT PAYMENTS TABLE POLICIES
-- ============================================

CREATE POLICY shop_isolation_debt_payments ON debt_payments
  FOR ALL
  USING (shop_id IN (
    SELECT id FROM shops WHERE owner_id = auth.uid()
  ));

-- ============================================
-- INVENTORY ADJUSTMENTS TABLE POLICIES
-- ============================================

CREATE POLICY shop_isolation_inventory ON inventory_adjustments
  FOR ALL
  USING (shop_id IN (
    SELECT id FROM shops WHERE owner_id = auth.uid()
  ));

-- ============================================
-- EXCHANGE RATES TABLE POLICIES
-- ============================================

-- Exchange rates are global (readable by all), but only service role can modify
CREATE POLICY exchange_rates_read_all ON exchange_rates
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY exchange_rates_modify_service ON exchange_rates
  FOR ALL
  TO service_role
  USING (true);

-- ============================================
-- DEVICES TABLE POLICIES
-- ============================================

CREATE POLICY shop_isolation_devices ON devices
  FOR ALL
  USING (shop_id IN (
    SELECT id FROM shops WHERE owner_id = auth.uid()
  ));

-- ============================================
-- SUBSCRIPTIONS TABLE POLICIES
-- ============================================

CREATE POLICY shop_isolation_subscriptions ON subscriptions
  FOR ALL
  USING (shop_id IN (
    SELECT id FROM shops WHERE owner_id = auth.uid()
  ));

-- ============================================
-- WHATSAPP LOGS TABLE POLICIES
-- ============================================

CREATE POLICY shop_isolation_whatsapp_logs ON whatsapp_logs
  FOR ALL
  USING (shop_id IN (
    SELECT id FROM shops WHERE owner_id = auth.uid()
  ));

-- ============================================
-- ALLOW ANON/AUTH ACCESS FOR EDGE FUNCTIONS
-- ============================================

-- Edge functions use service role key, bypassing RLS
-- This is configured via Supabase dashboard, not SQL
