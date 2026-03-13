-- Database Triggers for Hesabat
-- Auto-updating fields and calculated values

-- ============================================
-- FUNCTION: Auto-update updated_at timestamp
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- ============================================
-- AUTO-UPDATE TRIGGERS FOR ALL TABLES
-- ============================================

CREATE TRIGGER update_shops_updated_at
  BEFORE UPDATE ON shops
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at
  BEFORE UPDATE ON products
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_customers_updated_at
  BEFORE UPDATE ON customers
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sales_updated_at
  BEFORE UPDATE ON sales
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_debts_updated_at
  BEFORE UPDATE ON debts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- FUNCTION: Update customer total_owed when debt changes
-- ============================================
CREATE OR REPLACE FUNCTION update_customer_total_owed()
RETURNS TRIGGER AS $$
BEGIN
  -- Update the customer's total_owed based on all their open/partial debts
  UPDATE customers
  SET total_owed = (
    SELECT COALESCE(SUM(amount_remaining), 0)
    FROM debts
    WHERE customer_id = NEW.customer_id
    AND status IN ('open', 'partial')
  ),
  updated_at = now()
  WHERE id = NEW.customer_id;
  
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger on debt insert
CREATE TRIGGER update_customer_owed_on_debt_insert
  AFTER INSERT ON debts
  FOR EACH ROW
  EXECUTE FUNCTION update_customer_total_owed();

-- Trigger on debt update (status or amount changes)
CREATE TRIGGER update_customer_owed_on_debt_update
  AFTER UPDATE ON debts
  FOR EACH ROW
  EXECUTE FUNCTION update_customer_total_owed();

-- Trigger on debt payment (when payment is recorded)
CREATE OR REPLACE FUNCTION update_customer_owed_on_payment()
RETURNS TRIGGER AS $$
BEGIN
  -- Recalculate customer's total owed
  UPDATE customers
  SET total_owed = (
    SELECT COALESCE(SUM(amount_remaining), 0)
    FROM debts
    WHERE customer_id = (
      SELECT customer_id FROM debts WHERE id = NEW.debt_id
    )
    AND status IN ('open', 'partial')
  ),
  updated_at = now()
  WHERE id = (SELECT customer_id FROM debts WHERE id = NEW.debt_id);
  
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_customer_owed_on_payment_insert
  AFTER INSERT ON debt_payments
  FOR EACH ROW
  EXECUTE FUNCTION update_customer_owed_on_payment();

-- ============================================
-- FUNCTION: Update debt status when payment is recorded
-- ============================================
CREATE OR REPLACE FUNCTION update_debt_status_on_payment()
RETURNS TRIGGER AS $$
DECLARE
  v_total_paid DECIMAL(12,2);
  v_amount_original DECIMAL(12,2);
  v_new_status TEXT;
BEGIN
  -- Get total paid for this debt
  SELECT COALESCE(SUM(amount), 0) INTO v_total_paid
  FROM debt_payments
  WHERE debt_id = NEW.debt_id;
  
  -- Get original amount
  SELECT amount_original INTO v_amount_original
  FROM debts
  WHERE id = NEW.debt_id;
  
  -- Determine new status
  IF v_total_paid >= v_amount_original THEN
    v_new_status := 'paid';
  ELSIF v_total_paid > 0 THEN
    v_new_status := 'partial';
  ELSE
    v_new_status := 'open';
  END IF;
  
  -- Update debt
  UPDATE debts
  SET 
    amount_paid = v_total_paid,
    status = v_new_status,
    updated_at = now()
  WHERE id = NEW.debt_id;
  
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_debt_status_on_payment
  AFTER INSERT ON debt_payments
  FOR EACH ROW
  EXECUTE FUNCTION update_debt_status_on_payment();

-- ============================================
-- FUNCTION: Update product stock on sale
-- ============================================
CREATE OR REPLACE FUNCTION decrement_stock_on_sale()
RETURNS TRIGGER AS $$
BEGIN
  -- Decrement product stock
  UPDATE products
  SET 
    stock_quantity = stock_quantity - NEW.quantity,
    updated_at = now()
  WHERE id = NEW.product_id;
  
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER decrement_stock_on_sale_item
  AFTER INSERT ON sale_items
  FOR EACH ROW
  EXECUTE FUNCTION decrement_stock_on_sale();

-- ============================================
-- FUNCTION: Update customer last_interaction_at on sale
-- ============================================
CREATE OR REPLACE FUNCTION update_customer_last_interaction()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.customer_id IS NOT NULL THEN
    UPDATE customers
    SET 
      last_interaction_at = NEW.created_at,
      updated_at = now()
    WHERE id = NEW.customer_id;
  END IF;
  
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_customer_last_interaction_on_sale
  AFTER INSERT ON sales
  FOR EACH ROW
  EXECUTE FUNCTION update_customer_last_interaction();

-- ============================================
-- FUNCTION: Create debt record when credit sale is made
-- ============================================
CREATE OR REPLACE FUNCTION create_debt_on_credit_sale()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.is_credit = true AND NEW.customer_id IS NOT NULL THEN
    INSERT INTO debts (
      shop_id,
      customer_id,
      sale_id,
      amount_original,
      status,
      created_at,
      updated_at
    ) VALUES (
      NEW.shop_id,
      NEW.customer_id,
      NEW.id,
      NEW.total_amount,
      'open',
      NEW.created_at,
      NEW.created_at
    );
  END IF;
  
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER create_debt_on_credit_sale
  AFTER INSERT ON sales
  FOR EACH ROW
  EXECUTE FUNCTION create_debt_on_credit_sale();
