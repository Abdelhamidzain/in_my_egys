// CareCompanion Edge Function: Admin Export CSV
// Exports data for admin dashboard

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

interface ExportRequest {
  type: 'users' | 'profiles' | 'medications' | 'adherence_summary'
  filters?: {
    date_from?: string
    date_to?: string
    plan?: 'FREE' | 'PRO'
    profile_id?: string
  }
}

serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const body: ExportRequest = await req.json()
    const { type, filters = {} } = body

    if (!type || !['users', 'profiles', 'medications', 'adherence_summary'].includes(type)) {
      return errorResponse('Invalid export type', 400)
    }

    // Get authenticated user
    const authClient = createAuthClient(req)
    const userId = await getAuthUserId(authClient)
    if (!userId) {
      return errorResponse('Unauthorized', 401)
    }

    const serviceClient = createServiceClient()

    // Verify admin role
    if (!(await isAdmin(serviceClient, userId))) {
      return errorResponse('Admin access required', 403)
    }

    let csvContent = ''
    let rowCount = 0

    switch (type) {
      case 'users': {
        // Export users with subscription info
        const { data: users } = await serviceClient
          .from('subscriptions')
          .select(`
            user_id,
            plan,
            status,
            updated_at
          `)
          .order('updated_at', { ascending: false })

        // Get user emails from auth.users (need admin API)
        const { data: authUsers } = await serviceClient.auth.admin.listUsers()
        const userMap = new Map(authUsers.users.map(u => [u.id, u]))

        csvContent = 'user_id,email,plan,status,created_at\n'
        for (const sub of users || []) {
          const authUser = userMap.get(sub.user_id)
          if (authUser) {
            csvContent += `${sub.user_id},${authUser.email || ''},${sub.plan},${sub.status},${authUser.created_at}\n`
            rowCount++
          }
        }
        break
      }

      case 'profiles': {
        let query = serviceClient
          .from('profiles')
          .select(`
            id,
            owner_user_id,
            type,
            display_name,
            relationship,
            timezone_home,
            language_pref,
            senior_mode,
            created_at
          `)
          .order('created_at', { ascending: false })

        if (filters.date_from) {
          query = query.gte('created_at', filters.date_from)
        }
        if (filters.date_to) {
          query = query.lte('created_at', filters.date_to)
        }

        const { data: profiles } = await query

        csvContent = 'id,owner_user_id,type,display_name,relationship,timezone,language,senior_mode,created_at\n'
        for (const p of profiles || []) {
          csvContent += `${p.id},${p.owner_user_id},${p.type},${p.display_name},${p.relationship},${p.timezone_home},${p.language_pref},${p.senior_mode},${p.created_at}\n`
          rowCount++
        }
        break
      }

      case 'medications': {
        let query = serviceClient
          .from('medications')
          .select(`
            id,
            profile_id,
            name,
            status,
            visual_tags,
            created_at,
            profiles!inner (
              display_name,
              owner_user_id
            )
          `)
          .order('created_at', { ascending: false })

        if (filters.profile_id) {
          query = query.eq('profile_id', filters.profile_id)
        }

        const { data: meds } = await query

        csvContent = 'id,profile_id,profile_name,medication_name,status,visual_tags,created_at\n'
        for (const m of meds || []) {
          csvContent += `${m.id},${m.profile_id},${(m.profiles as any).display_name},${m.name},${m.status},"${m.visual_tags.join(';')}",${m.created_at}\n`
          rowCount++
        }
        break
      }

      case 'adherence_summary': {
        // Aggregate adherence by profile
        let query = serviceClient
          .from('adherence_events')
          .select(`
            profile_id,
            medication_id,
            event_type,
            profiles!inner (
              display_name
            ),
            medications!inner (
              name
            )
          `)

        if (filters.date_from) {
          query = query.gte('timestamp_utc', filters.date_from)
        }
        if (filters.date_to) {
          query = query.lte('timestamp_utc', filters.date_to)
        }
        if (filters.profile_id) {
          query = query.eq('profile_id', filters.profile_id)
        }

        const { data: events } = await query

        // Aggregate by profile+medication
        const summary = new Map<string, { 
          profile_id: string
          profile_name: string
          medication_id: string
          medication_name: string
          taken: number
          skipped: number
          total: number
        }>()

        for (const e of events || []) {
          const key = `${e.profile_id}:${e.medication_id}`
          const current = summary.get(key) || {
            profile_id: e.profile_id,
            profile_name: (e.profiles as any).display_name,
            medication_id: e.medication_id,
            medication_name: (e.medications as any).name,
            taken: 0,
            skipped: 0,
            total: 0,
          }

          if (e.event_type === 'TAKEN') current.taken++
          if (e.event_type === 'SKIP') current.skipped++
          current.total++

          summary.set(key, current)
        }

        csvContent = 'profile_id,profile_name,medication_id,medication_name,taken,skipped,total,adherence_rate\n'
        for (const s of summary.values()) {
          const rate = s.total > 0 ? Math.round((s.taken / s.total) * 100) : 0
          csvContent += `${s.profile_id},${s.profile_name},${s.medication_id},${s.medication_name},${s.taken},${s.skipped},${s.total},${rate}%\n`
          rowCount++
        }
        break
      }
    }

    // Write audit log
    await writeAuditLog(
      serviceClient,
      userId,
      'ADMIN_EXPORT',
      {
        type,
        filters,
        row_count: rowCount,
      },
      undefined,
      req
    )

    // Return CSV as downloadable file
    return new Response(csvContent, {
      status: 200,
      headers: {
        ...corsHeaders,
        'Content-Type': 'text/csv',
        'Content-Disposition': `attachment; filename="carecompanion_${type}_${new Date().toISOString().split('T')[0]}.csv"`,
      },
    })

  } catch (error) {
    console.error('Error in admin_export_csv:', error)
    return errorResponse('Internal server error', 500)
  }
})
