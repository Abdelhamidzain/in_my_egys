// CareCompanion Edge Function: Create Share Session
// Creates a time-limited QR share session for doctor visits

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import {
  corsHeaders,
  jsonResponse,
  errorResponse,
  createAuthClient,
  createServiceClient,
  getAuthUserId,
  isProfileMember,
  getUserPlan,
  writeAuditLog,
  generateToken,
} from '../_shared/utils.ts'

interface CreateShareSessionRequest {
  profile_id: string
  scope: 'MEDS_ONLY' | 'MEDS_AND_LOG'
  expiry_minutes: number // 10-30 minutes
}

serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Parse request
    const body: CreateShareSessionRequest = await req.json()
    const { profile_id, scope, expiry_minutes } = body

    // Validate inputs
    if (!profile_id) {
      return errorResponse('profile_id is required', 400)
    }

    if (!scope || !['MEDS_ONLY', 'MEDS_AND_LOG'].includes(scope)) {
      return errorResponse('scope must be MEDS_ONLY or MEDS_AND_LOG', 400)
    }

    if (!expiry_minutes || expiry_minutes < 10 || expiry_minutes > 30) {
      return errorResponse('expiry_minutes must be between 10 and 30', 400)
    }

    // Get authenticated user
    const authClient = createAuthClient(req)
    const userId = await getAuthUserId(authClient)
    if (!userId) {
      return errorResponse('Unauthorized', 401)
    }

    const serviceClient = createServiceClient()

    // Check PRO plan requirement
    const plan = await getUserPlan(serviceClient, userId)
    if (plan !== 'PRO') {
      return errorResponse('QR sharing requires a Pro subscription', 403)
    }

    // Check if user is member of profile
    if (!(await isProfileMember(serviceClient, profile_id, userId))) {
      return errorResponse('Permission denied', 403)
    }

    // Check if profile exists
    const { data: profile, error: profileError } = await serviceClient
      .from('profiles')
      .select('id, display_name')
      .eq('id', profile_id)
      .single()

    if (profileError || !profile) {
      return errorResponse('Profile not found', 404)
    }

    // Revoke any existing active sessions for this profile
    await serviceClient
      .from('share_sessions')
      .update({ revoked_at: new Date().toISOString() })
      .eq('profile_id', profile_id)
      .is('revoked_at', null)
      .gt('expires_at', new Date().toISOString())

    // Generate secure token
    const token = generateToken(32)

    // Calculate expiry
    const expiresAt = new Date(Date.now() + expiry_minutes * 60 * 1000).toISOString()

    // Create share session
    const { data: session, error: insertError } = await serviceClient
      .from('share_sessions')
      .insert({
        profile_id,
        created_by_user_id: userId,
        scope,
        token,
        expires_at: expiresAt,
      })
      .select()
      .single()

    if (insertError) {
      console.error('Error creating share session:', insertError)
      return errorResponse('Failed to create share session', 500)
    }

    // Create QR URL (doctor view endpoint)
    const appDomain = Deno.env.get('APP_DOMAIN') || 'https://carecompanion.app'
    const qrUrl = `${appDomain}/share/${token}`

    // Write audit log
    await writeAuditLog(
      serviceClient,
      userId,
      'SHARE_SESSION_CREATED',
      {
        session_id: session.id,
        scope,
        expiry_minutes,
        expires_at: expiresAt,
      },
      profile_id,
      req
    )

    return jsonResponse({
      success: true,
      token,
      qr_url: qrUrl,
      scope,
      expires_at: expiresAt,
      expiry_minutes,
      message: {
        ar: `تم إنشاء رابط المشاركة. صالح لمدة ${expiry_minutes} دقيقة.`,
        en: `Share link created. Valid for ${expiry_minutes} minutes.`,
      },
    })

  } catch (error) {
    console.error('Error in create_share_session:', error)
    return errorResponse('Internal server error', 500)
  }
})
