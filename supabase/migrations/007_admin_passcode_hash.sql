-- Permanent hashed passcode for admin-created accounts
-- Passcode policy: exactly 10 chars, letters+numbers only

CREATE EXTENSION IF NOT EXISTS pgcrypto;

ALTER TABLE public.admin_created_accounts
  ADD COLUMN IF NOT EXISTS passcode_hash TEXT;

-- Set/update permanent passcode (hashed with bcrypt)
CREATE OR REPLACE FUNCTION public.set_admin_passcode(
  p_phone TEXT,
  p_passcode TEXT
)
RETURNS VOID AS $$
BEGIN
  IF p_passcode !~ '^[A-Za-z0-9]{10}$' THEN
    RAISE EXCEPTION 'Passcode must be exactly 10 characters and alphanumeric';
  END IF;

  UPDATE public.admin_created_accounts
  SET
    passcode_hash = crypt(p_passcode, gen_salt('bf', 12)),
    updated_at = now()
  WHERE phone = p_phone;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Account not found for phone %', p_phone;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Verify passcode against bcrypt hash
CREATE OR REPLACE FUNCTION public.verify_admin_passcode(
  p_phone TEXT,
  p_passcode TEXT
)
RETURNS BOOLEAN AS $$
DECLARE
  v_hash TEXT;
BEGIN
  SELECT passcode_hash INTO v_hash
  FROM public.admin_created_accounts
  WHERE phone = p_phone AND is_active = true
  LIMIT 1;

  IF v_hash IS NULL OR v_hash = '' THEN
    RETURN FALSE;
  END IF;

  RETURN v_hash = crypt(p_passcode, v_hash);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
