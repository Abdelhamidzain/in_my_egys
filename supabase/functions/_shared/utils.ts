// CareCompanion Edge Functions - Shared Utilities
// supabase/functions/_shared/utils.ts

import { createClient, SupabaseClient } from 'https://esm.sh/@supabase/supabase-js@2'

// CORS headers for all responses
export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE',
}

// Response helpers
export function jsonResponse(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  })
}

export function errorResponse(message: string, status = 400): Response {
  return jsonResponse({ error: message }, status)
}

// Create authenticated Supabase client
export function createAuthClient(req: Request): SupabaseClient {
  const authHeader = req.headers.get('Authorization')
  return createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_ANON_KEY') ?? '',
    {
      global: { headers: { Authorization: authHeader ?? '' } },
      auth: { persistSession: false },
    }
  )
}

// Create service role client (for admin operations)
export function createServiceClient(): SupabaseClient {
  return createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
    { auth: { persistSession: false } }
  )
}

// Get authenticated user ID
export async function getAuthUserId(client: SupabaseClient): Promise<string | null> {
  const { data: { user }, error } = await client.auth.getUser()
  if (error || !user) return null
  return user.id
}

// Check if user is admin
export async function isAdmin(serviceClient: SupabaseClient, userId: string): Promise<boolean> {
  const { data } = await serviceClient
    .from('admin_users')
    .select('user_id')
    .eq('user_id', userId)
    .single()
  return !!data
}

// Check if user is profile member
export async function isProfileMember(
  serviceClient: SupabaseClient,
  profileId: string,
  userId: string
): Promise<boolean> {
  const { data } = await serviceClient
    .from('profile_members')
    .select('id')
    .eq('profile_id', profileId)
    .eq('member_user_id', userId)
    .single()
  return !!data
}

// Check if user is profile owner
export async function isProfileOwner(
  serviceClient: SupabaseClient,
  profileId: string,
  userId: string
): Promise<boolean> {
  const { data } = await serviceClient
    .from('profiles')
    .select('id')
    .eq('id', profileId)
    .eq('owner_user_id', userId)
    .single()
  return !!data
}

// Check if user can edit meds for profile
export async function canEditMeds(
  serviceClient: SupabaseClient,
  profileId: string,
  userId: string
): Promise<boolean> {
  // Check if owner
  if (await isProfileOwner(serviceClient, profileId, userId)) return true
  
  // Check member permissions
  const { data } = await serviceClient
    .from('profile_members')
    .select('role, can_add_edit_meds')
    .eq('profile_id', profileId)
    .eq('member_user_id', userId)
    .single()
  
  if (!data) return false
  return data.role === 'OWNER_PATIENT' || data.can_add_edit_meds === true
}

// Get user's subscription plan
export async function getUserPlan(
  serviceClient: SupabaseClient,
  userId: string
): Promise<'FREE' | 'PRO'> {
  const { data } = await serviceClient
    .from('subscriptions')
    .select('plan')
    .eq('user_id', userId)
    .eq('status', 'ACTIVE')
    .single()
  return (data?.plan as 'FREE' | 'PRO') ?? 'FREE'
}

// Write audit log
export async function writeAuditLog(
  serviceClient: SupabaseClient,
  actorUserId: string,
  action: string,
  metadata: Record<string, unknown> = {},
  targetProfileId?: string,
  req?: Request
): Promise<void> {
  await serviceClient.from('audit_logs').insert({
    actor_user_id: actorUserId,
    target_profile_id: targetProfileId,
    action,
    metadata,
    ip_address: req?.headers.get('x-forwarded-for')?.split(',')[0] ?? null,
    user_agent: req?.headers.get('user-agent') ?? null,
  })
}

// Generate random code (for pair codes)
export function generatePairCode(): string {
  const chars = '0123456789'
  let code = ''
  for (let i = 0; i < 6; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length))
  }
  return code
}

// Generate secure token (for share sessions)
export function generateToken(length = 32): string {
  const array = new Uint8Array(length)
  crypto.getRandomValues(array)
  return Array.from(array, byte => byte.toString(16).padStart(2, '0')).join('')
}

// Validate E.164 phone format
export function isValidE164Phone(phone: string): boolean {
  return /^\+[1-9]\d{6,14}$/.test(phone)
}

// Rate limiting helper (simple in-memory, use Redis in production)
const rateLimitMap = new Map<string, { count: number; resetAt: number }>()

export function checkRateLimit(key: string, maxRequests: number, windowMs: number): boolean {
  const now = Date.now()
  const record = rateLimitMap.get(key)
  
  if (!record || record.resetAt < now) {
    rateLimitMap.set(key, { count: 1, resetAt: now + windowMs })
    return true
  }
  
  if (record.count >= maxRequests) {
    return false
  }
  
  record.count++
  return true
}

// Disclaimers
export const disclaimers = {
  ar: 'هذا التطبيق للتذكير والمتابعة فقط ولا يقدم نصائح طبية. اتبع تعليمات طبيبك دائمًا.',
  en: 'This app is for reminders and tracking only and does not provide medical advice. Always follow your clinician\'s instructions.',
}
