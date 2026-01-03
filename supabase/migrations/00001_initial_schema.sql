-- CareCompanion Initial Schema
-- Arabic-First Medication Reminder & Adherence Tracker
-- Non-medical: reminders, logging, caregiver coordination only

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- PROFILES TABLE
-- Represents a person (Me/Mom/Dad/Child)
-- ============================================================
CREATE TABLE profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('SELF', 'MANAGED', 'LINKED')),
    display_name TEXT NOT NULL CHECK (char_length(display_name) BETWEEN 1 AND 100),
    relationship TEXT NOT NULL CHECK (relationship IN ('SELF', 'MOTHER', 'FATHER', 'SPOUSE', 'CHILD', 'GRANDPARENT', 'OTHER')),
    timezone_home TEXT NOT NULL DEFAULT 'Asia/Riyadh',
    timezone_current TEXT NOT NULL DEFAULT 'Asia/Riyadh',
    language_pref TEXT NOT NULL DEFAULT 'AR' CHECK (language_pref IN ('AR', 'EN')),
    senior_mode BOOLEAN NOT NULL DEFAULT false,
    high_contrast BOOLEAN NOT NULL DEFAULT false,
    linked_user_id UUID NULL REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_profiles_owner ON profiles(owner_user_id);
CREATE INDEX idx_profiles_linked ON profiles(linked_user_id) WHERE linked_user_id IS NOT NULL;

-- ============================================================
-- PROFILE MEMBERS TABLE
-- Membership + permissions (caregiver vs owner)
-- ============================================================
CREATE TABLE profile_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    member_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('OWNER_PATIENT', 'CAREGIVER')),
    can_add_edit_meds BOOLEAN NOT NULL DEFAULT false,
    can_view_log BOOLEAN NOT NULL DEFAULT false,
    notify_if_no_confirmation BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (profile_id, member_user_id)
);

CREATE INDEX idx_profile_members_user ON profile_members(member_user_id);
CREATE INDEX idx_profile_members_profile ON profile_members(profile_id);

-- ============================================================
-- MEDICATIONS TABLE
-- Medication records per profile
-- ============================================================
CREATE TABLE medications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL CHECK (char_length(name) BETWEEN 2 AND 60),
    instructions_text TEXT NULL CHECK (instructions_text IS NULL OR char_length(instructions_text) <= 500),
    pill_photo_path TEXT NULL,
    box_photo_path TEXT NULL,
    visual_tags TEXT[] NOT NULL DEFAULT '{}',
    status TEXT NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'PAUSED', 'ARCHIVED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_medications_profile ON medications(profile_id);
CREATE INDEX idx_medications_status ON medications(profile_id, status);

-- ============================================================
-- MED SCHEDULES TABLE
-- Scheduling rules for medications
-- ============================================================
CREATE TABLE med_schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    medication_id UUID NOT NULL REFERENCES medications(id) ON DELETE CASCADE,
    schedule_type TEXT NOT NULL CHECK (schedule_type IN ('DAILY_FIXED_TIMES', 'DAYS_OF_WEEK', 'EVERY_X_HOURS')),
    times_local TEXT[] NOT NULL DEFAULT '{}',
    days_of_week INT[] NULL CHECK (days_of_week IS NULL OR (array_length(days_of_week, 1) <= 7)),
    every_x_hours INT NULL CHECK (every_x_hours IS NULL OR (every_x_hours BETWEEN 4 AND 24)),
    pre_alert_minutes INT NOT NULL DEFAULT 15 CHECK (pre_alert_minutes BETWEEN 0 AND 60),
    snooze_options INT[] NOT NULL DEFAULT '{5,10,15,30}',
    start_date DATE NULL,
    end_date DATE NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT valid_schedule_config CHECK (
        (schedule_type = 'DAILY_FIXED_TIMES' AND array_length(times_local, 1) >= 1) OR
        (schedule_type = 'DAYS_OF_WEEK' AND array_length(days_of_week, 1) >= 1 AND array_length(times_local, 1) >= 1) OR
        (schedule_type = 'EVERY_X_HOURS' AND every_x_hours IS NOT NULL)
    )
);

CREATE INDEX idx_med_schedules_medication ON med_schedules(medication_id);

-- ============================================================
-- DOSE INSTANCES TABLE
-- Server-side generated dose occurrences for analytics/escalation
-- ============================================================
CREATE TABLE dose_instances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    medication_id UUID NOT NULL REFERENCES medications(id) ON DELETE CASCADE,
    schedule_id UUID NULL REFERENCES med_schedules(id) ON DELETE SET NULL,
    scheduled_time_utc TIMESTAMPTZ NOT NULL,
    scheduled_time_local TIMESTAMPTZ NOT NULL,
    status TEXT NOT NULL DEFAULT 'DUE' CHECK (status IN ('DUE', 'TAKEN', 'SNOOZED', 'SKIPPED', 'MISSED')),
    status_updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_dose_instances_profile_time ON dose_instances(profile_id, scheduled_time_utc);
