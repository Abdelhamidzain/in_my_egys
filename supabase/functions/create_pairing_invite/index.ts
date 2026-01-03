// CareCompanion Edge Function: Create Pairing Invite
// Creates an invite for a patient to link their profile

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import {
  corsHeaders,
  jsonResponse,
  errorResponse,
  createAuthClient,
  createServiceClient,
  getAuthUserId,
  canEditMeds,
  writeAuditLog,
  generatePairCode,
  isValidE164Phone,
  checkRateLimit,
} from '../_shared/utils.ts'

interface CreatePairingInviteRequest {
  profile_id: string
  patient_phone_e164: string
}

serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Parse request
    const body: CreatePairingInviteRequest = await req.json()
    const { profile_id, patient_phone_e164 } = body

    // Validate inputs
    if (!profile_id || !patient_phone_e164) {
      return errorResponse('profile_id and patient_phone_e164 are required', 400)
    }

    if (!isValidE164Phone(patient_phone_e164)) {
      return errorResponse('Invalid phone number format. Use E.164 format (e.g., +966501234567)', 400)
    }

    // Get authenticated user
    const authClient = createAuthClient(req)
    const userId = await getAuthUserId(authClient)
    if (!userId) {
      return errorResponse('Unauthorized', 401)
    }

    // Rate limit: 5 invites per profile per hour
    if (!checkRateLimit(`pairing:${profile_id}`, 5, 60 * 60 * 1000)) {
      return errorResponse('Rate limit exceeded. Try again later.', 429)
    }

    const serviceClient = createServiceClient()

    // Check if user can edit meds for this profile
    if (!(await canEditMeds(serviceClient, profile_id, userId))) {
      return errorResponse('Permission denied', 403)
    }

    // Check if profile exists and is not already linked
    const { data: profile, error: profileError } = await serviceClient
      .from('profiles')
      .select('id, display_name, linked_user_id, type')
      .eq('id', profile_id)
      .single()

    if (profileError || !profile) {
      return errorResponse('Profile not found', 404)
    }

    if (profile.linked_user_id) {
      return errorResponse('Profile is already linked to a patient', 400)
    }

    // Check for existing pending invite
    const { data: existingInvite } = await serviceClient
      .from('pairing_invites')
      .select('id')
      .eq('profile_id', profile_id)
      .eq('status', 'PENDING')
      .gt('expires_at', new Date().toISOString())
      .single()

    if (existingInvite) {
      // Revoke existing invite
      await serviceClient
        .from('pairing_invites')
        .update({ status: 'REVOKED' })
        .eq('id', existingInvite.id)
    }

    // Generate pair code (6 digits)
    const pairCode = generatePairCode()
    
    // Calculate expiry (72 hours from now)
    const expiresAt = new Date(Date.now() + 72 * 60 * 60 * 1000).toISOString()

    // Create universal link (replace with your actual domain)
    const appDomain = Deno.env.get('APP_DOMAIN') || 'https://carecompanion.app'
    const universalLink = `${appDomain}/pair?code=${pairCode}`

    // Create invite record
    const { data: invite, error: insertError } = await serviceClient
      .from('pairing_invites')
      .insert({
        profile_id,
        caregiver_user_id: userId,
        patient_phone_e164,
        pair_code: pairCode,
        universal_link: universalLink,
        expires_at: expiresAt,
        status: 'PENDING',
      })
      .select()
      .single()

    if (insertError) {
      console.error('Error creating invite:', insertError)
      return errorResponse('Failed to create invite', 500)
    }

    // Write audit log
    await writeAuditLog(
      serviceClient,
      userId,
      'PAIR_INVITE_CREATED',
      {
        invite_id: invite.id,
        profile_name: profile.display_name,
        expires_at: expiresAt,
      },
      profile_id,
      req
    )

    // Generate WhatsApp click-to-chat link
    const messageAr = `مرحباً! تم إضافتك في تطبيق متابعة الأدوية. رمز الربط: ${pairCode}\n\nحمّل التطبيق من الرابط: ${universalLink}`
    const whatsappLink = `https://wa.me/${patient_phone_e164.replace('+', '')}?text=${encodeURIComponent(messageAr)}`

    // Store links for different platforms
    const storeLinks = {
      ios: 'https://apps.apple.com/app/carecompanion/id000000000', // Replace with actual
      android: 'https://play.google.com/store/apps/details?id=app.carecompanion', // Replace with actual
    }

    return jsonResponse({
      success: true,
      pair_code: pairCode,
      universal_link: universalLink,
      whatsapp_link: whatsappLink,
      store_links: storeLinks,
      expires_at: expiresAt,
      message: {
        ar: `تم إنشاء دعوة الربط. رمز الربط: ${pairCode}`,
        en: `Pairing invite created. Pair code: ${pairCode}`,
      },
    })

  } catch (error) {
    console.error('Error in create_pairing_invite:', error)
    return errorResponse('Internal server error', 500)
  }
})
