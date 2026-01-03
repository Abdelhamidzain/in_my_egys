-- CareCompanion RLS Policies
-- Row Level Security for all tables

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE profile_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE medications ENABLE ROW LEVEL SECURITY;
ALTER TABLE med_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE dose_instances ENABLE ROW LEVEL SECURITY;
ALTER TABLE adherence_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE pairing_invites ENABLE ROW LEVEL SECURITY;
ALTER TABLE share_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE in_app_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE feature_flags ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- PROFILES POLICIES
-- ============================================================

-- Users can view profiles they own or are members of
CREATE POLICY profiles_select ON profiles
    FOR SELECT USING (
        owner_user_id = auth.uid() 
        OR linked_user_id = auth.uid()
        OR is_profile_member(id, auth.uid())
        OR is_admin(auth.uid())
    );

-- Users can create their own profiles (with plan limits enforced in app)
CREATE POLICY profiles_insert ON profiles
    FOR INSERT WITH CHECK (
        owner_user_id = auth.uid()
    );

-- Users can update profiles they own
CREATE POLICY profiles_update ON profiles
    FOR UPDATE USING (
        owner_user_id = auth.uid()
    ) WITH CHECK (
        owner_user_id = auth.uid()
        -- linked_user_id can only be set by edge functions (service role)
        AND (linked_user_id IS NOT DISTINCT FROM (SELECT linked_user_id FROM profiles WHERE id = profiles.id))
    );

-- Users can delete profiles they own
CREATE POLICY profiles_delete ON profiles
    FOR DELETE USING (
        owner_user_id = auth.uid()
    );

-- ============================================================
-- PROFILE MEMBERS POLICIES
-- ============================================================

-- Users can view memberships for profiles they own or are members of
CREATE POLICY profile_members_select ON profile_members
    FOR SELECT USING (
        member_user_id = auth.uid()
        OR EXISTS (
            SELECT 1 FROM profiles 
            WHERE profiles.id = profile_members.profile_id 
            AND profiles.owner_user_id = auth.uid()
        )
        OR is_admin(auth.uid())
    );

-- Profile owners can add members (caregivers)
CREATE POLICY profile_members_insert ON profile_members
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE profiles.id = profile_id 
            AND profiles.owner_user_id = auth.uid()
        )
    );

-- Profile owners can update member permissions
CREATE POLICY profile_members_update ON profile_members
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE profiles.id = profile_id 
            AND profiles.owner_user_id = auth.uid()
        )
    );

-- Profile owners can remove members
CREATE POLICY profile_members_delete ON profile_members
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE profiles.id = profile_id 
            AND profiles.owner_user_id = auth.uid()
        )
        OR member_user_id = auth.uid() -- Members can remove themselves
    );

-- ============================================================
-- MEDICATIONS POLICIES
-- ============================================================

-- Users can view medications for profiles they are members of
CREATE POLICY medications_select ON medications
    FOR SELECT USING (
        is_profile_member(profile_id, auth.uid())
        OR is_profile_owner(profile_id, auth.uid())
        OR is_admin(auth.uid())
    );

-- Users with permission can create medications
CREATE POLICY medications_insert ON medications
    FOR INSERT WITH CHECK (
        can_edit_meds(profile_id, auth.uid())
    );

-- Users with permission can update medications
CREATE POLICY medications_update ON medications
    FOR UPDATE USING (
        can_edit_meds(profile_id, auth.uid())
    );

-- Users with permission can delete medications
CREATE POLICY medications_delete ON medications
    FOR DELETE USING (
        can_edit_meds(profile_id, auth.uid())
    );

-- ============================================================
-- MED SCHEDULES POLICIES
-- ============================================================

-- Users can view schedules for medications they can access
CREATE POLICY med_schedules_select ON med_schedules
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM medications 
            WHERE medications.id = med_schedules.medication_id
            AND (is_profile_member(medications.profile_id, auth.uid())
                 OR is_profile_owner(medications.profile_id, auth.uid()))
        )
        OR is_admin(auth.uid())
    );

-- Users with permission can create schedules
CREATE POLICY med_schedules_insert ON med_schedules
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM medications 
            WHERE medications.id = medication_id
            AND can_edit_meds(medications.profile_id, auth.uid())
        )
    );

-- Users with permission can update schedules
CREATE POLICY med_schedules_update ON med_schedules
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM medications 
            WHERE medications.id = medication_id
            AND can_edit_meds(medications.profile_id, auth.uid())
        )
    );

-- Users with permission can delete schedules
CREATE POLICY med_schedules_delete ON med_schedules
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM medications 
            WHERE medications.id = medication_id
            AND can_edit_meds(medications.profile_id, auth.uid())
        )
    );

-- ============================================================
-- DOSE INSTANCES POLICIES
-- ============================================================

-- Users can view dose instances for profiles they are members of
CREATE POLICY dose_instances_select ON dose_instances
    FOR SELECT USING (
        is_profile_member(profile_id, auth.uid())
        OR is_profile_owner(profile_id, auth.uid())
        OR is_admin(auth.uid())
    );

-- Insert/Update/Delete handled by service role (edge functions)
-- No direct user insert allowed to prevent manipulation
CREATE POLICY dose_instances_service_insert ON dose_instances
    FOR INSERT WITH CHECK (false); -- Only via service role

CREATE POLICY dose_instances_service_update ON dose_instances
    FOR UPDATE USING (false); -- Only via service role

