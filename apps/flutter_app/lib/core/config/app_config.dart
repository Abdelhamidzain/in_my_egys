/// App configuration constants
class AppConfig {
  AppConfig._();

  // Supabase Configuration
  static const String supabaseUrl = 'https://nlhaaqcxiurrczztyogb.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5saGFhcWN4aXVycmN6enR5b2diIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNTMyNjAsImV4cCI6MjA4MjkyOTI2MH0.6DCWvgqbOI6GGha7HQjTkyOVw4vyvc742jV_GZDMCKY';

  // App Settings
  static const String appName = 'في عيوني';
  static const String appNameAr = 'في عيوني';

  // Feature Flags
  static const bool enablePhoneOtpLinking = true;
  static const bool enablePushEscalation = true;
  static const bool enableQrShare = true;
  static const bool enablePdfExport = true;
  static const bool enableSeniorMode = true;

  // Plan Limits
  static const int freeMaxProfiles = 2;
  static const int freeMaxMedsPerProfile = 3;

  // Timing Constants
  static const int pairingInviteExpiryHours = 72;
  static const int shareSessionMinMinutes = 10;
  static const int shareSessionMaxMinutes = 30;
  static const int escalationGraceMinutes = 60;
  static const int notificationScheduleDays = 7;

  // Validation
  static const int pinMinLength = 4;
  static const int pinMaxLength = 6;
  static const int passwordMinLength = 8;
  static const int medNameMinLength = 2;
  static const int medNameMaxLength = 60;
  static const int minScheduleTimes = 1;
  static const int maxScheduleTimes = 6;
  static const int minEveryXHours = 4;
  static const int maxEveryXHours = 24;

  // Image Settings
  static const int maxImageSizeBytes = 5 * 1024 * 1024;
  static const int imageCompressQuality = 80;
  static const int imageMaxWidth = 1200;
  static const int imageMaxHeight = 1200;

  // API Endpoints
  static String get createPairingInviteUrl => '$supabaseUrl/functions/v1/create_pairing_invite';
  static String get acceptPairingInviteUrl => '$supabaseUrl/functions/v1/accept_pairing_invite';
  static String get createShareSessionUrl => '$supabaseUrl/functions/v1/create_share_session';
  static String get getSharePayloadUrl => '$supabaseUrl/functions/v1/get_share_payload';
  static String get revokeShareSessionUrl => '$supabaseUrl/functions/v1/revoke_share_session';
  static String get generateWeeklyPdfUrl => '$supabaseUrl/functions/v1/generate_weekly_pdf';
  static String get adminExportCsvUrl => '$supabaseUrl/functions/v1/admin_export_csv';
  static String get adminBanUserUrl => '$supabaseUrl/functions/v1/admin_ban_user';

  // Disclaimers
  static const String disclaimerAr = 'هذا التطبيق للتذكير والمتابعة فقط ولا يقدم نصائح طبية. اتبع تعليمات طبيبك دائماً.';
  static const String disclaimerEn = "This app is for reminders and tracking only and does not provide medical advice. Always follow your clinician's instructions.";
}
