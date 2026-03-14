-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.admin_created_accounts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  phone text NOT NULL UNIQUE,
  email text DEFAULT (phone || '@hesabat.app'::text),
  temp_password text,
  is_active boolean DEFAULT true,
  created_by uuid,
  shop_id uuid,
  notes text,
  first_login_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  passcode_hash text,
  CONSTRAINT admin_created_accounts_pkey PRIMARY KEY (id),
  CONSTRAINT admin_created_accounts_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id),
  CONSTRAINT admin_created_accounts_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id)
);
CREATE TABLE public.categories (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  shop_id uuid NOT NULL,
  name_dari text NOT NULL,
  name_pashto text,
  name_en text,
  icon text,
  color text,
  sort_order integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT categories_pkey PRIMARY KEY (id),
  CONSTRAINT categories_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id)
);
CREATE TABLE public.category_templates (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  shop_type text NOT NULL CHECK (shop_type = ANY (ARRAY['grocery'::text, 'pharmacy'::text, 'hardware'::text, 'electronics'::text, 'clothing'::text, 'bakery'::text, 'restaurant'::text, 'general'::text])),
  name_dari text NOT NULL,
  name_pashto text,
  name_en text,
  icon text,
  color text,
  sort_order integer DEFAULT 0,
  CONSTRAINT category_templates_pkey PRIMARY KEY (id)
);
CREATE TABLE public.customers (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  shop_id uuid NOT NULL,
  name text NOT NULL,
  phone text,
  total_owed numeric DEFAULT 0,
  notes text,
  last_interaction_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT customers_pkey PRIMARY KEY (id),
  CONSTRAINT customers_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id)
);
CREATE TABLE public.debt_payments (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  debt_id uuid NOT NULL,
  shop_id uuid NOT NULL,
  amount numeric NOT NULL,
  payment_method text DEFAULT 'cash'::text,
  currency text DEFAULT 'AFN'::text,
  notes text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT debt_payments_pkey PRIMARY KEY (id),
  CONSTRAINT debt_payments_debt_id_fkey FOREIGN KEY (debt_id) REFERENCES public.debts(id),
  CONSTRAINT debt_payments_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id)
);
CREATE TABLE public.debts (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  shop_id uuid NOT NULL,
  customer_id uuid NOT NULL,
  sale_id uuid,
  amount_original numeric NOT NULL,
  amount_paid numeric DEFAULT 0,
  amount_remaining numeric DEFAULT (amount_original - amount_paid),
  status text DEFAULT 'open'::text CHECK (status = ANY (ARRAY['open'::text, 'partial'::text, 'paid'::text, 'written_off'::text])),
  due_date date,
  last_reminder_sent_at timestamp with time zone,
  notes text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT debts_pkey PRIMARY KEY (id),
  CONSTRAINT debts_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id),
  CONSTRAINT debts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id),
  CONSTRAINT debts_sale_id_fkey FOREIGN KEY (sale_id) REFERENCES public.sales(id)
);
CREATE TABLE public.devices (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  shop_id uuid NOT NULL,
  device_id text NOT NULL,
  platform text NOT NULL CHECK (platform = ANY (ARRAY['android'::text, 'ios'::text])),
  app_version text,
  last_sync_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT devices_pkey PRIMARY KEY (id),
  CONSTRAINT devices_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id)
);
CREATE TABLE public.exchange_rates (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  from_currency text NOT NULL,
  to_currency text NOT NULL,
  rate numeric NOT NULL,
  fetched_at timestamp with time zone DEFAULT now(),
  CONSTRAINT exchange_rates_pkey PRIMARY KEY (id)
);
CREATE TABLE public.inventory_adjustments (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  shop_id uuid NOT NULL,
  product_id uuid NOT NULL,
  quantity_before numeric NOT NULL,
  quantity_after numeric NOT NULL,
  quantity_change numeric DEFAULT (quantity_after - quantity_before),
  reason text NOT NULL CHECK (reason = ANY (ARRAY['new_stock'::text, 'damaged'::text, 'expired'::text, 'manual_count'::text, 'theft'::text, 'other'::text])),
  notes text,
  adjusted_at timestamp with time zone DEFAULT now(),
  CONSTRAINT inventory_adjustments_pkey PRIMARY KEY (id),
  CONSTRAINT inventory_adjustments_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id),
  CONSTRAINT inventory_adjustments_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id)
);
CREATE TABLE public.otp_codes (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  phone text NOT NULL UNIQUE,
  otp text NOT NULL,
  device_id text,
  expires_at timestamp with time zone NOT NULL,
  attempts integer DEFAULT 0,
  verified boolean DEFAULT false,
  verified_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT otp_codes_pkey PRIMARY KEY (id)
);
CREATE TABLE public.product_templates (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  shop_type text NOT NULL CHECK (shop_type = ANY (ARRAY['grocery'::text, 'pharmacy'::text, 'hardware'::text, 'electronics'::text, 'clothing'::text, 'bakery'::text, 'restaurant'::text, 'general'::text])),
  name_dari text NOT NULL,
  name_pashto text,
  name_en text,
  barcode text,
  default_unit text DEFAULT 'piece'::text,
  category_slug text,
  tags ARRAY,
  is_active boolean DEFAULT true,
  CONSTRAINT product_templates_pkey PRIMARY KEY (id)
);
CREATE TABLE public.products (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  shop_id uuid NOT NULL,
  name_dari text NOT NULL,
  name_pashto text,
  name_en text,
  barcode text,
  price numeric NOT NULL DEFAULT 0,
  cost_price numeric,
  stock_quantity numeric DEFAULT 0,
  min_stock_alert numeric DEFAULT 5,
  unit text DEFAULT 'piece'::text,
  category_id uuid,
  image_url text,
  expiry_date date,
  prescription_required boolean DEFAULT false,
  dosage text,
  manufacturer text,
  color text,
  size_variant text,
  imei text,
  serial_number text,
  weight_grams integer,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT products_pkey PRIMARY KEY (id),
  CONSTRAINT products_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id),
  CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id)
);
CREATE TABLE public.sale_items (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  sale_id uuid NOT NULL,
  product_id uuid,
  product_name_snapshot text NOT NULL,
  quantity numeric NOT NULL,
  unit_price numeric NOT NULL,
  subtotal numeric NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT sale_items_pkey PRIMARY KEY (id),
  CONSTRAINT sale_items_sale_id_fkey FOREIGN KEY (sale_id) REFERENCES public.sales(id),
  CONSTRAINT sale_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id)
);
CREATE TABLE public.sales (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  shop_id uuid NOT NULL,
  customer_id uuid,
  total_amount numeric NOT NULL,
  total_afn numeric NOT NULL,
  discount numeric DEFAULT 0,
  payment_method text DEFAULT 'cash'::text CHECK (payment_method = ANY (ARRAY['cash'::text, 'credit'::text, 'mixed'::text])),
  currency text DEFAULT 'AFN'::text,
  exchange_rate numeric DEFAULT 1,
  is_credit boolean DEFAULT false,
  note text,
  created_offline boolean DEFAULT false,
  local_id text,
  synced_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT sales_pkey PRIMARY KEY (id),
  CONSTRAINT sales_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id),
  CONSTRAINT sales_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id)
);
CREATE TABLE public.shops (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  owner_id uuid NOT NULL,
  name text NOT NULL,
  name_dari text,
  phone text,
  city text DEFAULT 'Kabul'::text,
  district text,
  shop_type text DEFAULT 'general'::text CHECK (shop_type = ANY (ARRAY['grocery'::text, 'pharmacy'::text, 'hardware'::text, 'electronics'::text, 'clothing'::text, 'bakery'::text, 'restaurant'::text, 'general'::text])),
  currency_pref text DEFAULT 'AFN'::text,
  secondary_currency text CHECK (secondary_currency = ANY (ARRAY['USD'::text, 'PKR'::text, NULL::text])),
  language_pref text DEFAULT 'fa'::text,
  subscription_status text DEFAULT 'trial'::text CHECK (subscription_status = ANY (ARRAY['trial'::text, 'active'::text, 'expired'::text, 'cancelled'::text])),
  trial_ends_at timestamp with time zone DEFAULT (now() + '30 days'::interval),
  subscription_ends_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT shops_pkey PRIMARY KEY (id),
  CONSTRAINT shops_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES auth.users(id)
);
CREATE TABLE public.subscriptions (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  shop_id uuid NOT NULL,
  plan text NOT NULL CHECK (plan = ANY (ARRAY['trial'::text, 'basic'::text, 'pro'::text, 'annual_basic'::text])),
  amount_paid numeric,
  payment_method text,
  payment_ref text,
  starts_at timestamp with time zone,
  ends_at timestamp with time zone,
  status text DEFAULT 'active'::text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT subscriptions_pkey PRIMARY KEY (id),
  CONSTRAINT subscriptions_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id)
);
CREATE TABLE public.whatsapp_logs (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  shop_id uuid NOT NULL,
  customer_id uuid,
  message_type text NOT NULL CHECK (message_type = ANY (ARRAY['reminder'::text, 'receipt'::text, 'welcome'::text, 'custom'::text])),
  message_preview text,
  status text DEFAULT 'sent'::text,
  sent_at timestamp with time zone DEFAULT now(),
  CONSTRAINT whatsapp_logs_pkey PRIMARY KEY (id),
  CONSTRAINT whatsapp_logs_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id),
  CONSTRAINT whatsapp_logs_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id)
);