// CareCompanion Edge Function: Revoke Share Session
// Allows users to revoke an active share session

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import {
  corsHeaders,
  jsonResponse,
  errorResponse,
  createAuthClient,
  createServiceClient,
  getAuthUserId,
  isProfileMember,
  isProfileOwner,
  writeAuditLog,
} from '../_shared/utils.ts'

interface RevokeShareSessionRequest {
  token: string
}

serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Parse request
    const body: RevokeShareSessionRequest = await req.json()
    const { token } = body

    if (!token) {
      return errorResponse('token is required', 400)
    }

    // Get authenticated user
    const authClient = createAuthClient(req)
    const userId = await getAuthUserId(authClient)
    if (!userId) {
      return errorResponse('Unauthorized', 401)
    }

    const serviceClient = createServiceClient()

    // Find the share session
    const { data: session, error: sessionError } = await serviceClient
      .from('share_sessions')
      .select('id, profile_id, created_by_user_id, revoked_at')
      .eq('token', token)
      .single()

    if (sessionError || !session) {
      return errorResponse('Share session not found', 404)
    }

    // Check if already revoked
    if (session.revoked_at) {
      return errorResponse('Share session is already revoked', 400)
    }

    // Check permission: creator or profile owner/member
    const canRevoke = 
      session.created_by_user_id === userId ||
      await isProfileOwner(serviceClient, session.profile_id, userId) ||
      await isProfileMember(serviceClient, session.profile_id, userId)

    if (!canRevoke) {
      return errorResponse('Permission denied', 403)
    }

    // Revoke the session
    const { error: updateError } = await serviceClient
      .from('share_sessions')
      .update({ revoked_at: new Date().toISOString() })
      .eq('id', session.id)

    if (updateError) {
      console.error('Error revoking session:', updateError)
      return errorResponse('Failed to revoke session', 500)
    }

    // Write audit log
    await writeAuditLog(
      serviceClient,
      userId,
      'SHARE_SESSION_REVOKED',
      { session_id: session.id },
      session.profile_id,
      req
    )

    return jsonResponse({
      success: true,
      message: {
        ar: 'تم إلغاء رابط المشاركة بنجاح',
        en: 'Share link revoked successfully',
      },
    })

  } catch (error) {
    console.error('Error in revoke_share_session:', error)
    return errorResponse('Internal server error', 500)
  }
})
