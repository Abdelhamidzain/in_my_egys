-- CareCompanion Seed Data
-- Creates admin user and demo data for testing

-- Note: This seed assumes you have already created users in Supabase Auth
-- The UUIDs below should be replaced with actual user IDs after signup

-- ============================================================
-- INSTRUCTIONS FOR SEEDING:
-- 1. First, sign up users via the app or Supabase dashboard:
--    - admin@carecompanion.app (for admin)
--    - demo@carecompanion.app (for demo user)
-- 2. Get their user IDs from auth.users table
-- 3. Replace the placeholder UUIDs below
-- 4. Run this seed file
-- ============================================================

-- Placeholder: Replace these with actual user IDs after creating users
-- You can find user IDs in Supabase Dashboard > Authentication > Users

DO $$
DECLARE
    v_admin_id UUID;
    v_demo_user_id UUID;
    v_demo_profile_id UUID;
    v_demo_profile2_id UUID;
    v_med1_id UUID;
    v_med2_id UUID;
    v_med3_id UUID;
BEGIN
    -- Get admin user (must exist)
    SELECT id INTO v_admin_id FROM auth.users WHERE email = 'admin@carecompanion.app' LIMIT 1;
    
    IF v_admin_id IS NULL THEN
        RAISE NOTICE 'Admin user not found. Please create admin@carecompanion.app first.';
    ELSE
        -- Create admin role
        INSERT INTO admin_users (user_id, role)
        VALUES (v_admin_id, 'ADMIN')
        ON CONFLICT (user_id) DO NOTHING;
        
        RAISE NOTICE 'Admin user configured: %', v_admin_id;
    END IF;
    
    -- Get demo user (must exist)
    SELECT id INTO v_demo_user_id FROM auth.users WHERE email = 'demo@carecompanion.app' LIMIT 1;
    
    IF v_demo_user_id IS NULL THEN
        RAISE NOTICE 'Demo user not found. Please create demo@carecompanion.app first.';
    ELSE
        -- Upgrade demo user to PRO for testing
        UPDATE subscriptions 
        SET plan = 'PRO', provider = 'NONE', status = 'ACTIVE'
        WHERE user_id = v_demo_user_id;
        
        -- Create SELF profile for demo user
        INSERT INTO profiles (
            id, owner_user_id, type, display_name, relationship,
            timezone_home, timezone_current, language_pref, senior_mode
        ) VALUES (
            gen_random_uuid(), v_demo_user_id, 'SELF', 'أنا', 'SELF',
            'Asia/Riyadh', 'Asia/Riyadh', 'AR', false
        ) RETURNING id INTO v_demo_profile_id;
        
        -- Add demo user as owner/patient of their own profile
        INSERT INTO profile_members (
            profile_id, member_user_id, role,
            can_add_edit_meds, can_view_log, notify_if_no_confirmation
        ) VALUES (
            v_demo_profile_id, v_demo_user_id, 'OWNER_PATIENT',
            true, true, false
        );
        
        -- Create MANAGED profile (Mom)
        INSERT INTO profiles (
            id, owner_user_id, type, display_name, relationship,
            timezone_home, timezone_current, language_pref, senior_mode
        ) VALUES (
            gen_random_uuid(), v_demo_user_id, 'MANAGED', 'أمي', 'MOTHER',
            'Asia/Riyadh', 'Asia/Riyadh', 'AR', true
        ) RETURNING id INTO v_demo_profile2_id;
        
        -- Add demo user as caregiver of mom's profile
        INSERT INTO profile_members (
            profile_id, member_user_id, role,
            can_add_edit_meds, can_view_log, notify_if_no_confirmation
        ) VALUES (
            v_demo_profile2_id, v_demo_user_id, 'CAREGIVER',
            true, true, true
        );
        
        -- Create medications for SELF profile
        INSERT INTO medications (
            id, profile_id, name, instructions_text, visual_tags, status
        ) VALUES (
            gen_random_uuid(), v_demo_profile_id,
            'فيتامين د',
            'حبة واحدة مع الإفطار',
            ARRAY['yellow', 'capsule'],
            'ACTIVE'
        ) RETURNING id INTO v_med1_id;
        
        INSERT INTO med_schedules (
            medication_id, schedule_type, times_local, pre_alert_minutes, snooze_options
        ) VALUES (
            v_med1_id, 'DAILY_FIXED_TIMES', ARRAY['08:00'], 15, ARRAY[5,10,15]
        );
        
        -- Create medications for Mom's profile
        INSERT INTO medications (
            id, profile_id, name, instructions_text, visual_tags, status
        ) VALUES (
            gen_random_uuid(), v_demo_profile2_id,
            'دواء الضغط',
            'قرص واحد صباحاً ومساءً',
            ARRAY['white', 'round', 'small'],
            'ACTIVE'
        ) RETURNING id INTO v_med2_id;
        
        INSERT INTO med_schedules (
            medication_id, schedule_type, times_local, pre_alert_minutes, snooze_options
        ) VALUES (
            v_med2_id, 'DAILY_FIXED_TIMES', ARRAY['08:00', '20:00'], 15, ARRAY[5,10,15,30]
        );
        
        INSERT INTO medications (
            id, profile_id, name, instructions_text, visual_tags, status
        ) VALUES (
            gen_random_uuid(), v_demo_profile2_id,
            'دواء السكر',
            'قرص واحد قبل الغداء بنصف ساعة',
            ARRAY['pink', 'oval'],
            'ACTIVE'
        ) RETURNING id INTO v_med3_id;
        
        INSERT INTO med_schedules (
            medication_id, schedule_type, times_local, pre_alert_minutes, snooze_options
        ) VALUES (
            v_med3_id, 'DAILY_FIXED_TIMES', ARRAY['12:30'], 30, ARRAY[5,10,15]
        );
        
        -- Create some sample adherence events (last 7 days)
        INSERT INTO adherence_events (
            profile_id, medication_id, event_type,
            timestamp_utc, timezone, device_id, idempotency_key
        )
        SELECT 
            v_demo_profile_id, v_med1_id, 'TAKEN',
            (now() - (i || ' days')::interval + '8 hours'::interval),
            'Asia/Riyadh', 'demo-device', 
            'demo-' || v_med1_id || '-' || i
        FROM generate_series(1, 7) AS i;
        
        INSERT INTO adherence_events (
            profile_id, medication_id, event_type,
            timestamp_utc, timezone, device_id, idempotency_key
        )
        SELECT 
            v_demo_profile2_id, v_med2_id, 
            CASE WHEN i % 3 = 0 THEN 'SKIP' ELSE 'TAKEN' END,
            (now() - (i || ' days')::interval + '8 hours'::interval),
            'Asia/Riyadh', 'demo-device', 
            'demo-' || v_med2_id || '-morning-' || i
        FROM generate_series(1, 7) AS i;
        
        -- Create sample notification
        INSERT INTO in_app_notifications (
            user_id, type, title, body, data, read
        ) VALUES (
            v_demo_user_id, 'SYSTEM',
            'مرحباً بك في التطبيق!',
            'شكراً لاستخدامك تطبيق متابعة الأدوية. نتمنى لك الصحة والعافية.',
            '{"action": "welcome"}'::jsonb,
            false
        );
        
        RAISE NOTICE 'Demo data created for user: %', v_demo_user_id;
        RAISE NOTICE 'Demo profile 1 (SELF): %', v_demo_profile_id;
        RAISE NOTICE 'Demo profile 2 (MANAGED/Mom): %', v_demo_profile2_id;
    END IF;
END $$;

-- ============================================================
-- ALTERNATIVE: Create admin via service role
-- Use this if you want to programmatically set up admin
-- ============================================================

-- To manually add an admin after user signup:
-- INSERT INTO admin_users (user_id, role) 
-- VALUES ('actual-user-uuid-here', 'ADMIN');

-- To manually upgrade a user to PRO:
-- UPDATE subscriptions SET plan = 'PRO' WHERE user_id = 'actual-user-uuid-here';
