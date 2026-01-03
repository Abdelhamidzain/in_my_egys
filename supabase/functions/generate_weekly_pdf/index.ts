// CareCompanion Edge Function: Generate Weekly PDF
// Generates a PDF report for doctor visits (Pro only)

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
  disclaimers,
} from '../_shared/utils.ts'

// Note: In production, use a proper PDF library like jsPDF or puppeteer
// This is a simplified implementation that generates HTML for PDF conversion

interface GeneratePdfRequest {
  profile_id: string
  lang: 'AR' | 'EN'
}

serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const body: GeneratePdfRequest = await req.json()
    const { profile_id, lang = 'AR' } = body

    if (!profile_id) {
      return errorResponse('profile_id is required', 400)
    }

    // Get authenticated user
    const authClient = createAuthClient(req)
    const userId = await getAuthUserId(authClient)
    if (!userId) {
      return errorResponse('Unauthorized', 401)
    }

    const serviceClient = createServiceClient()

    // Check PRO plan
    const plan = await getUserPlan(serviceClient, userId)
    if (plan !== 'PRO') {
      return errorResponse('PDF export requires a Pro subscription', 403)
    }

    // Check membership
    if (!(await isProfileMember(serviceClient, profile_id, userId))) {
      return errorResponse('Permission denied', 403)
    }

    // Get profile
    const { data: profile } = await serviceClient
      .from('profiles')
      .select('id, display_name, timezone_current')
      .eq('id', profile_id)
      .single()

    if (!profile) {
      return errorResponse('Profile not found', 404)
    }

    // Get medications with schedules
    const { data: medications } = await serviceClient
      .from('medications')
      .select(`
        id,
        name,
        instructions_text,
        pill_photo_path,
        visual_tags,
        med_schedules (
          schedule_type,
          times_local,
          days_of_week,
          every_x_hours
        )
      `)
      .eq('profile_id', profile_id)
      .eq('status', 'ACTIVE')
      .order('name')

    // Get adherence events for last 30 days
    const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000)
    const { data: events } = await serviceClient
      .from('adherence_events')
      .select('medication_id, event_type, timestamp_utc')
      .eq('profile_id', profile_id)
      .in('event_type', ['TAKEN', 'SKIP'])
      .gte('timestamp_utc', thirtyDaysAgo.toISOString())
      .order('timestamp_utc', { ascending: false })

    // Calculate adherence per medication
    const medAdherence = new Map<string, { taken: number; skipped: number }>()
    for (const event of events || []) {
      const current = medAdherence.get(event.medication_id) || { taken: 0, skipped: 0 }
      if (event.event_type === 'TAKEN') current.taken++
      if (event.event_type === 'SKIP') current.skipped++
      medAdherence.set(event.medication_id, current)
    }

    // Build HTML content (RTL for Arabic)
    const isArabic = lang === 'AR'
    const direction = isArabic ? 'rtl' : 'ltr'
    const fontFamily = isArabic ? "'Noto Naskh Arabic', Arial, sans-serif" : 'Arial, sans-serif'

    const t = {
      title: isArabic ? 'تقرير الأدوية' : 'Medication Report',
      profile: isArabic ? 'الملف الشخصي' : 'Profile',
      generatedOn: isArabic ? 'تاريخ التقرير' : 'Generated on',
      medications: isArabic ? 'قائمة الأدوية' : 'Medications',
      instructions: isArabic ? 'التعليمات' : 'Instructions',
      schedule: isArabic ? 'الجدول' : 'Schedule',
      adherence30d: isArabic ? 'الالتزام (30 يوم)' : 'Adherence (30 days)',
      taken: isArabic ? 'تم تناولها' : 'Taken',
      skipped: isArabic ? 'تم تخطيها' : 'Skipped',
      adherenceRate: isArabic ? 'نسبة الالتزام' : 'Adherence Rate',
      noMeds: isArabic ? 'لا توجد أدوية مسجلة' : 'No medications recorded',
      dailyAt: isArabic ? 'يومياً الساعة' : 'Daily at',
      everyXHours: isArabic ? 'كل X ساعات' : 'Every X hours',
      disclaimer: isArabic ? disclaimers.ar : disclaimers.en,
    }

    const formatSchedule = (schedule: any): string => {
      if (schedule.schedule_type === 'DAILY_FIXED_TIMES') {
        return `${t.dailyAt}: ${schedule.times_local.join(', ')}`
      }
      if (schedule.schedule_type === 'EVERY_X_HOURS') {
        return t.everyXHours.replace('X', schedule.every_x_hours)
      }
      return schedule.times_local.join(', ')
    }

    const medicationRows = (medications || []).map(med => {
      const adherence = medAdherence.get(med.id) || { taken: 0, skipped: 0 }
      const total = adherence.taken + adherence.skipped
      const rate = total > 0 ? Math.round((adherence.taken / total) * 100) : 0

      return `
        <tr>
          <td style="padding: 12px; border-bottom: 1px solid #eee;">
            <strong>${med.name}</strong>
            ${med.visual_tags?.length ? `<br><small style="color: #666;">${med.visual_tags.join(', ')}</small>` : ''}
          </td>
          <td style="padding: 12px; border-bottom: 1px solid #eee;">
            ${med.instructions_text || '-'}
          </td>
          <td style="padding: 12px; border-bottom: 1px solid #eee;">
            ${(med.med_schedules || []).map(formatSchedule).join('<br>')}
          </td>
          <td style="padding: 12px; border-bottom: 1px solid #eee; text-align: center;">
            <div style="font-size: 18px; font-weight: bold; color: ${rate >= 80 ? '#22c55e' : rate >= 50 ? '#f59e0b' : '#ef4444'};">
              ${rate}%
            </div>
            <small>${t.taken}: ${adherence.taken} | ${t.skipped}: ${adherence.skipped}</small>
          </td>
        </tr>
      `
    }).join('')

    const htmlContent = `
      <!DOCTYPE html>
      <html dir="${direction}" lang="${lang.toLowerCase()}">
      <head>
        <meta charset="UTF-8">
        <title>${t.title} - ${profile.display_name}</title>
        <style>
          @import url('https://fonts.googleapis.com/css2?family=Noto+Naskh+Arabic:wght@400;700&display=swap');
          body {
            font-family: ${fontFamily};
            direction: ${direction};
            margin: 0;
            padding: 20px;
            color: #333;
            line-height: 1.6;
          }
          .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #4f46e5;
          }
          .header h1 {
            color: #4f46e5;
            margin: 0;
          }
          .meta {
            color: #666;
            margin-top: 10px;
          }
          table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
          }
          th {
            background: #4f46e5;
            color: white;
            padding: 12px;
            text-align: ${isArabic ? 'right' : 'left'};
          }
          .disclaimer {
            margin-top: 40px;
            padding: 15px;
            background: #fef3c7;
            border: 1px solid #f59e0b;
            border-radius: 8px;
            font-size: 14px;
            color: #92400e;
          }
          .footer {
            margin-top: 30px;
            text-align: center;
            color: #999;
            font-size: 12px;
          }
        </style>
      </head>
      <body>
        <div class="header">
          <h1>${t.title}</h1>
          <div class="meta">
            <strong>${t.profile}:</strong> ${profile.display_name}<br>
            <strong>${t.generatedOn}:</strong> ${new Date().toLocaleDateString(isArabic ? 'ar-SA' : 'en-US', {
              year: 'numeric',
              month: 'long',
              day: 'numeric',
              hour: '2-digit',
              minute: '2-digit',
            })}
          </div>
        </div>

        <h2>${t.medications}</h2>
        ${medications?.length ? `
          <table>
            <thead>
              <tr>
                <th>${isArabic ? 'الدواء' : 'Medication'}</th>
                <th>${t.instructions}</th>
                <th>${t.schedule}</th>
                <th style="text-align: center;">${t.adherence30d}</th>
              </tr>
            </thead>
            <tbody>
              ${medicationRows}
            </tbody>
          </table>
        ` : `<p>${t.noMeds}</p>`}

        <div class="disclaimer">
          ⚠️ ${t.disclaimer}
        </div>

        <div class="footer">
          CareCompanion - ${isArabic ? 'تطبيق متابعة الأدوية' : 'Medication Companion App'}
        </div>
      </body>
      </html>
    `

    // In production, convert HTML to PDF using puppeteer, jsPDF, or a PDF service
    // For now, we'll store the HTML and return a signed URL
    // The client can use a PDF service or browser print functionality

    const timestamp = Date.now()
    const fileName = `${userId}/${profile_id}_${timestamp}.html`

    // Upload HTML to storage
    const { error: uploadError } = await serviceClient.storage
      .from('pdf-exports')
      .upload(fileName, htmlContent, {
        contentType: 'text/html',
        upsert: false,
      })

    if (uploadError) {
      console.error('Error uploading PDF:', uploadError)
      return errorResponse('Failed to generate PDF', 500)
    }

    // Generate signed URL (valid for 1 hour)
    const { data: signedUrl } = await serviceClient.storage
      .from('pdf-exports')
      .createSignedUrl(fileName, 60 * 60)

    // Write audit log
    await writeAuditLog(
      serviceClient,
      userId,
      'PDF_GENERATED',
      { file_name: fileName, lang },
      profile_id,
      req
    )

    return jsonResponse({
      success: true,
      url: signedUrl?.signedUrl,
      expires_in: 3600,
      message: {
        ar: 'تم إنشاء التقرير بنجاح. يمكنك طباعته أو حفظه كملف PDF.',
        en: 'Report generated successfully. You can print it or save as PDF.',
      },
      note: {
        ar: 'لحفظ الملف كـ PDF، استخدم خيار "طباعة" ثم "حفظ كـ PDF"',
        en: 'To save as PDF, use "Print" then "Save as PDF"',
      },
    })

  } catch (error) {
    console.error('Error in generate_weekly_pdf:', error)
    return errorResponse('Internal server error', 500)
  }
})
