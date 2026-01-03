// CareCompanion Edge Function: Get Share Payload
// Public endpoint for doctors to view shared medication info

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import {
  corsHeaders,
  jsonResponse,
  errorResponse,
  createServiceClient,
  writeAuditLog,
  checkRateLimit,
  disclaimers,
} from '../_shared/utils.ts'

interface SharePayloadMedication {
  id: string
  name: string
  instructions_text: string | null
  pill_photo_url: string | null
  box_photo_url: string | null
  visual_tags: string[]
  schedules: {
    type: string
    times: string[]
    days_of_week: number[] | null
    every_x_hours: number | null
  }[]
}

interface AdherenceSummary {
  total_doses: number
  taken_count: number
  skipped_count: number
  missed_count: number
  adherence_rate: number
}

serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Get token from URL or body
    let token: string | null = null
    
    if (req.method === 'GET') {
      const url = new URL(req.url)
      token = url.searchParams.get('token')
    } else {
      const body = await req.json()
      token = body.token
    }

    if (!token || token.length < 32) {
      return errorResponse('Valid token is required', 400)
    }

    // Get client IP for rate limiting
    const clientIp = req.headers.get('x-forwarded-for')?.split(',')[0] || 'unknown'
    
    // Rate limit: 10 requests per token per 5 minutes, 50 per IP per 5 minutes
    if (!checkRateLimit(`share:token:${token}`, 10, 5 * 60 * 1000)) {
      return errorResponse('Rate limit exceeded', 429)
    }
    if (!checkRateLimit(`share:ip:${clientIp}`, 50, 5 * 60 * 1000)) {
      return errorResponse('Rate limit exceeded', 429)
    }

    const serviceClient = createServiceClient()

    // Find the share session
    const { data: session, error: sessionError } = await serviceClient
      .from('share_sessions')
      .select(`
        id,
        profile_id,
        created_by_user_id,
        scope,
        expires_at,
        revoked_at
      `)
      .eq('token', token)
      .single()

    if (sessionError || !session) {
      return errorResponse('Invalid or expired share link', 404)
    }

    // Check if session is valid
    if (session.revoked_at) {
      return errorResponse('This share link has been revoked', 403)
    }

    if (new Date(session.expires_at) < new Date()) {
      return errorResponse('This share link has expired', 403)
    }

    // Get profile info
    const { data: profile } = await serviceClient
      .from('profiles')
      .select('id, display_name, language_pref, timezone_current')
      .eq('id', session.profile_id)
      .single()

    if (!profile) {
      return errorResponse('Profile not found', 404)
    }

    // Get active medications with schedules
    const { data: medications } = await serviceClient
      .from('medications')
      .select(`
        id,
        name,
        instructions_text,
        pill_photo_path,
        box_photo_path,
        visual_tags,
        med_schedules (
          schedule_type,
          times_local,
          days_of_week,
          every_x_hours
        )
      `)
      .eq('profile_id', session.profile_id)
      .eq('status', 'ACTIVE')
      .order('name')

    // Generate signed URLs for photos
    const medicationPayload: SharePayloadMedication[] = await Promise.all(
      (medications || []).map(async (med) => {
        let pillPhotoUrl: string | null = null
        let boxPhotoUrl: string | null = null

        if (med.pill_photo_path) {
          const { data: pillUrl } = await serviceClient.storage
            .from('med-photos')
            .createSignedUrl(med.pill_photo_path, 30 * 60) // 30 min
          pillPhotoUrl = pillUrl?.signedUrl || null
        }

        if (med.box_photo_path) {
          const { data: boxUrl } = await serviceClient.storage
            .from('med-photos')
            .createSignedUrl(med.box_photo_path, 30 * 60)
          boxPhotoUrl = boxUrl?.signedUrl || null
        }

        return {
          id: med.id,
          name: med.name,
          instructions_text: med.instructions_text,
          pill_photo_url: pillPhotoUrl,
          box_photo_url: boxPhotoUrl,
          visual_tags: med.visual_tags,
          schedules: (med.med_schedules || []).map((s: any) => ({
            type: s.schedule_type,
            times: s.times_local,
            days_of_week: s.days_of_week,
            every_x_hours: s.every_x_hours,
          })),
        }
      })
    )

    // Build response payload
    const payload: Record<string, any> = {
      profile_name: profile.display_name,
      timezone: profile.timezone_current,
      language: profile.language_pref,
      medications: medicationPayload,
      medication_count: medicationPayload.length,
      generated_at: new Date().toISOString(),
      expires_at: session.expires_at,
      disclaimer: disclaimers,
    }

    // Add adherence summary if scope includes log
    if (session.scope === 'MEDS_AND_LOG') {
      // Calculate adherence for last 7 and 30 days
      const now = new Date()
      const sevenDaysAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000)
      const thirtyDaysAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000)

      const { data: events7d } = await serviceClient
        .from('adherence_events')
        .select('event_type')
        .eq('profile_id', session.profile_id)
        .in('event_type', ['TAKEN', 'SKIP'])
        .gte('timestamp_utc', sevenDaysAgo.toISOString())

      const { data: events30d } = await serviceClient
        .from('adherence_events')
        .select('event_type')
        .eq('profile_id', session.profile_id)
        .in('event_type', ['TAKEN', 'SKIP'])
        .gte('timestamp_utc', thirtyDaysAgo.toISOString())

      const calculateSummary = (events: any[]): AdherenceSummary => {
        const total = events?.length || 0
        const taken = events?.filter(e => e.event_type === 'TAKEN').length || 0
        const skipped = events?.filter(e => e.event_type === 'SKIP').length || 0
        return {
          total_doses: total,
          taken_count: taken,
          skipped_count: skipped,
          missed_count: 0, // Would need dose_instances to calculate missed
          adherence_rate: total > 0 ? Math.round((taken / total) * 100) : 0,
        }
      }

      payload.adherence_summary = {
        last_7_days: calculateSummary(events7d || []),
        last_30_days: calculateSummary(events30d || []),
      }
    }

    // Write audit log for access
    await writeAuditLog(
      serviceClient,
      session.created_by_user_id,
      'SHARE_SESSION_ACCESSED',
      {
        session_id: session.id,
        scope: session.scope,
        client_ip: clientIp,
      },
      session.profile_id,
      req
    )

    return jsonResponse(payload)

  } catch (error) {
    console.error('Error in get_share_payload:', error)
    return errorResponse('Internal server error', 500)
  }
})
