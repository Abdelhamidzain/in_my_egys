import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { corsHeaders, verifyAdmin, createAuditLog } from '../_shared/utils.ts';

interface AnalyticsResponse {
  total_users: number;
  pro_users: number;
  free_users: number;
  active_users_7d: number;
  active_users_30d: number;
  total_profiles: number;
  linked_profiles: number;
  managed_profiles: number;
  total_medications: number;
  active_medications: number;
  doses_confirmed_today: number;
  doses_confirmed_week: number;
  doses_confirmed_month: number;
  doses_missed_today: number;
  doses_missed_week: number;
  adherence_rate_today: number;
  adherence_rate_week: number;
  adherence_rate_month: number;
  caregiver_link_count: number;
  caregiver_link_rate: number;
  share_sessions: number;
  pdf_exports: number;
  signup_trend: Array<{ date: string; count: number }>;
  adherence_trend: Array<{ date: string; taken: number; missed: number; rate: number }>;
}

serve(async (req: Request) => {
  // Handle CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    // Create Supabase client with service role for admin access
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Get auth token from request
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: 'Missing authorization header' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Verify admin status
    const token = authHeader.replace('Bearer ', '');
    const { data: { user }, error: authError } = await supabase.auth.getUser(token);
    
    if (authError || !user) {
      return new Response(
        JSON.stringify({ error: 'Invalid token' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    const isAdmin = await verifyAdmin(supabase, user.id);
    if (!isAdmin) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized: Admin access required' }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Calculate date ranges
    const now = new Date();
    const todayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate()).toISOString();
    const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000).toISOString();
    const monthAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000).toISOString();

    // Get total users count from subscriptions (one per user)
    const { count: totalUsers } = await supabase
      .from('subscriptions')
      .select('*', { count: 'exact', head: true });

    // Get pro users count
    const { count: proUsers } = await supabase
      .from('subscriptions')
      .select('*', { count: 'exact', head: true })
      .eq('plan', 'PRO')
      .eq('status', 'ACTIVE');

    // Get free users count
    const { count: freeUsers } = await supabase
      .from('subscriptions')
      .select('*', { count: 'exact', head: true })
      .eq('plan', 'FREE');

    // Active users last 7 days (users with adherence events)
    const { data: activeUsers7d } = await supabase
      .from('adherence_events')
      .select('profile_id')
      .gte('timestamp_utc', weekAgo);
    
    const uniqueActiveUsers7d = new Set(activeUsers7d?.map(e => e.profile_id) || []).size;

    // Active users last 30 days
    const { data: activeUsers30d } = await supabase
      .from('adherence_events')
      .select('profile_id')
      .gte('timestamp_utc', monthAgo);
    
    const uniqueActiveUsers30d = new Set(activeUsers30d?.map(e => e.profile_id) || []).size;

    // Profile counts
    const { count: totalProfiles } = await supabase
      .from('profiles')
      .select('*', { count: 'exact', head: true });

    const { count: linkedProfiles } = await supabase
      .from('profiles')
      .select('*', { count: 'exact', head: true })
      .eq('type', 'LINKED');

    const { count: managedProfiles } = await supabase
      .from('profiles')
      .select('*', { count: 'exact', head: true })
      .eq('type', 'MANAGED');

    // Medication counts
    const { count: totalMedications } = await supabase
      .from('medications')
      .select('*', { count: 'exact', head: true });

    const { count: activeMedications } = await supabase
      .from('medications')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'ACTIVE');

    // Adherence events - today
    const { count: takenToday } = await supabase
      .from('adherence_events')
      .select('*', { count: 'exact', head: true })
      .eq('event_type', 'TAKEN')
      .gte('timestamp_utc', todayStart);

    const { count: missedTodaySkip } = await supabase
      .from('adherence_events')
      .select('*', { count: 'exact', head: true })
      .eq('event_type', 'SKIP')
      .gte('timestamp_utc', todayStart);

    // Adherence events - this week
    const { count: takenWeek } = await supabase
      .from('adherence_events')
      .select('*', { count: 'exact', head: true })
      .eq('event_type', 'TAKEN')
      .gte('timestamp_utc', weekAgo);

    const { count: missedWeek } = await supabase
      .from('adherence_events')
      .select('*', { count: 'exact', head: true })
      .eq('event_type', 'SKIP')
      .gte('timestamp_utc', weekAgo);

    // Adherence events - this month
    const { count: takenMonth } = await supabase
      .from('adherence_events')
      .select('*', { count: 'exact', head: true })
      .eq('event_type', 'TAKEN')
      .gte('timestamp_utc', monthAgo);

    // Calculate adherence rates
    const totalToday = (takenToday || 0) + (missedTodaySkip || 0);
    const adherenceRateToday = totalToday > 0 ? ((takenToday || 0) / totalToday) * 100 : 0;

    const totalWeek = (takenWeek || 0) + (missedWeek || 0);
    const adherenceRateWeek = totalWeek > 0 ? ((takenWeek || 0) / totalWeek) * 100 : 0;

    // Get caregiver link count
    const { count: caregiverLinkCount } = await supabase
      .from('profile_members')
      .select('*', { count: 'exact', head: true })
      .eq('role', 'CAREGIVER');

    const caregiverLinkRate = (totalUsers || 0) > 0 
      ? ((caregiverLinkCount || 0) / (totalUsers || 1)) * 100 
      : 0;

    // Share sessions count (last 30 days)
    const { count: shareSessions } = await supabase
      .from('share_sessions')
      .select('*', { count: 'exact', head: true })
      .gte('created_at', monthAgo);

    // PDF exports count (from audit logs)
    const { count: pdfExports } = await supabase
      .from('audit_logs')
      .select('*', { count: 'exact', head: true })
      .eq('action', 'PDF_GENERATED')
      .gte('created_at', monthAgo);

    // Signup trend (last 7 days)
    const signupTrend: Array<{ date: string; count: number }> = [];
    for (let i = 6; i >= 0; i--) {
      const date = new Date(now.getTime() - i * 24 * 60 * 60 * 1000);
      const dateStr = date.toISOString().split('T')[0];
      const nextDate = new Date(date.getTime() + 24 * 60 * 60 * 1000).toISOString().split('T')[0];
      
      const { count } = await supabase
        .from('subscriptions')
        .select('*', { count: 'exact', head: true })
        .gte('updated_at', dateStr)
        .lt('updated_at', nextDate);

      signupTrend.push({ date: dateStr, count: count || 0 });
    }

    // Adherence trend (last 7 days)
    const adherenceTrend: Array<{ date: string; taken: number; missed: number; rate: number }> = [];
    for (let i = 6; i >= 0; i--) {
      const date = new Date(now.getTime() - i * 24 * 60 * 60 * 1000);
      const dateStr = date.toISOString().split('T')[0];
      const nextDate = new Date(date.getTime() + 24 * 60 * 60 * 1000).toISOString().split('T')[0];
      
      const { count: taken } = await supabase
        .from('adherence_events')
        .select('*', { count: 'exact', head: true })
        .eq('event_type', 'TAKEN')
        .gte('timestamp_utc', dateStr)
        .lt('timestamp_utc', nextDate);

      const { count: missed } = await supabase
        .from('adherence_events')
        .select('*', { count: 'exact', head: true })
        .eq('event_type', 'SKIP')
        .gte('timestamp_utc', dateStr)
        .lt('timestamp_utc', nextDate);

      const total = (taken || 0) + (missed || 0);
      const rate = total > 0 ? ((taken || 0) / total) * 100 : 0;

      adherenceTrend.push({
        date: dateStr,
        taken: taken || 0,
        missed: missed || 0,
        rate,
      });
    }

    // Create audit log for analytics view
    await createAuditLog(supabase, {
      actor_user_id: user.id,
      action: 'ADMIN_VIEW_ANALYTICS',
      metadata: { timestamp: now.toISOString() },
    });

    const response: AnalyticsResponse = {
      total_users: totalUsers || 0,
      pro_users: proUsers || 0,
      free_users: freeUsers || 0,
      active_users_7d: uniqueActiveUsers7d,
      active_users_30d: uniqueActiveUsers30d,
      total_profiles: totalProfiles || 0,
      linked_profiles: linkedProfiles || 0,
      managed_profiles: managedProfiles || 0,
      total_medications: totalMedications || 0,
      active_medications: activeMedications || 0,
      doses_confirmed_today: takenToday || 0,
      doses_confirmed_week: takenWeek || 0,
      doses_confirmed_month: takenMonth || 0,
      doses_missed_today: missedTodaySkip || 0,
      doses_missed_week: missedWeek || 0,
      adherence_rate_today: adherenceRateToday,
      adherence_rate_week: adherenceRateWeek,
      adherence_rate_month: adherenceRateWeek, // Using week for now
      caregiver_link_count: caregiverLinkCount || 0,
      caregiver_link_rate: caregiverLinkRate,
      share_sessions: shareSessions || 0,
      pdf_exports: pdfExports || 0,
      signup_trend: signupTrend,
      adherence_trend: adherenceTrend,
    };

    return new Response(
      JSON.stringify(response),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('Error fetching analytics:', error);
    return new Response(
      JSON.stringify({ error: 'Internal server error', details: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
