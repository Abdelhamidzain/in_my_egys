// CareCompanion Edge Function: Accept Pairing Invite
// Patient accepts invite and links their account to the profile

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import {
  corsHeaders,
  jsonResponse,
  errorResponse,
  createAuthClient,
  createServiceClient,
  getAuthUserId,
  writeAuditLog,
} from '../_shared/utils.ts'

interface AcceptPairingInviteRequest {
  pair_code: string
  consent: {
    caregiver_can_add_edit_meds: boolean
    caregiver_can_view_log: boolean
    caregiver_notify_if_no_confirmation: boolean
  }
}

serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Parse request
    const body: AcceptPairingInviteRequest = await req.json()
    const { pair_code, consent } = body

    // Validate inputs
    if (!pair_code || pair_code.length !== 6) {
      return errorResponse('Valid 6-digit pair_code is required', 400)
    }

    if (!consent) {
      return errorResponse('Consent object is required', 400)
    }

    // Get authenticated user (patient)
    const authClient = createAuthClient(req)
    const patientUserId = await getAuthUserId(authClient)
    if (!patientUserId) {
      return errorResponse('Unauthorized', 401)
    }

    const serviceClient = createServiceClient()

    // Find the invite
    const { data: invite, error: inviteError } = await serviceClient
      .from('pairing_invites')
      .select(`
        id,
        profile_id,
        caregiver_user_id,
        status,
        expires_at
      `)
      .eq('pair_code', pair_code)
      .single()

    if (inviteError || !invite) {
      return errorResponse('Invalid pair code', 404)
    }

    // Check invite status
    if (invite.status !== 'PENDING') {
      return errorResponse('This invite has already been used or revoked', 400)
    }

    // Check if expired
    if (new Date(invite.expires_at) < new Date()) {
      // Mark as expired
      await serviceClient
        .from('pairing_invites')
        .update({ status: 'EXPIRED' })
        .eq('id', invite.id)
      
      return errorResponse('This invite has expired', 400)
    }

    // Check if patient is not the same as caregiver
    if (patientUserId === invite.caregiver_user_id) {
      return errorResponse('Cannot accept your own invite', 400)
    }

    // Get profile details
    const { data: profile } = await serviceClient
      .from('profiles')
      .select('id, display_name, linked_user_id')
      .eq('id', invite.profile_id)
      .single()

    if (!profile) {
      return errorResponse('Profile not found', 404)
    }

    if (profile.linked_user_id) {
      return errorResponse('Profile is already linked to another patient', 400)
    }

    // Start transaction-like operations
    // 1. Update profile to link patient
    const { error: profileUpdateError } = await serviceClient
      .from('profiles')
      .update({
        linked_user_id: patientUserId,
        type: 'LINKED',
      })
      .eq('id', invite.profile_id)

    if (profileUpdateError) {
      console.error('Error updating profile:', profileUpdateError)
      return errorResponse('Failed to link profile', 500)
    }

    // 2. Add patient as OWNER_PATIENT member
    const { error: patientMemberError } = await serviceClient
      .from('profile_members')
      .insert({
        profile_id: invite.profile_id,
        member_user_id: patientUserId,
        role: 'OWNER_PATIENT',
        can_add_edit_meds: true,
        can_view_log: true,
        notify_if_no_confirmation: false,
      })

    if (patientMemberError) {
      console.error('Error adding patient member:', patientMemberError)
      // Rollback profile update
      await serviceClient
        .from('profiles')
        .update({ linked_user_id: null, type: 'MANAGED' })
        .eq('id', invite.profile_id)
      
      return errorResponse('Failed to configure patient membership', 500)
    }

    // 3. Update caregiver permissions based on patient consent
    const { error: caregiverUpdateError } = await serviceClient
      .from('profile_members')
      .update({
        can_add_edit_meds: consent.caregiver_can_add_edit_meds,
        can_view_log: consent.caregiver_can_view_log,
        notify_if_no_confirmation: consent.caregiver_notify_if_no_confirmation,
      })
      .eq('profile_id', invite.profile_id)
      .eq('member_user_id', invite.caregiver_user_id)

    if (caregiverUpdateError) {
      console.error('Error updating caregiver permissions:', caregiverUpdateError)
    }

    // 4. Mark invite as accepted
    await serviceClient
      .from('pairing_invites')
      .update({ status: 'ACCEPTED' })
      .eq('id', invite.id)

    // 5. Create notification for caregiver
    await serviceClient.from('in_app_notifications').insert({
      user_id: invite.caregiver_user_id,
      type: 'INVITE_ACCEPTED',
      title: 'تم قبول الدعوة',
      body: `تم ربط الملف "${profile.display_name}" بنجاح`,
      data: {
        profile_id: invite.profile_id,
        action: 'invite_accepted',
      },
    })

    // Write audit log
    await writeAuditLog(
      serviceClient,
      patientUserId,
      'PAIR_INVITE_ACCEPTED',
      {
        invite_id: invite.id,
        caregiver_user_id: invite.caregiver_user_id,
        consent,
      },
      invite.profile_id,
      req
    )

    return jsonResponse({
      success: true,
      profile_id: invite.profile_id,
      profile_name: profile.display_name,
      message: {
        ar: 'تم ربط الملف بنجاح! يمكنك الآن إدارة أدويتك.',
        en: 'Profile linked successfully! You can now manage your medications.',
      },
    })

  } catch (error) {
    console.error('Error in accept_pairing_invite:', error)
    return errorResponse('Internal server error', 500)
  }
})
