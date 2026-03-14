Phone + Permanent Passcode Auth Edge Function

This function supports login with permanent admin-managed passcodes.

Expected request body
- Prepare login:
  {
    "action": "prepare_login",
    "phone": "+9377xxxxxxx"
  }

- Verify passcode:
  {
    "action": "verify_passcode",
    "phone": "+9377xxxxxxx",
    "passcode": "123456"
  }

Behavior
- Checks active account in admin_created_accounts
- Verifies passcode hash via `verify_admin_passcode` RPC (bcrypt)
- Tracks attempts and temporary lockout in notes
- Marks first login

Deployment
1) Run migration `007_admin_passcode_hash.sql`.
2) Set passcode using SQL:
  SELECT public.set_admin_passcode('+93772654965', 'A1B2C3D4E5');
3) Deploy function `whatsapp-otp`.
4) Test prepare_login / verify_passcode from app auth screens.