-- ============================================================
-- ADHERENCE EVENTS POLICIES
-- ============================================================

-- Users can view adherence events for profiles they have permission for
CREATE POLICY adherence_events_select ON adherence_events
    FOR SELECT USING (
        can_view_profile_log(profile_id, auth.uid())
        OR is_admin(auth.uid())
    );

-- Members can insert adherence events
CREATE POLICY adherence_events_insert ON adherence_events
    FOR INSERT WITH CHECK (
        is_profile_member(profile_id, auth.uid())
        OR is_profile_owner(profile_id, auth.uid())
    );

-- No updates allowed (immutable log)
-- No deletes allowed (immutable log)

-- ============================================================
-- PAIRING INVITES POLICIES
-- ============================================================

-- Caregivers can view invites they created
CREATE POLICY pairing_invites_select ON pairing_invites
    FOR SELECT USING (
        caregiver_user_id = auth.uid()
        OR is_admin(auth.uid())
    );

-- Users can create invites for profiles they manage
CREATE POLICY pairing_invites_insert ON pairing_invites
    FOR INSERT WITH CHECK (
        caregiver_user_id = auth.uid()
        AND can_edit_meds(profile_id, auth.uid())
    );

-- Caregivers can revoke their own invites (update status)
CREATE POLICY pairing_invites_update ON pairing_invites
    FOR UPDATE USING (
        caregiver_user_id = auth.uid()
    ) WITH CHECK (
        caregiver_user_id = auth.uid()
        AND status IN ('REVOKED') -- Can only set to REVOKED
    );

-- ============================================================
-- SHARE SESSIONS POLICIES
-- ============================================================

-- Users can view share sessions for profiles they are members of
CREATE POLICY share_sessions_select ON share_sessions
    FOR SELECT USING (
        created_by_user_id = auth.uid()
        OR is_profile_member(profile_id, auth.uid())
        OR is_admin(auth.uid())
    );

-- Users can create share sessions (Pro only, enforced in edge function)
CREATE POLICY share_sessions_insert ON share_sessions
    FOR INSERT WITH CHECK (
        created_by_user_id = auth.uid()
        AND is_profile_member(profile_id, auth.uid())
    );

-- Users can revoke their own share sessions
CREATE POLICY share_sessions_update ON share_sessions
    FOR UPDATE USING (
        created_by_user_id = auth.uid()
        OR is_profile_owner(profile_id, auth.uid())
    );

-- ============================================================
-- IN-APP NOTIFICATIONS POLICIES
-- ============================================================

-- Users can only view their own notifications
CREATE POLICY notifications_select ON in_app_notifications
    FOR SELECT USING (user_id = auth.uid());

-- Notifications created by service role only
CREATE POLICY notifications_insert ON in_app_notifications
    FOR INSERT WITH CHECK (false); -- Only via service role

-- Users can mark their notifications as read
CREATE POLICY notifications_update ON in_app_notifications
    FOR UPDATE USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- Users can delete their own notifications
CREATE POLICY notifications_delete ON in_app_notifications
    FOR DELETE USING (user_id = auth.uid());

-- ============================================================
-- SUBSCRIPTIONS POLICIES
-- ============================================================

-- Users can view their own subscription
CREATE POLICY subscriptions_select ON subscriptions
    FOR SELECT USING (
        user_id = auth.uid()
        OR is_admin(auth.uid())
    );

-- Subscriptions managed by service role only (webhook handlers)
CREATE POLICY subscriptions_insert ON subscriptions
    FOR INSERT WITH CHECK (false); -- Auto-created on signup via trigger

CREATE POLICY subscriptions_update ON subscriptions
    FOR UPDATE USING (false); -- Only via service role

-- ============================================================
-- ADMIN USERS POLICIES
-- ============================================================

-- Only admins can view admin table (and service role)
CREATE POLICY admin_users_select ON admin_users
    FOR SELECT USING (is_admin(auth.uid()));

-- Admin creation/updates only via service role
CREATE POLICY admin_users_insert ON admin_users
    FOR INSERT WITH CHECK (false);

CREATE POLICY admin_users_update ON admin_users
    FOR UPDATE USING (false);

CREATE POLICY admin_users_delete ON admin_users
    FOR DELETE USING (false);

-- ============================================================
-- AUDIT LOGS POLICIES
-- ============================================================

-- Only admins can view audit logs
CREATE POLICY audit_logs_select ON audit_logs
    FOR SELECT USING (is_admin(auth.uid()));

-- Audit logs only created via service role
CREATE POLICY audit_logs_insert ON audit_logs
    FOR INSERT WITH CHECK (false); -- Only via service role

-- Audit logs are immutable
-- No update or delete policies

-- ============================================================
-- FEATURE FLAGS POLICIES
-- ============================================================

-- Anyone authenticated can read feature flags
CREATE POLICY feature_flags_select ON feature_flags
    FOR SELECT USING (auth.uid() IS NOT NULL);

-- Feature flags managed by service role only
CREATE POLICY feature_flags_update ON feature_flags
    FOR UPDATE USING (false);

-- ============================================================
-- STORAGE POLICIES
-- ============================================================

-- Note: These are defined in Supabase dashboard or via storage.policies
-- med-photos bucket: 
--   SELECT: authenticated users who are members of the profile that owns the medication
--   INSERT: authenticated users who can edit meds for the profile
--   DELETE: authenticated users who can edit meds for the profile
