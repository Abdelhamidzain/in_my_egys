// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"
import { corsHeaders, verifyAdmin, createErrorResponse, createSuccessResponse } from "../_shared/utils.ts"

interface UserDetailRequest {
  user_id: string;
}

interface ProfileSummary {
  id: string;
  display_name: string;
  type: string;
  relationship: string;
  medication_count: number;
  is_owner: boolean;
}

interface RecentActivity {
  date: string;
  taken_count: number;
  missed_count: number;
  skipped_count: number;
}

interface UserDetailResponse {
  user: {
    id: string;
    email: string | null;
    phone: string | null;
    created_at: string;
    last_sign_in_at: string | null;
    banned: boolean;
  };
  subscription: {
    plan: string;
    status: string;
    current_period_end: string | null;
  } | null;
  profiles: ProfileSummary[];
  stats: {
    total_profiles: number;
    total_medications: number;
    total_adherence_events: number;
    adherence_rate_30d: number;
  };
  recent_activity: RecentActivity[];
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    
    // Create admin client with service role
    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    })

    // Verify admin role
    const authHeader = req.headers.get('Authorization')
    const adminVerification = await verifyAdmin(authHeader, supabaseAdmin)
    if (!adminVerification.isAdmin) {
      return createErrorResponse('Unauthorized: Admin access required', 403)
    }

    const { user_id }: UserDetailRequest = await req.json()

    if (!user_id) {
      return createErrorResponse('user_id is required', 400)
    }

    // Get user from auth.users
    const { data: authUser, error: authError } = await supabaseAdmin.auth.admin.getUserById(user_id)
    
    if (authError || !authUser.user) {
      return createErrorResponse('User not found', 404)
    }

    // Get subscription
    const { data: subscription } = await supabaseAdmin
      .from('subscriptions')
      .select('plan, status, current_period_end')
      .eq('user_id', user_id)
      .single()

    // Get profiles owned by user with medication counts
    const { data: ownedProfiles } = await supabaseAdmin
      .from('profiles')
      .select(`
        id,
        display_name,
        type,
        relationship,
        medications:medications(count)
      `)
      .eq('owner_user_id', user_id)

    // Get profiles where user is a member (not owner)
    const { data: memberProfiles } = await supabaseAdmin
      .from('profile_members')
      .select(`
        profile:profiles(
          id,
          display_name,
          type,
          relationship,
          medications:medications(count)
        )
      `)
      .eq('member_user_id', user_id)
      .neq('profile.owner_user_id', user_id)

    // Combine and format profiles
    const profiles: ProfileSummary[] = [
      ...(ownedProfiles || []).map((p: any) => ({
        id: p.id,
        display_name: p.display_name,
        type: p.type,
        relationship: p.relationship,
        medication_count: p.medications?.[0]?.count || 0,
        is_owner: true,
      })),
      ...(memberProfiles || [])
        .filter((m: any) => m.profile)
        .map((m: any) => ({
          id: m.profile.id,
          display_name: m.profile.display_name,
          type: m.profile.type,
          relationship: m.profile.relationship,
          medication_count: m.profile.medications?.[0]?.count || 0,
          is_owner: false,
        })),
    ]

    // Get all profile IDs for this user
    const profileIds = profiles.map(p => p.id)

    // Get total medications count
    const { count: totalMedications } = await supabaseAdmin
      .from('medications')
      .select('*', { count: 'exact', head: true })
      .in('profile_id', profileIds)

    // Get total adherence events
    const { count: totalAdherenceEvents } = await supabaseAdmin
      .from('adherence_events')
      .select('*', { count: 'exact', head: true })
      .in('profile_id', profileIds)

    // Calculate 30-day adherence rate
    const thirtyDaysAgo = new Date()
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30)
    
    const { data: adherenceData } = await supabaseAdmin
      .from('adherence_events')
      .select('event_type')
      .in('profile_id', profileIds)
      .gte('timestamp_utc', thirtyDaysAgo.toISOString())
      .in('event_type', ['TAKEN', 'SKIP', 'NOTIF_SHOWN'])

    let adherenceRate30d = 0
    if (adherenceData && adherenceData.length > 0) {
      const notifShown = adherenceData.filter(e => e.event_type === 'NOTIF_SHOWN').length
      const taken = adherenceData.filter(e => e.event_type === 'TAKEN').length
      if (notifShown > 0) {
        adherenceRate30d = Math.round((taken / notifShown) * 100)
      }
    }

    // Get recent activity (last 7 days)
    const recentActivity: RecentActivity[] = []
    for (let i = 6; i >= 0; i--) {
      const date = new Date()
      date.setDate(date.getDate() - i)
      const dateStr = date.toISOString().split('T')[0]
      
      const startOfDay = new Date(dateStr + 'T00:00:00.000Z')
      const endOfDay = new Date(dateStr + 'T23:59:59.999Z')
      
      const { data: dayEvents } = await supabaseAdmin
        .from('adherence_events')
        .select('event_type')
        .in('profile_id', profileIds)
        .gte('timestamp_utc', startOfDay.toISOString())
        .lte('timestamp_utc', endOfDay.toISOString())
      
      recentActivity.push({
        date: dateStr,
        taken_count: dayEvents?.filter(e => e.event_type === 'TAKEN').length || 0,
        missed_count: 0, // Missed is calculated server-side by escalation_cron
        skipped_count: dayEvents?.filter(e => e.event_type === 'SKIP').length || 0,
      })
    }

    // Create audit log entry
    await supabaseAdmin.from('audit_logs').insert({
      actor_user_id: adminVerification.userId,
      action: 'ADMIN_VIEW_USER_DETAIL',
      metadata: { target_user_id: user_id },
    })

    const response: UserDetailResponse = {
      user: {
        id: authUser.user.id,
        email: authUser.user.email || null,
        phone: authUser.user.phone || null,
        created_at: authUser.user.created_at,
        last_sign_in_at: authUser.user.last_sign_in_at || null,
        banned: authUser.user.banned || false,
      },
      subscription: subscription ? {
        plan: subscription.plan,
        status: subscription.status,
        current_period_end: subscription.current_period_end,
      } : null,
      profiles,
      stats: {
        total_profiles: profiles.length,
        total_medications: totalMedications || 0,
        total_adherence_events: totalAdherenceEvents || 0,
        adherence_rate_30d: adherenceRate30d,
      },
      recent_activity: recentActivity,
    }

    return createSuccessResponse(response)

  } catch (error) {
    console.error('Error in admin_get_user_detail:', error)
    return createErrorResponse('Internal server error', 500)
  }
})
