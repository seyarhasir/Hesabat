import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// CORS headers
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
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

    const { action, phone, otp, deviceId } = await req.json()

    // Generate OTP
    if (action === 'generate') {
      // Generate 6-digit OTP
      const generatedOtp = Math.floor(100000 + Math.random() * 900000).toString()
      
      // Store OTP in database with 10-minute expiry
      const expiresAt = new Date(Date.now() + 10 * 60 * 1000) // 10 minutes
      
      const { error } = await supabase
        .from('otp_codes')
        .upsert({
          phone: phone,
          otp: generatedOtp,
          device_id: deviceId,
          expires_at: expiresAt,
          attempts: 0,
          verified: false,
          created_at: new Date()
        }, {
          onConflict: 'phone'
        })

      if (error) throw error

      return new Response(
        JSON.stringify({ 
          success: true, 
          otp: generatedOtp,
          message: 'OTP generated successfully'
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200 
        }
      )
    }

    // Verify OTP
    if (action === 'verify') {
      const { data: otpRecord, error: fetchError } = await supabase
        .from('otp_codes')
        .select('*')
        .eq('phone', phone)
        .eq('otp', otp)
        .gt('expires_at', new Date().toISOString())
        .single()

      if (fetchError || !otpRecord) {
        // Increment attempts
        await supabase.rpc('increment_otp_attempts', { p_phone: phone })
        
        return new Response(
          JSON.stringify({ 
            success: false, 
            error: 'Invalid or expired OTP' 
          }),
          { 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 400 
          }
        )
      }

      // Check max attempts
      if (otpRecord.attempts >= 3) {
        return new Response(
          JSON.stringify({ 
            success: false, 
            error: 'Too many attempts. Please request new OTP.',
            lockout: true
          }),
          { 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 429 
          }
        )
      }

      // Mark as verified
      await supabase
        .from('otp_codes')
        .update({ verified: true, verified_at: new Date() })
        .eq('phone', phone)

      return new Response(
        JSON.stringify({ 
          success: true, 
          message: 'OTP verified successfully'
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
