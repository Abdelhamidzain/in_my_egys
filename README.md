# CareCompanion

**متابعة الأدوية للعائلة** | Family Medication Companion

A production-ready, Arabic-first medication reminder and adherence tracking app with caregiver coordination. Built with Flutter (iOS/Android/Web) and Supabase backend.

> ⚠️ **Disclaimer**: This app is for reminders and tracking only and does not provide medical advice. Always follow your clinician's instructions.
>
> هذا التطبيق للتذكير والمتابعة فقط ولا يقدم نصائح طبية. اتبع تعليمات طبيبك دائمًا.

## Features

### User Features
- **Multi-Profile Management**: Track medications for yourself and family members (Mom, Dad, Spouse, Child)
- **Medication Photos & Visual Tags**: Low-literacy friendly with pill/box photos and color/shape tags
- **Flexible Scheduling**: Daily fixed times, specific days of week, or every X hours
- **Offline-First**: Local reminders and logging work without internet
- **Caregiver Coordination**: Invite caregivers via WhatsApp, manage permissions
- **Doctor Visit Mode**: Share medication info via QR code (time-limited) or PDF export
- **Adherence Tracking**: Log taken/snooze/skip with detailed history

### Admin Features
- **User Management**: Search, view, ban/unban users
- **Profile & Medication Oversight**: View all profiles and medications
- **Analytics Dashboard**: User stats, adherence metrics, signup trends
- **Audit Logs**: Complete trail of all sensitive operations
- **CSV Export**: Export data for external analysis

### Security & Privacy
- **PIN Protection**: 4-6 digit PIN required to access app
- **Biometric Authentication**: Optional fingerprint/Face ID
- **Row-Level Security**: Supabase RLS enforces least-privilege access
- **Scoped Sharing**: Time-limited, revocable sharing sessions
- **EXIF Stripping**: Photo metadata removed on upload

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | Flutter 3.x (iOS/Android/Web) |
| **State Management** | Riverpod |
| **Routing** | go_router |
| **Local Database** | Drift (SQLite) |
| **Notifications** | flutter_local_notifications |
| **Backend** | Supabase (Auth, Postgres, RLS, Storage, Edge Functions) |
| **i18n** | intl + ARB files (Arabic/English) |

## Project Structure

```
carecompanion/
├── apps/
│   └── flutter_app/
│       ├── lib/
│       │   ├── core/           # Config, theme, validators, router
│       │   ├── data/           # Repositories, datasources, models
│       │   ├── domain/         # Entities, business logic
│       │   ├── presentation/   # Screens, providers, widgets
│       │   ├── services/       # Notification, sync services
│       │   └── l10n/           # Localization files (AR/EN)
│       └── pubspec.yaml
├── supabase/
│   ├── migrations/             # SQL schema, RLS policies, storage
│   ├── seed/                   # Demo data
│   └── functions/              # Edge Functions (TypeScript)
└── packages/
    └── shared/                 # Shared contracts, validators
```

## Getting Started

### Prerequisites

- Flutter SDK 3.16+
- Dart SDK 3.2+
- Supabase CLI (`npm install -g supabase`)
- Node.js 18+ (for Edge Functions)

### 1. Clone and Setup

```bash
git clone <repository-url>
cd carecompanion
```

### 2. Supabase Setup

