#!/bin/bash

# CareCompanion Supabase Deployment Script
# This script deploys all Edge Functions to your Supabase project

set -e

echo "🚀 CareCompanion Supabase Deployment"
echo "======================================"

# Check if supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI not found. Install it with: npm install -g supabase"
    exit 1
fi

# Check if we're in the right directory
if [ ! -d "supabase/functions" ]; then
    echo "❌ Please run this script from the carecompanion root directory"
    exit 1
fi

# Navigate to supabase directory
cd supabase

echo ""
echo "📦 Deploying Edge Functions..."
echo "------------------------------"

FUNCTIONS=(
    "create_pairing_invite"
    "accept_pairing_invite"
    "create_share_session"
    "get_share_payload"
    "revoke_share_session"
    "generate_weekly_pdf"
    "escalation_cron"
    "admin_export_csv"
    "admin_ban_user"
    "admin_get_analytics"
    "admin_get_user_detail"
)

for func in "${FUNCTIONS[@]}"; do
    if [ -d "functions/$func" ]; then
        echo "  📤 Deploying $func..."
        supabase functions deploy "$func" --no-verify-jwt
        echo "  ✅ $func deployed"
    else
        echo "  ⚠️ $func directory not found, skipping"
    fi
done

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📝 Next steps:"
echo "  1. Set function secrets:"
echo "     supabase secrets set SUPABASE_SERVICE_ROLE_KEY=your_key"
echo ""
echo "  2. Run database migrations:"
echo "     supabase db push"
echo ""
echo "  3. Seed demo data (optional):"
echo "     supabase db reset --seed"
echo ""
echo "  4. Verify storage buckets exist:"
echo "     - med-photos"
echo "     - pdf-exports"
