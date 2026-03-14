import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// CORS headers
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

const MAX_ATTEMPTS = 5
const LOCK_MINUTES = 15

function normalizePhone(raw: string): string {
  const digits = (raw ?? '').replace(/\D/g, '')
  if (!digits) return ''
  if (digits.startsWith('93') && digits.length === 12) return `+${digits}`
  if (digits.startsWith('0') && digits.length === 10) return `+93${digits.slice(1)}`
  if (digits.startsWith('+')) return raw
  return `+${digits}`
}

function phoneCandidates(raw: string): string[] {
  const normalized = normalizePhone(raw)
  if (!normalized) return []

  const national = normalized.replace('+93', '')
  const with07 = national.length === 9 && national.startsWith('7') ? `0${national}` : national

  return Array.from(new Set([
    normalized,
    national,
    with07,
    `+93${national}`,
  ].filter(Boolean)))
}

function lockUntilIso(): string {
  return new Date(Date.now() + LOCK_MINUTES * 60 * 1000).toISOString()
}

Deno.serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    const { action, phone, passcode } = await req.json()
    const normalizedPhone = normalizePhone(phone)
    const candidates = phoneCandidates(phone)

    if (!normalizedPhone) {
      return new Response(
        JSON.stringify({ success: false, error: 'Invalid phone number' }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 400,
        },
      )
    }

    // Step 1: only check that account exists and is active.
    if (action === 'prepare_login') {
      // Ensure account is active (admin-created only)
      const { data: accountRows, error: accountErr } = await supabase
        .from('admin_created_accounts')
        .select('phone,is_active')
        .in('phone', candidates)
        .eq('is_active', true)
        .limit(1)

      if (accountErr) throw accountErr
      const account = accountRows?.[0]
      if (!account) {
        return new Response(
          JSON.stringify({ success: false, error: 'Account not found or inactive' }),
          {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 404,
          },
        )
      }

      return new Response(
        JSON.stringify({ 
          success: true, 
          message: 'Account found'
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200 
        }
      )
    }

    // Step 2: verify passcode.
    if (action === 'verify_passcode') {
      const rawPasscode = (passcode ?? '').toString().trim()
      if (!rawPasscode) {
        return new Response(
          JSON.stringify({ success: false, error: 'Passcode is required' }),
          {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 400,
          },
        )
      }

      if (!/^[A-Za-z0-9]{10}$/.test(rawPasscode)) {
        return new Response(
          JSON.stringify({ success: false, error: 'Passcode must be 10 letters/numbers' }),
          {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 400,
          },
        )
      }

      const { data: accountRows, error: fetchError } = await supabase
        .from('admin_created_accounts')
        .select('id,phone,is_active,notes,updated_at')
        .in('phone', candidates)
        .eq('is_active', true)
        .limit(1)

      const account = accountRows?.[0]

      if (fetchError || !account) {
        return new Response(
          JSON.stringify({ 
            success: false, 
            error: 'Account not found or inactive' 
          }),
          { 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 404 
          }
        )
      }

      const notes = (account.notes ?? '').toString()
      const lockPrefix = 'locked_until:'
      const lockTag = notes
        .split('|')
        .map((s: string) => s.trim())
        .find((s: string) => s.startsWith(lockPrefix))

      if (lockTag) {
        const untilStr = lockTag.replace(lockPrefix, '')
        const untilMs = Date.parse(untilStr)
        if (!Number.isNaN(untilMs) && untilMs > Date.now()) {
          return new Response(
            JSON.stringify({
              success: false,
              error: 'Too many attempts. Try again later.',
              lockout: true,
            }),
            {
              headers: { ...corsHeaders, 'Content-Type': 'application/json' },
              status: 429,
            },
          )
        }
      }

      const attemptsTag = notes
        .split('|')
        .map((s: string) => s.trim())
        .find((s: string) => s.startsWith('attempts:'))
      const currentAttempts = attemptsTag ? Number(attemptsTag.replace('attempts:', '')) || 0 : 0

      const { data: passcodeOk, error: verifyErr } = await supabase.rpc('verify_admin_passcode', {
        p_phone: account.phone,
        p_passcode: rawPasscode,
      })

      if (verifyErr) {
        throw verifyErr
      }

      if (!passcodeOk) {
        const { data: hashProbe } = await supabase
          .from('admin_created_accounts')
          .select('passcode_hash')
          .eq('id', account.id)
          .maybeSingle()

        if (!hashProbe?.passcode_hash) {
          return new Response(
            JSON.stringify({ success: false, error: 'No passcode set for this account' }),
            {
              headers: { ...corsHeaders, 'Content-Type': 'application/json' },
              status: 409,
            },
          )
        }

        const nextAttempts = currentAttempts + 1
        const newNotesBase = notes
          .split('|')
          .map((s: string) => s.trim())
          .filter((s: string) => s && !s.startsWith('attempts:') && !s.startsWith(lockPrefix))
          .join(' | ')

        const lockNote = nextAttempts >= MAX_ATTEMPTS
          ? ` | attempts:${nextAttempts} | ${lockPrefix}${lockUntilIso()}`
          : ` | attempts:${nextAttempts}`

        await supabase
          .from('admin_created_accounts')
          .update({ notes: `${newNotesBase}${lockNote}`.trim(), updated_at: new Date().toISOString() })
          .eq('id', account.id)

        return new Response(
          JSON.stringify({ 
            success: false, 
            error: nextAttempts >= MAX_ATTEMPTS ? 'Too many attempts. Try again later.' : 'Invalid passcode',
            lockout: nextAttempts >= MAX_ATTEMPTS,
          }),
          {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: nextAttempts >= MAX_ATTEMPTS ? 429 : 401,
          },
        )
      }

      // Reset attempt metadata after successful login.
      const cleanNotes = notes
        .split('|')
        .map((s: string) => s.trim())
        .filter((s: string) => s && !s.startsWith('attempts:') && !s.startsWith(lockPrefix))
        .join(' | ')

      await supabase
        .from('admin_created_accounts')
        .update({ notes: cleanNotes, updated_at: new Date().toISOString() })
        .eq('id', account.id)

      await supabase.rpc('mark_first_login', { p_phone: account.phone })

      return new Response(
        JSON.stringify({ 
          success: true, 
          message: 'Passcode verified successfully'
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200 
        }
      )
    }

    return new Response(
      JSON.stringify({ error: 'Invalid action' }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400 
      }
    )

  } catch (err) {
    return new Response(
      JSON.stringify({ error: err.message }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500 
      }
    )
  }
})
