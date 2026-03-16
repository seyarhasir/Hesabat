-- 0007_align_cloud_schema_with_local.sql
-- Align Supabase tables with local app schema so sync can push raw payloads 1:1.

-- products: add local fields
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS name_dari text;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS name_pashto text;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS name_en text;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS cost_price numeric(14,2);
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS min_stock_alert numeric(14,3) NOT NULL DEFAULT 5;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS unit text NOT NULL DEFAULT 'piece';
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS category_id text;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS image_url text;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS expiry_date timestamptz;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS prescription_required boolean NOT NULL DEFAULT false;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS dosage text;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS manufacturer text;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS color text;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS size_variant text;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS imei text;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS serial_number text;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS weight_grams numeric(14,3);
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS sync_status text NOT NULL DEFAULT 'pending';
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS synced_at timestamptz;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS local_id text;

-- customers: add local fields
ALTER TABLE public.customers ADD COLUMN IF NOT EXISTS last_interaction_at timestamptz;
ALTER TABLE public.customers ADD COLUMN IF NOT EXISTS sync_status text NOT NULL DEFAULT 'pending';
ALTER TABLE public.customers ADD COLUMN IF NOT EXISTS synced_at timestamptz;
ALTER TABLE public.customers ADD COLUMN IF NOT EXISTS local_id text;

-- sales: add local fields
ALTER TABLE public.sales ADD COLUMN IF NOT EXISTS total_afn numeric(14,2);
ALTER TABLE public.sales ADD COLUMN IF NOT EXISTS discount numeric(14,2) NOT NULL DEFAULT 0;
ALTER TABLE public.sales ADD COLUMN IF NOT EXISTS exchange_rate numeric(14,6) NOT NULL DEFAULT 1;
ALTER TABLE public.sales ADD COLUMN IF NOT EXISTS note text;
ALTER TABLE public.sales ADD COLUMN IF NOT EXISTS created_offline boolean NOT NULL DEFAULT false;
ALTER TABLE public.sales ADD COLUMN IF NOT EXISTS local_id text;
ALTER TABLE public.sales ADD COLUMN IF NOT EXISTS synced_at timestamptz;
ALTER TABLE public.sales ADD COLUMN IF NOT EXISTS sync_status text NOT NULL DEFAULT 'pending';

-- sale_items: add local fields
ALTER TABLE public.sale_items ADD COLUMN IF NOT EXISTS sync_status text NOT NULL DEFAULT 'pending';
ALTER TABLE public.sale_items ADD COLUMN IF NOT EXISTS synced_at timestamptz;

-- debts: generated amount_remaining blocks raw sync writes; convert to regular column
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'debts'
      AND column_name = 'amount_remaining'
      AND is_generated = 'ALWAYS'
  ) THEN
    ALTER TABLE public.debts DROP COLUMN amount_remaining;
    ALTER TABLE public.debts ADD COLUMN amount_remaining numeric(14,2) NOT NULL DEFAULT 0;
  END IF;
END;
$$;

ALTER TABLE public.debts ADD COLUMN IF NOT EXISTS last_reminder_sent_at timestamptz;
ALTER TABLE public.debts ADD COLUMN IF NOT EXISTS sync_status text NOT NULL DEFAULT 'pending';
ALTER TABLE public.debts ADD COLUMN IF NOT EXISTS synced_at timestamptz;

-- debt_payments: add local fields
ALTER TABLE public.debt_payments ADD COLUMN IF NOT EXISTS currency text NOT NULL DEFAULT 'AFN';
ALTER TABLE public.debt_payments ADD COLUMN IF NOT EXISTS sync_status text NOT NULL DEFAULT 'pending';
ALTER TABLE public.debt_payments ADD COLUMN IF NOT EXISTS synced_at timestamptz;

-- keep legacy and local names in sync for products
UPDATE public.products
SET name_dari = COALESCE(name_dari, name)
WHERE name_dari IS NULL;

UPDATE public.products
SET name = COALESCE(name, name_dari, name_en, name_pashto, 'Unnamed product')
WHERE name IS NULL;

-- ensure amount_remaining has correct values where not provided
UPDATE public.debts
SET amount_remaining = COALESCE(amount_remaining, amount_original - amount_paid)
WHERE amount_remaining IS NULL;
