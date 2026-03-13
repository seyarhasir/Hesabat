-- Admin-created accounts table for controlled signup (SaaS model)
-- Only admin can create accounts, users can only sign in

CREATE TABLE admin_created_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone TEXT NOT NULL UNIQUE,
  email TEXT GENERATED ALWAYS AS (phone || '@hesabat.app') STORED,
  temp_password TEXT, -- Initial password/OTP for first login
  is_active BOOLEAN DEFAULT true,
  created_by UUID REFERENCES auth.users(id), -- Admin who created this
  shop_id UUID REFERENCES shops(id), -- Associated shop (if created)
  notes TEXT, -- Admin notes about this account
  first_login_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE admin_created_accounts ENABLE ROW LEVEL SECURITY;

-- Only service role can read/write (for security)
CREATE POLICY admin_accounts_service_only ON admin_created_accounts
  USING (false); -- No direct client access

-- Function to check if account exists and is active
CREATE OR REPLACE FUNCTION check_account_exists(p_phone TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM admin_created_accounts 
    WHERE phone = p_phone AND is_active = true
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to mark first login
CREATE OR REPLACE FUNCTION mark_first_login(p_phone TEXT)
RETURNS void AS $$
BEGIN
  UPDATE admin_created_accounts 
  SET first_login_at = now(), updated_at = now()
  WHERE phone = p_phone AND first_login_at IS NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Index for faster lookups
CREATE INDEX idx_admin_accounts_phone ON admin_created_accounts(phone);
CREATE INDEX idx_admin_accounts_active ON admin_created_accounts(is_active);

-- Admin view (for admin panel)
CREATE VIEW admin_accounts_view AS
SELECT 
  id,
  phone,
  is_active,
  created_at,
  first_login_at,
  CASE 
    WHEN first_login_at IS NULL THEN 'pending'
    ELSE 'active'
  END as status
FROM admin_created_accounts
WHERE is_active = true;
