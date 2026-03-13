// Sync Conflict Resolution Edge Function
// Handles offline sync conflicts server-side

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

Deno.serve(async (req) => {
  // Verify JWT - only authenticated shop owners can call this
  const authHeader = req.headers.get('Authorization')
  if (!authHeader?.startsWith('Bearer ')) {
    return new Response('Unauthorized', { status: 401 })
  }

  const jwt = authHeader.replace('Bearer ', '')
  
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_ANON_KEY')!,
    { 
      global: { 
        headers: { Authorization: `Bearer ${jwt}` } 
      } 
    }
  )

  // Verify the user is authenticated
  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    return new Response('Invalid token', { status: 401 })
  }

  try {
    const { conflicts } = await req.json()
    
    if (!Array.isArray(conflicts)) {
      throw new Error('Invalid request: conflicts must be an array')
    }

    const results = []
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    for (const conflict of conflicts) {
      const { table, local_record, server_record, resolution } = conflict

      // Verify the user owns the shop for this record
      const shopId = local_record.shop_id || server_record.shop_id
      const { data: shop } = await supabaseAdmin
        .from('shops')
        .select('owner_id')
        .eq('id', shopId)
        .single()

      if (!shop || shop.owner_id !== user.id) {
        results.push({ 
          id: local_record.id, 
          resolved: false, 
          error: 'Unauthorized: not your shop' 
        })
        continue
      }

      if (resolution === 'use_local') {
        // Client chose local version - update server
        const { error } = await supabaseAdmin
          .from(table)
          .update({
            ...local_record,
            updated_at: new Date().toISOString()
          })
          .eq('id', local_record.id)

        results.push({ 
          id: local_record.id, 
          resolved: !error,
          error: error?.message 
        })

      } else if (resolution === 'use_server') {
        // Client chose server version - just mark as resolved
        results.push({ 
          id: server_record.id, 
          resolved: true, 
          use_server: true 
        })

      } else if (resolution === 'merge') {
        // Merge strategy - combine fields (last-updated wins for most fields)
        const merged = {
          ...server_record,
          ...local_record,
          updated_at: new Date().toISOString()
        }

        const { error } = await supabaseAdmin
          .from(table)
          .update(merged)
          .eq('id', local_record.id)

        results.push({ 
          id: local_record.id, 
          resolved: !error,
          merged: true,
          error: error?.message 
        })

      } else {
        results.push({ 
          id: local_record.id, 
          resolved: false, 
          error: 'Invalid resolution strategy' 
        })
      }
    }

    return new Response(
      JSON.stringify({ results }), 
      {
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      }
    )

  } catch (err) {
    console.error('Conflict resolution failed:', err)
    
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
