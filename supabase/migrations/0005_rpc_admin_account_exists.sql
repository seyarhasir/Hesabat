-- 0005_rpc_admin_account_exists.sql
-- Pre-auth account existence check by phone (boolean only)

CREATE OR REPLACE FUNCTION public.admin_account_exists(
  p_phone text
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth
AS $$
DECLARE
  v_phone_digits text;
  v_canonical text;
BEGIN
  v_phone_digits := regexp_replace(COALESCE(p_phone, ''), '\\D', '', 'g');
  IF v_phone_digits = '' THEN
    RETURN false;
  END IF;

  IF v_phone_digits LIKE '0093%' THEN
    v_canonical := substr(v_phone_digits, 3);
  ELSIF v_phone_digits LIKE '93%' THEN
    v_canonical := v_phone_digits;
  ELSIF v_phone_digits LIKE '0%' AND length(v_phone_digits) = 10 THEN
    v_canonical := '93' || substr(v_phone_digits, 2);
  ELSIF v_phone_digits LIKE '7%' AND length(v_phone_digits) = 9 THEN
    v_canonical := '93' || v_phone_digits;
  ELSE
    v_canonical := v_phone_digits;
  END IF;

  RETURN EXISTS (
    SELECT 1
    FROM public.admin_created_accounts a
    WHERE a.is_active = true
      AND regexp_replace(a.phone, '\\D', '', 'g') IN (
        v_canonical,
        substr(v_canonical, 3),
        '0' || substr(v_canonical, 3)
      )
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.admin_account_exists(text) TO anon, authenticated, service_role;
