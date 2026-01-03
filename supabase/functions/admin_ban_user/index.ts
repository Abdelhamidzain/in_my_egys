// CareCompanion Edge Function: Admin Ban/Unban User
// Allows admins to ban or unban users

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import {
  corsHeaders,
  jsonResponse,
  errorResponse,
  createAuthClient,
  createServiceClient,
  getAuthUserId,
  isAdmin,
  writeAuditLog,
} from '../_shared/utils.ts'

interface BanUserRequest {
  user_id: string
  action: 'ban' | 'unban'
  reason?: string
}

serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const body: BanUserRequest = await req.json()
    const { user_id: targetUserId, action, reason } = body

    if (!targetUserId) {
      return errorResponse('user_id is required', 400)
    }

    if (!action || !['ban', 'unban'].includes(action)) {
      return errorResponse('action must be "ban" or "unban"', 400)
    }

    // Get authenticated user
    const authClient = createAuthClient(req)
    const adminUserId = await getAuthUserId(authClient)
    if (!adminUserId) {
      return errorResponse('Unauthorized', 401)
    }

    const serviceClient = createServiceClient()

    // Verify admin role
    if (!(await isAdmin(serviceClient, adminUserId))) {
      return errorResponse('Admin access required', 403)
    }

    // Prevent admin from banning themselves
    if (targetUserId === adminUserId) {
      return errorResponse('Cannot ban yourself', 400)
    }

    // Check if target user exists
    const { data: targetUser, error: userError } = await serviceClient.auth.admin.getUserById(targetUserId)
    
    if (userError || !targetUser) {
      return errorResponse('User not found', 404)
    }

    // Check if target is an admin (prevent banning other admins)
    if (await isAdmin(serviceClient, targetUserId)) {
      return errorResponse('Cannot ban admin users', 403)
    }

    // Perform ban/unban action
    if (action === 'ban') {
      const { error: banError } = await serviceClient.auth.admin.updateUserById(
        targetUserId,
        { ban_duration: '876000h' } // ~100 years (effectively permanent)
      )

      if (banError) {
        console.error('Error banning user:', banError)
        return errorResponse('Failed to ban user', 500)
      }

      // Write audit log
      await writeAuditLog(
        serviceClient,
        adminUserId,
        'ADMIN_USER_BAN',
        {
          target_user_id: targetUserId,
          target_email: targetUser.user.email,
          reason: reason || 'No reason provided',
        },
        undefined,
        req
      )

      return jsonResponse({
        success: true,
        message: {
          ar: 'تم حظر المستخدم بنجاح',
          en: 'User banned successfully',
        },
        user_id: targetUserId,
        action: 'banned',
      })

    } else {
      // Unban
      const { error: unbanError } = await serviceClient.auth.admin.updateUserById(
        targetUserId,
        { ban_duration: 'none' }
      )

      if (unbanError) {
        console.error('Error unbanning user:', unbanError)
        return errorResponse('Failed to unban user', 500)
      }

      // Write audit log
      await writeAuditLog(
        serviceClient,
        adminUserId,
        'ADMIN_USER_UNBAN',
        {
          target_user_id: targetUserId,
          target_email: targetUser.user.email,
          reason: reason || 'No reason provided',
        },
        undefined,
        req
      )

      return jsonResponse({
        success: true,
        message: {
          ar: 'تم إلغاء حظر المستخدم بنجاح',
          en: 'User unbanned successfully',
        },
        user_id: targetUserId,
        action: 'unbanned',
      })
    }

  } catch (error) {
    console.error('Error in admin_ban_user:', error)
    return errorResponse('Internal server error', 500)
  }
})