CREATE INDEX idx_dose_instances_status ON dose_instances(status, scheduled_time_utc);
CREATE INDEX idx_dose_instances_medication ON dose_instances(medication_id);

-- ============================================================
-- ADHERENCE EVENTS TABLE
-- Event log: notif shown/opened + taken/snooze/skip
-- ============================================================
CREATE TABLE adherence_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    medication_id UUID NOT NULL REFERENCES medications(id) ON DELETE CASCADE,
    dose_instance_id UUID NULL REFERENCES dose_instances(id) ON DELETE SET NULL,
    event_type TEXT NOT NULL CHECK (event_type IN ('NOTIF_SHOWN', 'NOTIF_OPENED', 'TAKEN', 'SNOOZE', 'SKIP')),
    skip_reason TEXT NULL CHECK (skip_reason IS NULL OR skip_reason IN ('FORGOT', 'NOT_AVAILABLE', 'TRAVEL', 'OTHER')),
    notes TEXT NULL CHECK (notes IS NULL OR char_length(notes) <= 500),
    timestamp_utc TIMESTAMPTZ NOT NULL,
    timezone TEXT NOT NULL,
    device_id TEXT NOT NULL,
    idempotency_key TEXT NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_adherence_events_profile_time ON adherence_events(profile_id, timestamp_utc);
CREATE INDEX idx_adherence_events_type ON adherence_events(profile_id, event_type);
CREATE INDEX idx_adherence_events_medication ON adherence_events(medication_id);

-- ============================================================
-- PAIRING INVITES TABLE
-- Linked Profile invite via WhatsApp with pair code
-- ============================================================
CREATE TABLE pairing_invites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    caregiver_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    patient_phone_e164 TEXT NOT NULL CHECK (patient_phone_e164 ~ '^\+[1-9]\d{6,14}$'),
    pair_code TEXT NOT NULL CHECK (char_length(pair_code) = 6),
    universal_link TEXT NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    status TEXT NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'ACCEPTED', 'EXPIRED', 'REVOKED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_pairing_invites_profile ON pairing_invites(profile_id);
CREATE INDEX idx_pairing_invites_caregiver ON pairing_invites(caregiver_user_id);
CREATE INDEX idx_pairing_invites_code ON pairing_invites(pair_code) WHERE status = 'PENDING';

-- ============================================================
-- SHARE SESSIONS TABLE
-- QR doctor share sessions (token-based)
-- ============================================================
CREATE TABLE share_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    created_by_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    scope TEXT NOT NULL CHECK (scope IN ('MEDS_ONLY', 'MEDS_AND_LOG')),
    token TEXT NOT NULL UNIQUE CHECK (char_length(token) >= 32),
    expires_at TIMESTAMPTZ NOT NULL,
    revoked_at TIMESTAMPTZ NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_share_sessions_profile ON share_sessions(profile_id);
CREATE INDEX idx_share_sessions_token ON share_sessions(token);
CREATE INDEX idx_share_sessions_expires ON share_sessions(expires_at) WHERE revoked_at IS NULL;

-- ============================================================
-- IN-APP NOTIFICATIONS TABLE
-- Internal notifications list in app (not push)
-- ============================================================
CREATE TABLE in_app_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('DOSE_MISSED', 'CAREGIVER_ALERT', 'INVITE_ACCEPTED', 'SYSTEM', 'SUBSCRIPTION')),
    title TEXT NOT NULL CHECK (char_length(title) <= 200),
    body TEXT NOT NULL CHECK (char_length(body) <= 1000),
    data JSONB NOT NULL DEFAULT '{}'::jsonb,
    read BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_notifications_user ON in_app_notifications(user_id, read, created_at DESC);

-- ============================================================
-- SUBSCRIPTIONS TABLE
-- Free/Pro status
-- ============================================================
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
    plan TEXT NOT NULL DEFAULT 'FREE' CHECK (plan IN ('FREE', 'PRO')),
    provider TEXT NOT NULL DEFAULT 'NONE' CHECK (provider IN ('NONE', 'STRIPE', 'APPLE', 'GOOGLE')),
    provider_customer_id TEXT NULL,
    provider_subscription_id TEXT NULL,
    current_period_end TIMESTAMPTZ NULL,
    status TEXT NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'CANCELED', 'PAST_DUE', 'INCOMPLETE')),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_subscriptions_plan ON subscriptions(plan, status);

