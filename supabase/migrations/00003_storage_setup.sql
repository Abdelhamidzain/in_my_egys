-- CareCompanion Storage Setup
-- Create buckets and policies

-- Create the med-photos bucket (private)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'med-photos',
    'med-photos',
    false,
    5242880, -- 5MB limit
    ARRAY['image/jpeg', 'image/png', 'image/webp']
) ON CONFLICT (id) DO NOTHING;

-- Storage policies for med-photos bucket

-- Allow authenticated users to upload photos for profiles they can edit meds for
CREATE POLICY storage_med_photos_insert ON storage.objects
    FOR INSERT TO authenticated
    WITH CHECK (
        bucket_id = 'med-photos'
        AND (storage.foldername(name))[1] IN (
            SELECT p.id::text 
            FROM profiles p
            INNER JOIN profile_members pm ON p.id = pm.profile_id
            WHERE pm.member_user_id = auth.uid()
            AND (pm.role = 'OWNER_PATIENT' OR pm.can_add_edit_meds = true)
            UNION
            SELECT p.id::text
            FROM profiles p
            WHERE p.owner_user_id = auth.uid()
        )
    );

-- Allow authenticated users to view photos for profiles they are members of
CREATE POLICY storage_med_photos_select ON storage.objects
    FOR SELECT TO authenticated
    USING (
        bucket_id = 'med-photos'
        AND (storage.foldername(name))[1] IN (
            SELECT p.id::text 
            FROM profiles p
            INNER JOIN profile_members pm ON p.id = pm.profile_id
            WHERE pm.member_user_id = auth.uid()
            UNION
            SELECT p.id::text
            FROM profiles p
            WHERE p.owner_user_id = auth.uid()
            UNION
            SELECT p.id::text
            FROM profiles p
            WHERE p.linked_user_id = auth.uid()
        )
    );

-- Allow authenticated users to delete photos for profiles they can edit meds for
CREATE POLICY storage_med_photos_delete ON storage.objects
    FOR DELETE TO authenticated
    USING (
        bucket_id = 'med-photos'
        AND (storage.foldername(name))[1] IN (
            SELECT p.id::text 
            FROM profiles p
            INNER JOIN profile_members pm ON p.id = pm.profile_id
            WHERE pm.member_user_id = auth.uid()
            AND (pm.role = 'OWNER_PATIENT' OR pm.can_add_edit_meds = true)
            UNION
            SELECT p.id::text
            FROM profiles p
            WHERE p.owner_user_id = auth.uid()
        )
    );

-- Allow authenticated users to update photos for profiles they can edit meds for
CREATE POLICY storage_med_photos_update ON storage.objects
    FOR UPDATE TO authenticated
    USING (
        bucket_id = 'med-photos'
        AND (storage.foldername(name))[1] IN (
            SELECT p.id::text 
            FROM profiles p
            INNER JOIN profile_members pm ON p.id = pm.profile_id
            WHERE pm.member_user_id = auth.uid()
            AND (pm.role = 'OWNER_PATIENT' OR pm.can_add_edit_meds = true)
            UNION
            SELECT p.id::text
            FROM profiles p
            WHERE p.owner_user_id = auth.uid()
        )
    );

-- Create PDF exports bucket (private, for generated PDFs)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'pdf-exports',
    'pdf-exports',
    false,
    10485760, -- 10MB limit
    ARRAY['application/pdf']
) ON CONFLICT (id) DO NOTHING;

-- Storage policies for pdf-exports bucket

-- PDFs are uploaded by service role only
CREATE POLICY storage_pdf_exports_insert ON storage.objects
    FOR INSERT TO authenticated
    WITH CHECK (false); -- Only via service role

-- Users can view their own PDFs
CREATE POLICY storage_pdf_exports_select ON storage.objects
    FOR SELECT TO authenticated
    USING (
        bucket_id = 'pdf-exports'
        AND (storage.foldername(name))[1] = auth.uid()::text
    );