#### Create Supabase Project
1. Go to [supabase.com](https://supabase.com) and create a new project
2. Note your project URL and anon key

#### Run Migrations
```bash
cd supabase

# Link to your project
supabase link --project-ref YOUR_PROJECT_REF

# Run migrations
supabase db push

# Seed demo data (optional)
supabase db reset --seed
```

#### Deploy Edge Functions
```bash
# Deploy all functions
supabase functions deploy create_pairing_invite
supabase functions deploy accept_pairing_invite
supabase functions deploy create_share_session
supabase functions deploy get_share_payload
supabase functions deploy revoke_share_session
supabase functions deploy generate_weekly_pdf
supabase functions deploy escalation_cron
supabase functions deploy admin_export_csv
supabase functions deploy admin_ban_user
supabase functions deploy admin_get_analytics
supabase functions deploy admin_get_user_detail

# Set function secrets
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

#### Configure Storage
Storage buckets are created automatically via migration. Verify:
- `med-photos`: Private bucket for medication photos
- `pdf-exports`: Private bucket for generated PDFs

### 3. Flutter Setup

```bash
cd apps/flutter_app

# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Generate Drift database
dart run build_runner build

# Create environment config
cp lib/core/config/env.example.dart lib/core/config/env.dart
# Edit env.dart with your Supabase URL and anon key
```

### 4. Environment Configuration

Create `lib/core/config/env.dart`:

```dart
class Env {
  static const supabaseUrl = 'https://YOUR_PROJECT.supabase.co';
  static const supabaseAnonKey = 'YOUR_ANON_KEY';
}
```

### 5. Run the App

```bash
# iOS Simulator
flutter run -d ios

# Android Emulator
flutter run -d android

# Web
flutter run -d chrome

# All devices
flutter run
```

## Building for Production

### Android

```bash
# Generate keystore (first time only)
keytool -genkey -v -keystore ~/carecompanion-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias carecompanion

# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Open in Xcode for signing configuration
open ios/Runner.xcworkspace

# Build
flutter build ios --release
```

### Web

```bash
flutter build web --release

# Deploy to hosting (e.g., Firebase Hosting, Vercel)
```

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Manual Test Checklist

#### Authentication Flow
- [ ] Sign up with email/password
- [ ] Receive confirmation email
- [ ] Log in successfully
- [ ] Forgot password flow works
- [ ] PIN setup and verification
- [ ] Biometric authentication (if device supports)

#### Profile Management
- [ ] Create "Self" profile
- [ ] Create managed profile for family member
- [ ] Edit profile details
- [ ] Delete profile
- [ ] Switch between profiles

#### Medication Management
- [ ] Add medication with photos
- [ ] Add visual tags
- [ ] Configure daily fixed times schedule
- [ ] Configure days of week schedule
- [ ] Configure every X hours schedule
- [ ] Edit medication details
- [ ] Pause/resume medication
- [ ] Archive medication
- [ ] Delete medication

#### Notifications & Adherence
- [ ] Receive notification at scheduled time
- [ ] Tap "Taken" - logs correctly
- [ ] Tap "Snooze" - reschedules notification
- [ ] Tap "Skip" - logs with reason
- [ ] Pre-alert notification works
- [ ] Notifications survive app restart
- [ ] Notifications work after timezone change

#### Offline Mode
- [ ] Add medication while offline
- [ ] Log dose while offline
- [ ] Changes sync when back online
- [ ] Offline banner shows/hides correctly

#### Caregiver Flow
- [ ] Create pairing invite
- [ ] WhatsApp deep link opens correctly
- [ ] Patient enters pair code
- [ ] Consent screen shows permissions
- [ ] Caregiver sees linked profile
- [ ] Permissions are enforced

#### Doctor Visit Mode
- [ ] Open doctor visit view
- [ ] Generate QR code (Pro only)
- [ ] QR contains correct data
- [ ] Share session expires correctly
- [ ] Revoke share session
- [ ] Export PDF (Pro only)

#### Admin Dashboard
- [ ] Admin login works
- [ ] View users list
- [ ] Search users
- [ ] View user details
- [ ] Ban/unban user
- [ ] View profiles list
- [ ] View medications list
- [ ] Export CSV
- [ ] View analytics
- [ ] View audit logs
- [ ] Filter audit logs

## Database Schema

### Core Tables
| Table | Purpose |
|-------|---------|
| `profiles` | Person records (Me/Mom/Dad/etc) |
| `profile_members` | User-profile relationships & permissions |
| `medications` | Medication records per profile |
| `med_schedules` | Scheduling rules |
| `adherence_events` | Taken/snooze/skip logs |
| `subscriptions` | Free/Pro plan status |

### Sharing & Coordination
| Table | Purpose |
|-------|---------|
| `pairing_invites` | Caregiver linking invites |
| `share_sessions` | QR code doctor share sessions |
| `in_app_notifications` | User notification inbox |

### Admin & Audit
| Table | Purpose |
|-------|---------|
| `admin_users` | Admin role mapping |
| `audit_logs` | Immutable action trail |

## API Reference

### Edge Functions

| Function | Auth | Description |
|----------|------|-------------|
| `create_pairing_invite` | User | Create caregiver invite with pair code |
| `accept_pairing_invite` | User | Accept invite and link profile |
| `create_share_session` | User | Create time-limited QR share |
| `get_share_payload` | Public (token) | Retrieve shared data |
| `revoke_share_session` | User | Cancel active share |
| `generate_weekly_pdf` | User (Pro) | Generate PDF export |
| `escalation_cron` | Service | Check for missed doses (scheduled) |
| `admin_export_csv` | Admin | Export data to CSV |
| `admin_ban_user` | Admin | Ban/unban user account |
| `admin_get_analytics` | Admin | Retrieve dashboard metrics |
| `admin_get_user_detail` | Admin | Get detailed user info |

## Feature Gating

| Feature | Free | Pro |
|---------|------|-----|
| Profiles | 2 max | Unlimited |
| Medications/profile | 3 max | Unlimited |
| Reminders | ✅ | ✅ |
| Adherence log | ✅ | ✅ |
| Doctor visit (on-screen) | ✅ | ✅ |
| Caregiver escalation | ❌ | ✅ |
| QR share | ❌ | ✅ |
| PDF export | ❌ | ✅ |
| Advanced summaries | ❌ | ✅ |

## Localization

The app supports Arabic (primary) and English. Language files are in `lib/l10n/`:
- `app_ar.arb` - Arabic strings
- `app_en.arb` - English strings

To add a new language:
1. Create `app_XX.arb` in `lib/l10n/`
2. Add locale to `l10n.yaml`
3. Run `flutter gen-l10n`

## Troubleshooting

### Notifications not working
1. Check app notification permissions in device settings
2. Verify timezone is set correctly
3. Check if battery optimization is disabling background services
4. On Android 13+, ensure POST_NOTIFICATIONS permission granted

### Sync issues
1. Check internet connectivity
2. Verify Supabase project is online
3. Check for RLS policy violations in Supabase logs
4. Force sync from Settings > Sync Now

### Build errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests
5. Submit a pull request

## License

[Your License Here]

## Support

For issues and questions:
- GitHub Issues: [link]
- Email: support@carecompanion.app