-- ============================================================
-- ADMIN USERS TABLE
-- Admin role mapping
-- ============================================================
CREATE TABLE admin_users (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'ADMIN' CHECK (role IN ('ADMIN')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- AUDIT LOGS TABLE
-- Immutable audit trail for sensitive actions
-- ============================================================
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_user_id UUID NOT NULL REFERENCES auth.users(id),
    target_profile_id UUID NULL REFERENCES profiles(id) ON DELETE SET NULL,
    action TEXT NOT NULL CHECK (action IN (
        'PROFILE_CREATED', 'PROFILE_UPDATED', 'PROFILE_DELETED',
        'MEDICATION_CREATED', 'MEDICATION_UPDATED', 'MEDICATION_DELETED',
        'PAIR_INVITE_CREATED', 'PAIR_INVITE_ACCEPTED', 'PAIR_INVITE_REVOKED',
        'SHARE_SESSION_CREATED', 'SHARE_SESSION_REVOKED', 'SHARE_SESSION_ACCESSED',
        'PDF_GENERATED', 'ESCALATION_SENT',
        'ADMIN_USER_VIEW', 'ADMIN_PROFILE_VIEW', 'ADMIN_EXPORT',
        'ADMIN_USER_BAN', 'ADMIN_USER_UNBAN',
        'SUBSCRIPTION_CHANGED', 'CAREGIVER_PERMISSION_CHANGED'
    )),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    ip_address INET NULL,
    user_agent TEXT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_audit_logs_actor ON audit_logs(actor_user_id, created_at DESC);
CREATE INDEX idx_audit_logs_action ON audit_logs(action, created_at DESC);
CREATE INDEX idx_audit_logs_profile ON audit_logs(target_profile_id) WHERE target_profile_id IS NOT NULL;

-- ============================================================
-- FEATURE FLAGS TABLE
-- Dynamic feature flags
-- ============================================================
CREATE TABLE feature_flags (
    key TEXT PRIMARY KEY,
    enabled BOOLEAN NOT NULL DEFAULT false,
    description TEXT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Insert default feature flags
INSERT INTO feature_flags (key, enabled, description) VALUES
    ('enable_phone_otp_linking', false, 'Enable phone OTP for linked profile patient login'),
    ('enable_push_escalation', false, 'Enable push notifications for caregiver escalation'),
    ('enable_qr_share', true, 'Enable QR code sharing for doctor visits (Pro only)'),
    ('enable_pdf_export', true, 'Enable PDF export for doctor visits (Pro only)'),
    ('enable_senior_mode', true, 'Enable senior mode UI option');

-- ============================================================
-- HELPER FUNCTIONS
-- ============================================================

-- Function to check if user is a member of a profile
CREATE OR REPLACE FUNCTION is_profile_member(p_profile_id UUID, p_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM profile_members 
        WHERE profile_id = p_profile_id 
        AND member_user_id = p_user_id
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user is profile owner
CREATE OR REPLACE FUNCTION is_profile_owner(p_profile_id UUID, p_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = p_profile_id 
        AND owner_user_id = p_user_id
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user can edit meds for a profile
CREATE OR REPLACE FUNCTION can_edit_meds(p_profile_id UUID, p_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM profile_members 
        WHERE profile_id = p_profile_id 
        AND member_user_id = p_user_id
        AND (role = 'OWNER_PATIENT' OR can_add_edit_meds = true)
    ) OR is_profile_owner(p_profile_id, p_user_id);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user can view log for a profile
CREATE OR REPLACE FUNCTION can_view_profile_log(p_profile_id UUID, p_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM profile_members 
        WHERE profile_id = p_profile_id 
        AND member_user_id = p_user_id
        AND (role = 'OWNER_PATIENT' OR can_view_log = true)
    ) OR is_profile_owner(p_profile_id, p_user_id);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user is admin
CREATE OR REPLACE FUNCTION is_admin(p_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM admin_users WHERE user_id = p_user_id
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get user's subscription plan
CREATE OR REPLACE FUNCTION get_user_plan(p_user_id UUID)
RETURNS TEXT AS $$
DECLARE
    v_plan TEXT;
BEGIN
    SELECT plan INTO v_plan FROM subscriptions 
    WHERE user_id = p_user_id AND status = 'ACTIVE';
    RETURN COALESCE(v_plan, 'FREE');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to count user's profiles
CREATE OR REPLACE FUNCTION count_user_profiles(p_user_id UUID)
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM profiles WHERE owner_user_id = p_user_id)::INTEGER;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to count profile's medications
CREATE OR REPLACE FUNCTION count_profile_meds(p_profile_id UUID)
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM medications WHERE profile_id = p_profile_id AND status != 'ARCHIVED')::INTEGER;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_medications_updated_at
    BEFORE UPDATE ON medications
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_subscriptions_updated_at
    BEFORE UPDATE ON subscriptions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Trigger to auto-create subscription on user signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO subscriptions (user_id, plan, status)
    VALUES (NEW.id, 'FREE', 'ACTIVE');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();
