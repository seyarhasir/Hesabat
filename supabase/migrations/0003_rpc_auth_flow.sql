-- 0003_rpc_auth_flow.sql
-- Auth and relink RPCs

-- ---------- passcode verify ----------
CREATE OR REPLACE FUNCTION public.verify_admin_passcode(
  p_phone text,
  p_passcode text
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth
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

  RETURN v_hash = crypt(p_passcode, v_hash);
END;
$$;

-- ---------- mark first login ----------
CREATE OR REPLACE FUNCTION public.mark_first_login(
  p_phone text
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth
AS $$
BEGIN
  UPDATE public.admin_created_accounts
  SET first_login_at = COALESCE(first_login_at, now()),
      updated_at = now()
  WHERE phone = p_phone
    AND is_active = true;
END;
$$;

-- ---------- relink shop by phone ----------
-- Returns typed contract:
--   { status: linked|already_linked|not_found|inactive_account|forbidden|error, shop_id?: uuid }
CREATE OR REPLACE FUNCTION public.relink_shop_by_phone(
  p_phone text
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth
AS $$
DECLARE
  v_shop_id uuid;
  v_owner_id uuid;
  v_phone_digits text;
  v_canonical text;
BEGIN
  IF auth.uid() IS NULL THEN
    RETURN jsonb_build_object('status', 'forbidden');
  END IF;

  v_phone_digits := regexp_replace(COALESCE(p_phone, ''), '\\D', '', 'g');
  IF v_phone_digits = '' THEN
    RETURN jsonb_build_object('status', 'not_found');
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

  -- inactive explicit check
  IF EXISTS (
    SELECT 1
    FROM public.admin_created_accounts a
    WHERE regexp_replace(a.phone, '\\D', '', 'g') IN (v_canonical, substr(v_canonical, 3), '0' || substr(v_canonical, 3))
      AND a.is_active = false
  ) THEN
    RETURN jsonb_build_object('status', 'inactive_account');
  END IF;

  SELECT a.shop_id
    INTO v_shop_id
  FROM public.admin_created_accounts a
  WHERE a.is_active = true
    AND regexp_replace(a.phone, '\\D', '', 'g') IN (v_canonical, substr(v_canonical, 3), '0' || substr(v_canonical, 3))
  ORDER BY a.updated_at DESC NULLS LAST
  LIMIT 1;

  IF v_shop_id IS NULL THEN
    RETURN jsonb_build_object('status', 'not_found');
  END IF;

  SELECT s.owner_id INTO v_owner_id
  FROM public.shops s
  WHERE s.id = v_shop_id;

  IF v_owner_id = auth.uid() THEN
    RETURN jsonb_build_object('status', 'already_linked', 'shop_id', v_shop_id);
  END IF;

  UPDATE public.shops
  SET owner_id = auth.uid(),
      updated_at = now()
  WHERE id = v_shop_id;

  RETURN jsonb_build_object('status', 'linked', 'shop_id', v_shop_id);
EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object('status', 'error');
END;
$$;

-- ---------- fetch shop context ----------
CREATE OR REPLACE FUNCTION public.fetch_shop_context()
RETURNS jsonb
LANGUAGE sql
SECURITY INVOKER
SET search_path = public, auth
AS $$
  SELECT COALESCE(
    (
      SELECT jsonb_build_object(
        'shop_id', s.id,
        'shop_name', s.name,
        'subscription_status', s.subscription_status,
        'currency_pref', s.currency_pref,
        'language_pref', s.language_pref
      )
      FROM public.shops s
      WHERE s.owner_id = auth.uid()
      ORDER BY s.updated_at DESC
      LIMIT 1
    ),
    jsonb_build_object('shop_id', null)
  );
$$;

-- grants
GRANT EXECUTE ON FUNCTION public.verify_admin_passcode(text, text) TO anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.mark_first_login(text) TO authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.relink_shop_by_phone(text) TO authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.fetch_shop_context() TO authenticated;
