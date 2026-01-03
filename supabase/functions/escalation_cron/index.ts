// CareCompanion Edge Function: Escalation Cron
// Runs every 5 minutes to check for missed doses and notify caregivers

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import {
  corsHeaders,
  jsonResponse,
  errorResponse,
  createServiceClient,
  writeAuditLog,
} from '../_shared/utils.ts'

// This function is triggered by a cron job (Supabase scheduled functions)
// or can be called manually with service role key

serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Verify service role (this should only be called by cron or admin)
    const authHeader = req.headers.get('Authorization')
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
    
    if (!authHeader?.includes(serviceRoleKey || 'invalid')) {
      // Also accept if called from Supabase dashboard/cron
      const cronSecret = Deno.env.get('CRON_SECRET')
      const providedSecret = req.headers.get('x-cron-secret')
      
      if (cronSecret && providedSecret !== cronSecret) {
        return errorResponse('Unauthorized', 401)
      }
    }

    const serviceClient = createServiceClient()
    const now = new Date()
    const graceMinutes = 60 // Default grace period

    // Find due dose instances that haven't been confirmed
    // These are doses where:
    // - Status is DUE
    // - Scheduled time + grace period has passed
    // - Profile is LINKED (has both caregiver and patient)
    const cutoffTime = new Date(now.getTime() - graceMinutes * 60 * 1000)

    const { data: overdueInstances, error: queryError } = await serviceClient
      .from('dose_instances')
      .select(`
        id,
        profile_id,
        medication_id,
        scheduled_time_utc,
        scheduled_time_local,
        medications!inner (
          name
        ),
        profiles!inner (
          id,
          display_name,
          type,
          linked_user_id
        )
      `)
      .eq('status', 'DUE')
      .lt('scheduled_time_utc', cutoffTime.toISOString())
      .eq('profiles.type', 'LINKED')
      .limit(100)

    if (queryError) {
      console.error('Error querying overdue instances:', queryError)
      return errorResponse('Failed to query overdue doses', 500)
    }

    if (!overdueInstances || overdueInstances.length === 0) {
      return jsonResponse({
        success: true,
        message: 'No overdue doses to process',
        processed: 0,
      })
    }

    let processed = 0
    let notified = 0

    for (const instance of overdueInstances) {
      try {
        // Find caregivers who should be notified
        const { data: caregivers } = await serviceClient
          .from('profile_members')
          .select('member_user_id')
          .eq('profile_id', instance.profile_id)
          .eq('role', 'CAREGIVER')
          .eq('notify_if_no_confirmation', true)

        if (caregivers && caregivers.length > 0) {
          // Create in-app notifications for each caregiver
          const notifications = caregivers.map(cg => ({
            user_id: cg.member_user_id,
            type: 'DOSE_MISSED',
            title: 'تنبيه: جرعة فائتة',
            body: `لم يتم تأكيد جرعة "${(instance.medications as any).name}" لـ "${(instance.profiles as any).display_name}"`,
            data: {
              profile_id: instance.profile_id,
              medication_id: instance.medication_id,
              dose_instance_id: instance.id,
              scheduled_time: instance.scheduled_time_local,
              action: 'dose_missed',
            },
          }))

          const { error: notifError } = await serviceClient
            .from('in_app_notifications')
            .insert(notifications)

          if (!notifError) {
            notified += caregivers.length
          }

          // TODO: Send push notifications via FCM/APNs if configured
          // This would require storing device tokens and using Firebase Admin SDK
        }

        // Mark dose as MISSED (for analytics only)
        await serviceClient
          .from('dose_instances')
          .update({
            status: 'MISSED',
            status_updated_at: now.toISOString(),
          })
          .eq('id', instance.id)

        processed++

      } catch (err) {
        console.error(`Error processing instance ${instance.id}:`, err)
      }
    }

    // Write audit log
    if (processed > 0) {
      await writeAuditLog(
        serviceClient,
        'system', // Use 'system' as actor for cron jobs
        'ESCALATION_SENT',
        {
          processed,
          notified,
          timestamp: now.toISOString(),
        }
      )
    }

    return jsonResponse({
      success: true,
      message: `Processed ${processed} overdue doses, sent ${notified} notifications`,
      processed,
      notified,
    })

  } catch (error) {
    console.error('Error in escalation_cron:', error)
    return errorResponse('Internal server error', 500)
  }
})
