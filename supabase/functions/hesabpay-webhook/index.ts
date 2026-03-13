// HesabPay Webhook Handler
// Receives payment confirmations and activates subscriptions

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { hmac } from 'https://deno.land/x/hmac@v2.0.1/mod.ts'

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

Deno.serve(async (req) => {
  // Only accept POST requests
  if (req.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 })
  }

  const body = await req.text()
  const signature = req.headers.get('x-hesabpay-signature') ?? ''

  // Verify HMAC-SHA256 signature
  const secret = Deno.env.get('HESABPAY_WEBHOOK_SECRET')
  if (!secret) {
    console.error('HESABPAY_WEBHOOK_SECRET not configured')
    return new Response('Server configuration error', { status: 500 })
  }

  const expectedSig = await hmac('sha256', secret, body, 'utf8', 'hex')
  
  if (signature !== expectedSig) {
    console.error('Invalid signature received')
    return new Response('Unauthorized', { status: 401 })
  }

  try {
    const payload = JSON.parse(body)

    // Only process successful payments
    if (payload.status !== 'SUCCESS') {
      console.log('Payment not successful, ignoring:', payload.status)
      return new Response('Ignored', { status: 200 })
    }

    const shopId = payload.metadata?.shop_id
    const plan = payload.metadata?.plan
    
    if (!shopId || !plan) {
      throw new Error('Missing shop_id or plan in metadata')
    }

    const amount = payload.amount
    const transactionId = payload.transaction_id
    const now = new Date()
    const endDate = new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000) // +30 days

    // Start a transaction
    const { error: subscriptionError } = await supabase
      .from('subscriptions')
      .insert({
        shop_id: shopId,
        plan: plan,
        amount_paid: amount,
        payment_method: 'hesabpay',
        payment_ref: transactionId,
        starts_at: now.toISOString(),
        ends_at: endDate.toISOString(),
        status: 'active'
      })

    if (subscriptionError) throw subscriptionError

    // Update shop subscription status
    const { error: shopError } = await supabase
      .from('shops')
      .update({
        subscription_status: 'active',
        subscription_ends_at: endDate.toISOString(),
        updated_at: now.toISOString()
      })
      .eq('id', shopId)

    if (shopError) throw shopError

    console.log(`Subscription activated for shop ${shopId}, plan: ${plan}`)

    return new Response(
      JSON.stringify({ 
        success: true,
        message: 'Subscription activated'
      }), 
      { 
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      }
    )

  } catch (err) {
    console.error('Webhook processing failed:', err)
    
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
