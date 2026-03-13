// Exchange Rates Edge Function
// Fetches daily exchange rates and stores them in the database
// Scheduled via pg_cron to run at 6am Afghanistan time (01:30 UTC)

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

Deno.serve(async (_req) => {
  try {
    const apiKey = Deno.env.get('EXCHANGE_RATE_API_KEY')
    
    if (!apiKey) {
      throw new Error('EXCHANGE_RATE_API_KEY not configured')
    }

    // Fetch from ExchangeRate-API (free tier — 1,500 req/month)
    const res = await fetch(
      `https://v6.exchangerate-api.com/v6/${apiKey}/latest/AFN`
    )
    
    if (!res.ok) {
      throw new Error(`API request failed: ${res.status} ${res.statusText}`)
    }
    
    const data = await res.json()

    if (data.result !== 'success') {
      throw new Error(`API error: ${data['error-type'] || 'Unknown error'}`)
    }

    const rates = data.conversion_rates
    const now = new Date()

    // Upsert AFN → USD and AFN → PKR rates, plus inverses
    const { error } = await supabase
      .from('exchange_rates')
      .upsert([
        { from_currency: 'AFN', to_currency: 'USD', rate: rates.USD, fetched_at: now },
        { from_currency: 'AFN', to_currency: 'PKR', rate: rates.PKR, fetched_at: now },
        { from_currency: 'USD', to_currency: 'AFN', rate: 1 / rates.USD, fetched_at: now },
        { from_currency: 'PKR', to_currency: 'AFN', rate: 1 / rates.PKR, fetched_at: now },
        { from_currency: 'USD', to_currency: 'PKR', rate: rates.PKR / rates.USD, fetched_at: now },
        { from_currency: 'PKR', to_currency: 'USD', rate: rates.USD / rates.PKR, fetched_at: now },
      ], { onConflict: 'from_currency,to_currency' })

    if (error) throw error

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: 'Exchange rates updated successfully',
        rates: {
          AFN_USD: rates.USD,
          AFN_PKR: rates.PKR,
          USD_AFN: 1 / rates.USD,
          PKR_AFN: 1 / rates.PKR,
        },
        fetched_at: now.toISOString()
      }), 
      {
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      }
    )
  } catch (err) {
    console.error('Exchange rate sync failed:', err)
    
    return new Response(
      JSON.stringify({ 
        success: false, 
        error: err.message 
      }), 
      { 
        status: 500,
        headers: { 'Content-Type': 'application/json' }
      }
    )
  }
})
