-- 0002_rls_policies.sql
-- RLS for owner-scoped access

ALTER TABLE public.shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_created_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.devices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sale_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.debts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.debt_payments ENABLE ROW LEVEL SECURITY;

-- ---------- shops ----------
DROP POLICY IF EXISTS shops_select_own ON public.shops;
CREATE POLICY shops_select_own ON public.shops
FOR SELECT
USING (owner_id = auth.uid());

DROP POLICY IF EXISTS shops_update_own ON public.shops;
CREATE POLICY shops_update_own ON public.shops
FOR UPDATE
USING (owner_id = auth.uid())
WITH CHECK (owner_id = auth.uid());

DROP POLICY IF EXISTS shops_insert_own ON public.shops;
CREATE POLICY shops_insert_own ON public.shops
FOR INSERT
WITH CHECK (owner_id = auth.uid());

-- ---------- admin_created_accounts ----------
-- Never directly readable/writable from client roles.
DROP POLICY IF EXISTS admin_accounts_no_client_access ON public.admin_created_accounts;
CREATE POLICY admin_accounts_no_client_access ON public.admin_created_accounts
USING (false)
WITH CHECK (false);

-- ---------- helper policy template for shop-owned tables ----------
DROP POLICY IF EXISTS devices_owner_all ON public.devices;
CREATE POLICY devices_owner_all ON public.devices
FOR ALL
USING (
  shop_id IN (SELECT id FROM public.shops WHERE owner_id = auth.uid())
)
WITH CHECK (
  shop_id IN (SELECT id FROM public.shops WHERE owner_id = auth.uid())
);

DROP POLICY IF EXISTS products_owner_all ON public.products;
CREATE POLICY products_owner_all ON public.products
FOR ALL
USING (
  shop_id IN (SELECT id FROM public.shops WHERE owner_id = auth.uid())
)
WITH CHECK (
  shop_id IN (SELECT id FROM public.shops WHERE owner_id = auth.uid())
);

DROP POLICY IF EXISTS customers_owner_all ON public.customers;
CREATE POLICY customers_owner_all ON public.customers
FOR ALL
USING (
  shop_id IN (SELECT id FROM public.shops WHERE owner_id = auth.uid())
)
WITH CHECK (
  shop_id IN (SELECT id FROM public.shops WHERE owner_id = auth.uid())
);

DROP POLICY IF EXISTS sales_owner_all ON public.sales;
CREATE POLICY sales_owner_all ON public.sales
FOR ALL
USING (
  shop_id IN (SELECT id FROM public.shops WHERE owner_id = auth.uid())
)
WITH CHECK (
  shop_id IN (SELECT id FROM public.shops WHERE owner_id = auth.uid())
);

DROP POLICY IF EXISTS sale_items_owner_all ON public.sale_items;
CREATE POLICY sale_items_owner_all ON public.sale_items
FOR ALL
USING (
  sale_id IN (
    SELECT s.id
    FROM public.sales s
    JOIN public.shops sh ON sh.id = s.shop_id
    WHERE sh.owner_id = auth.uid()
  )
)
WITH CHECK (
  sale_id IN (
    SELECT s.id
    FROM public.sales s
    JOIN public.shops sh ON sh.id = s.shop_id
    WHERE sh.owner_id = auth.uid()
  )
);

DROP POLICY IF EXISTS debts_owner_all ON public.debts;
CREATE POLICY debts_owner_all ON public.debts
FOR ALL
USING (
  shop_id IN (SELECT id FROM public.shops WHERE owner_id = auth.uid())
)
WITH CHECK (
  shop_id IN (SELECT id FROM public.shops WHERE owner_id = auth.uid())
);

DROP POLICY IF EXISTS debt_payments_owner_all ON public.debt_payments;
CREATE POLICY debt_payments_owner_all ON public.debt_payments
FOR ALL
USING (
  shop_id IN (SELECT id FROM public.shops WHERE owner_id = auth.uid())
)
WITH CHECK (
  shop_id IN (SELECT id FROM public.shops WHERE owner_id = auth.uid())
);
