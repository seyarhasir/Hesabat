-- 0004_indexes_and_audit.sql
-- Performance indexes + audit tables

-- ---------- indexes ----------
CREATE INDEX IF NOT EXISTS idx_shops_owner_id ON public.shops(owner_id);
CREATE INDEX IF NOT EXISTS idx_admin_accounts_phone ON public.admin_created_accounts(phone);
CREATE INDEX IF NOT EXISTS idx_admin_accounts_active ON public.admin_created_accounts(is_active);
CREATE INDEX IF NOT EXISTS idx_products_shop_id ON public.products(shop_id);
CREATE INDEX IF NOT EXISTS idx_customers_shop_id ON public.customers(shop_id);
CREATE INDEX IF NOT EXISTS idx_sales_shop_id_created_at ON public.sales(shop_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_sale_items_sale_id ON public.sale_items(sale_id);
CREATE INDEX IF NOT EXISTS idx_debts_shop_id_status ON public.debts(shop_id, status);
CREATE INDEX IF NOT EXISTS idx_debt_payments_shop_id_created_at ON public.debt_payments(shop_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_devices_shop_id_device_id ON public.devices(shop_id, device_id);

-- ---------- audit ----------
CREATE TABLE IF NOT EXISTS public.auth_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid,
  event_type text NOT NULL,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.sync_audit_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id uuid REFERENCES public.shops(id) ON DELETE SET NULL,
  device_id text,
  op_id uuid,
  entity_type text,
  entity_id text,
  operation text,
  status text NOT NULL CHECK (status IN ('queued','success','failed','conflict','skipped')),
  message text,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.auth_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sync_audit_logs ENABLE ROW LEVEL SECURITY;

-- auth_events readable only by service role by default
DROP POLICY IF EXISTS auth_events_no_client_access ON public.auth_events;
CREATE POLICY auth_events_no_client_access ON public.auth_events
USING (false)
WITH CHECK (false);

-- sync logs scoped to shop owner
DROP POLICY IF EXISTS sync_logs_owner_select ON public.sync_audit_logs;
CREATE POLICY sync_logs_owner_select ON public.sync_audit_logs
FOR SELECT
USING (
  shop_id IN (SELECT id FROM public.shops WHERE owner_id = auth.uid())
);

DROP POLICY IF EXISTS sync_logs_owner_insert ON public.sync_audit_logs;
CREATE POLICY sync_logs_owner_insert ON public.sync_audit_logs
FOR INSERT
WITH CHECK (
  shop_id IN (SELECT id FROM public.shops WHERE owner_id = auth.uid())
);

CREATE INDEX IF NOT EXISTS idx_auth_events_created_at ON public.auth_events(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_sync_logs_shop_created_at ON public.sync_audit_logs(shop_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_sync_logs_op_id ON public.sync_audit_logs(op_id);
