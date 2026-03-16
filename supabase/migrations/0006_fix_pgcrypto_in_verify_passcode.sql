-- 0006_fix_pgcrypto_in_verify_passcode.sql
-- Fix verify RPC when pgcrypto functions are in `extensions` schema.

CREATE SCHEMA IF NOT EXISTS extensions;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;

CREATE OR REPLACE FUNCTION public.verify_admin_passcode(
  p_phone text,
  p_passcode text
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth, extensions
AS $$
DECLARE
  v_hash text;
BEGIN
  SELECT a.passcode_hash
    INTO v_hash
  FROM public.admin_created_accounts a
  WHERE a.phone = p_phone
    AND a.is_active = true
  LIMIT 1;

  IF v_hash IS NULL THEN
    RETURN false;
  END IF;

  RETURN v_hash = extensions.crypt(p_passcode, v_hash);
END;
$$;

GRANT EXECUTE ON FUNCTION public.verify_admin_passcode(text, text) TO anon, authenticated, service_role;
