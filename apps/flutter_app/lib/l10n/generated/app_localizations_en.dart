// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'In My Eyes';

  @override
  String get disclaimer =>
      'This app is for reminders and tracking only and does not provide medical advice. Always follow your clinician\'s instructions.';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomeSubtitle => 'Medication companion for families';

  @override
  String get login => 'Log In';

  @override
  String get signup => 'Sign Up';

  @override
  String get logout => 'Log Out';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get confirmEmail => 'Confirm Email';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get phone => 'Phone Number';

  @override
  String get name => 'Name';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Invalid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password is too short (minimum 8 characters)';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get today => 'Today';

  @override
  String get medications => 'Medications';

  @override
  String get log => 'Log';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get nextDose => 'Next Dose';

  @override
  String dueAt(String time) {
    return 'Due at $time';
  }

  @override
  String dueIn(String duration) {
    return 'In $duration';
  }

  @override
  String get overdue => 'Overdue';

  @override
  String get taken => 'Taken';

  @override
  String get snooze => 'Snooze';

  @override
  String get skip => 'Skip';

  @override
  String get snoozeOptions => 'Snooze Options';

  @override
  String snoozeMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get skipReason => 'Skip Reason';

  @override
  String get skipReasonForgot => 'Forgot';

  @override
  String get skipReasonNotAvailable => 'Not available';

  @override
  String get skipReasonTravel => 'Traveling';

  @override
  String get skipReasonOther => 'Other';

  @override
  String get todaySchedule => 'Today\'s Schedule';

  @override
  String get noMedicationsToday => 'No medications scheduled for today';

  @override
  String get allDosesCompleted => 'All doses completed!';

  @override
  String get profiles => 'Profiles';

  @override
  String get addProfile => 'Add Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get deleteProfile => 'Delete Profile';

  @override
  String get switchProfile => 'Switch Profile';

  @override
  String get profileName => 'Profile Name';

  @override
  String get relationship => 'Relationship';

  @override
  String get relationshipSelf => 'Self';

  @override
  String get relationshipMother => 'Mother';

  @override
  String get relationshipFather => 'Father';

  @override
  String get relationshipSpouse => 'Spouse';

  @override
  String get relationshipChild => 'Child';

  @override
  String get relationshipGrandparent => 'Grandparent';

  @override
  String get relationshipOther => 'Other';

  @override
  String get profileTypeSelf => 'My Profile';

  @override
  String get profileTypeManaged => 'Managed Profile';

  @override
  String get profileTypeLinked => 'Linked Profile';

  @override
  String get seniorMode => 'Senior Mode';

  @override
  String get seniorModeDescription => 'Larger buttons and simpler interface';

  @override
  String get highContrast => 'High Contrast';

  @override
  String get addMedication => 'Add Medication';

  @override
  String get editMedication => 'Edit Medication';

  @override
  String get medicationName => 'Medication Name';

  @override
  String get instructions => 'Instructions';

  @override
  String get instructionsHint => 'e.g., Take one tablet after meals';

  @override
  String get medicationPhotos => 'Medication Photos';

  @override
  String get pillPhoto => 'Pill Photo';

  @override
  String get boxPhoto => 'Box Photo';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get visualTags => 'Visual Tags';

  @override
  String get visualTagWhite => 'White';

  @override
  String get visualTagPink => 'Pink';

  @override
  String get visualTagBlue => 'Blue';

  @override
  String get visualTagYellow => 'Yellow';

  @override
  String get visualTagGreen => 'Green';

  @override
  String get visualTagRound => 'Round';

  @override
  String get visualTagOval => 'Oval';

  @override
  String get visualTagCapsule => 'Capsule';

  @override
  String get visualTagSmall => 'Small';

  @override
  String get visualTagLarge => 'Large';

  @override
  String get schedule => 'Schedule';

  @override
  String get scheduleType => 'Schedule Type';

  @override
  String get dailyFixedTimes => 'Daily at fixed times';

  @override
  String get daysOfWeek => 'Specific days of the week';

  @override
  String get everyXHours => 'Every few hours';

  @override
  String get selectTimes => 'Select Times';

  @override
  String get addTime => 'Add Time';

  @override
  String get selectDays => 'Select Days';

  @override
  String everyHours(int hours) {
    return 'Every $hours hours';
  }

  @override
  String get preAlert => 'Pre-alert';

  @override
  String preAlertMinutes(int minutes) {
    return '$minutes minutes before';
  }

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get medicationStatus => 'Medication Status';

  @override
  String get statusActive => 'Active';

  @override
  String get statusPaused => 'Paused';

  @override
  String get statusArchived => 'Archived';

  @override
  String get caregiver => 'Caregiver';

  @override
  String get caregivers => 'Caregivers';

  @override
  String get addCaregiver => 'Add Caregiver';

  @override
  String get inviteCaregiver => 'Invite Caregiver';

  @override
  String get caregiverPermissions => 'Caregiver Permissions';

  @override
  String get canAddEditMeds => 'Can add and edit medications';

  @override
  String get canViewLog => 'Can view adherence log';

  @override
  String get notifyIfNoConfirmation => 'Notify me if dose not confirmed';

  @override
  String get pairingInvite => 'Pairing Invite';

  @override
  String get pairCode => 'Pair Code';

  @override
  String get enterPairCode => 'Enter Pair Code';

  @override
  String get sendViaWhatsApp => 'Send via WhatsApp';

  @override
  String inviteExpires(int hours) {
    return 'Invite expires in $hours hours';
  }

  @override
  String get inviteAccepted => 'Invite accepted!';

  @override
  String get consent => 'Consent';

  @override
  String get consentTitle => 'Caregiver Permissions';

  @override
  String get consentDescription =>
      'Choose the permissions you want to grant to your caregiver';

  @override
  String get acceptAndContinue => 'Accept and Continue';

  @override
  String get doctorVisitMode => 'Doctor Visit Mode';

  @override
  String get shareWithDoctor => 'Share with Doctor';

  @override
  String get generateQR => 'Generate QR Code';

  @override
  String get shareScope => 'Share Scope';

  @override
  String get scopeMedsOnly => 'Medications only';

  @override
  String get scopeMedsAndLog => 'Medications and adherence log';

  @override
  String get expiryTime => 'Expiry Time';

  @override
  String minutes(int count) {
    return '$count minutes';
  }

  @override
  String get shareActive => 'Share Active';

  @override
  String get shareExpired => 'Share Expired';

  @override
  String get revokeShare => 'Revoke Share';

  @override
  String get exportPDF => 'Export PDF';

  @override
  String get adherence => 'Adherence';

  @override
  String get adherenceRate => 'Adherence Rate';

  @override
  String get adherenceSummary => 'Adherence Summary';

  @override
  String get last7Days => 'Last 7 days';

  @override
  String get last30Days => 'Last 30 days';

  @override
  String get dosesConfirmed => 'Doses taken';

  @override
  String get dosesSkipped => 'Doses skipped';

  @override
  String get dosesMissed => 'Doses missed';

  @override
  String get subscription => 'Subscription';

  @override
  String get freePlan => 'Free Plan';

  @override
  String get proPlan => 'Pro Plan';

  @override
  String get currentPlan => 'Current Plan';

  @override
  String get upgradeToPro => 'Upgrade to Pro';

  @override
  String get freePlanFeatures =>
      'Up to 2 profiles\n3 medications per profile\nReminders and adherence log\nWeekly summary view';

  @override
  String get proPlanFeatures =>
      'Unlimited profiles\nUnlimited medications\nCaregiver notifications\nQR sharing with doctors\nPDF export\nAdvanced summaries';

  @override
  String get limitReached => 'Limit Reached';

  @override
  String get profileLimitReached =>
      'You\'ve reached the maximum profiles on the free plan';

  @override
  String get medicationLimitReached =>
      'You\'ve reached the maximum medications on the free plan';

  @override
  String get upgradeToAdd => 'Upgrade to add more';

  @override
  String get pin => 'PIN';

  @override
  String get setPin => 'Set PIN';

  @override
  String get enterPin => 'Enter PIN';

  @override
  String get confirmPin => 'Confirm PIN';

  @override
  String get changePin => 'Change PIN';

  @override
  String get pinRequired => 'PIN required to access';

  @override
  String get wrongPin => 'Wrong PIN';

  @override
  String get biometricAuth => 'Biometric Authentication';

  @override
  String get useBiometric => 'Use Fingerprint / Face ID';

  @override
  String get language => 'Language';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get timezone => 'Timezone';

  @override
  String get timezoneHome => 'Home Timezone';

  @override
  String get timezoneCurrent => 'Current Timezone';

  @override
  String get about => 'About';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get version => 'Version';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get done => 'Done';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get saving => 'Saving...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get offline => 'Offline';

  @override
  String get offlineBanner =>
      'You\'re offline. Changes will sync when connected.';

  @override
  String get syncing => 'Syncing...';

  @override
  String get syncComplete => 'Sync complete';

  @override
  String get deleteConfirmTitle => 'Confirm Delete';

  @override
  String get deleteProfileConfirm =>
      'Are you sure you want to delete this profile? All medications and records will be deleted.';

  @override
  String get deleteMedicationConfirm =>
      'Are you sure you want to delete this medication?';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get markAsRead => 'Mark as read';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get adminDashboard => 'Admin Dashboard';

  @override
  String get adminUsers => 'Users';

  @override
  String get adminProfiles => 'Profiles';

  @override
  String get adminMedications => 'Medications';

  @override
  String get adminExports => 'Exports';

  @override
  String get adminAnalytics => 'Analytics';

  @override
  String get adminAudit => 'Audit Log';

  @override
  String get searchUsers => 'Search users...';

  @override
  String get searchProfiles => 'Search profiles...';

  @override
  String get userDetails => 'User Details';

  @override
  String get banUser => 'Ban User';

  @override
  String get unbanUser => 'Unban User';

  @override
  String get exportCSV => 'Export CSV';

  @override
  String get totalUsers => 'Total Users';

  @override
  String get activeUsers => 'Active Users';

  @override
  String get dosesToday => 'Today\'s Doses';

  @override
  String get caregiverLinks => 'Caregiver Links';

  @override
  String get sunday => 'Sunday';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get analyticsOverview => 'Overview';

  @override
  String get analyticsUserStats => 'User Statistics';

  @override
  String get analyticsAdherenceStats => 'Adherence Metrics';

  @override
  String get analyticsFeatureUsage => 'Feature Usage';

  @override
  String get analyticsTrends => 'Trends';

  @override
  String get proUsers => 'Pro Users';

  @override
  String get freeUsers => 'Free Users';

  @override
  String get activeUsersLast7Days => 'Active (7d)';

  @override
  String get activeUsersLast30Days => 'Active (30d)';

  @override
  String get linkedProfiles => 'Linked Profiles';

  @override
  String get managedProfiles => 'Managed Profiles';

  @override
  String get activeMedications => 'Active Medications';

  @override
  String get takenToday => 'Taken Today';

  @override
  String get missedToday => 'Missed Today';

  @override
  String get takenThisWeek => 'Taken This Week';

  @override
  String get missedThisWeek => 'Missed This Week';

  @override
  String get takenThisMonth => 'Taken This Month';

  @override
  String get missedThisMonth => 'Missed This Month';

  @override
  String get qrShareSessions => 'QR Share Sessions';

  @override
  String get pdfExports => 'PDF Exports';

  @override
  String get caregiverLinkRate => 'Caregiver Link Rate';

  @override
  String get signupTrend => 'Signup Trend';

  @override
  String get adherenceTrend => 'Adherence Trend';

  @override
  String get last7DaysChart => 'Last 7 Days';

  @override
  String get last30DaysChart => 'Last 30 Days';

  @override
  String get last90DaysChart => 'Last 90 Days';

  @override
  String get timeRange7d => '7 days';

  @override
  String get timeRange30d => '30 days';

  @override
  String get timeRange90d => '90 days';

  @override
  String get refresh => 'Refresh';

  @override
  String get refreshing => 'Refreshing...';

  @override
  String lastUpdated(String time) {
    return 'Last updated: $time';
  }

  @override
  String get auditLogs => 'Audit Logs';

  @override
  String get filterByActor => 'Filter by actor email';

  @override
  String get filterByAction => 'Filter by action';

  @override
  String get filterByDate => 'Filter by date';

  @override
  String get allActions => 'All actions';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get activeFilters => 'Active filters';

  @override
  String get actionPairInviteCreated => 'Pair Invite Created';

  @override
  String get actionPairInviteAccepted => 'Pair Invite Accepted';

  @override
  String get actionShareSessionCreated => 'Share Session Created';

  @override
  String get actionShareSessionRevoked => 'Share Session Revoked';

  @override
  String get actionShareSessionViewed => 'Share Session Viewed';

  @override
  String get actionPdfGenerated => 'PDF Generated';

  @override
  String get actionEscalationSent => 'Escalation Sent';

  @override
  String get actionAdminExport => 'Admin Export';

  @override
  String get actionAdminBanUser => 'User Banned';

  @override
  String get actionAdminUnbanUser => 'User Unbanned';

  @override
  String get actionProfileCreated => 'Profile Created';

  @override
  String get actionProfileUpdated => 'Profile Updated';

  @override
  String get actionProfileDeleted => 'Profile Deleted';

  @override
  String get actionMedicationCreated => 'Medication Created';

  @override
  String get actionMedicationUpdated => 'Medication Updated';

  @override
  String get actionMedicationDeleted => 'Medication Deleted';

  @override
  String get actionCaregiverAdded => 'Caregiver Added';

  @override
  String get actionCaregiverRemoved => 'Caregiver Removed';

  @override
  String get actionViewAnalytics => 'View Analytics';

  @override
  String get auditLogDetails => 'Log Details';

  @override
  String get actor => 'Actor';

  @override
  String get targetProfile => 'Target Profile';

  @override
  String get timestamp => 'Timestamp';

  @override
  String get metadata => 'Metadata';

  @override
  String get noLogsFound => 'No audit logs found';

  @override
  String pageOf(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get previousPage => 'Previous';

  @override
  String get nextPage => 'Next';

  @override
  String perPage(int count) {
    return '$count per page';
  }

  @override
  String get clearPhoto => 'Clear';

  @override
  String get replacePhoto => 'Replace';

  @override
  String get confirmDeleteMedication => 'Delete Medication';

  @override
  String get deleteWarning => 'This action cannot be undone.';

  @override
  String get dateFrom => 'From';

  @override
  String get dateTo => 'To';

  @override
  String get selectDateRange => 'Select date range';

  @override
  String get applyFilter => 'Apply';

  @override
  String get noPreAlert => 'No pre-alert';

  @override
  String get removeTime => 'Remove time';

  @override
  String get searchMedications => 'Search medications...';

  @override
  String get filterByProfile => 'Filter by profile';

  @override
  String get filterByStatus => 'Filter by status';

  @override
  String get allProfiles => 'All profiles';

  @override
  String get allStatuses => 'All statuses';

  @override
  String get userCreatedAt => 'Account created';

  @override
  String get profilesOwned => 'Profiles owned';

  @override
  String get banned => 'Banned';

  @override
  String get active => 'Active';

  @override
  String get errorEmailRequired => 'Email is required';

  @override
  String get errorEmailInvalid => 'Invalid email address';

  @override
  String get errorPasswordRequired => 'Password is required';

  @override
  String get errorPasswordTooShort => 'Password is too short';

  @override
  String get errorConfirmPasswordRequired => 'Please confirm password';

  @override
  String get errorPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get errorPinRequired => 'PIN is required';

  @override
  String get errorPinInvalidLength => 'PIN must be 4 digits';

  @override
  String get errorPinDigitsOnly => 'PIN must contain only digits';

  @override
  String get errorPhoneRequired => 'Phone number is required';

  @override
  String get errorPhoneInvalid => 'Invalid phone number';

  @override
  String get errorRequired => 'This field is required';

  @override
  String errorFieldRequired(String field) {
    return '$field is required';
  }

  @override
  String get errorMedNameRequired => 'Medication name is required';

  @override
  String get errorMedNameTooShort => 'Medication name is too short';

  @override
  String get errorMedNameTooLong => 'Medication name is too long';

  @override
  String get errorPairCodeRequired => 'Pair code is required';

  @override
  String get errorPairCodeInvalid => 'Invalid pair code';

  @override
  String get errorEveryXHoursRequired => 'Hours interval is required';

  @override
  String get errorEveryXHoursInvalid => 'Invalid hours interval';

  @override
  String get errorProfileNameRequired => 'Profile name is required';

  @override
  String get errorProfileNameTooShort => 'Profile name is too short';

  @override
  String get errorProfileNameTooLong => 'Profile name is too long';

  @override
  String get errorScheduleTimesRequired => 'Schedule times are required';

  @override
  String get errorScheduleTimesDuplicate => 'Duplicate times found';

  @override
  String get errorScheduleTimesTooMany => 'Too many schedule times';

  @override
  String get errorShareExpiryRequired => 'Expiry date is required';

  @override
  String get errorShareExpiryInvalid => 'Invalid expiry date';

  @override
  String get errorTimeRequired => 'Time is required';

  @override
  String get errorTimeInvalid => 'Invalid time';

  @override
  String get errorTimezoneRequired => 'Timezone is required';

  @override
  String get errorTimezoneInvalid => 'Invalid timezone';

  @override
  String get todaysSchedule => 'Today\'s Schedule';

  @override
  String get noMedicationsYet => 'No medications yet';

  @override
  String get addFirstMedication => 'Add your first medication';

  @override
  String get pendingSync => 'Pending sync';

  @override
  String get syncStateProvider => 'حالة المزامنة';

  @override
  String get pleaseSelectProfile => 'Please select a profile';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get medicationAdded => 'Medication added';

  @override
  String get errorAddingMedication => 'Error adding medication';

  @override
  String get basicInfo => 'Basic Info';

  @override
  String get photos => 'Photos';

  @override
  String get medicationDetails => 'Medication Details';

  @override
  String get medicationNameHint => 'Enter medication name';

  @override
  String get medicationNameRequired => 'Medication name is required';

  @override
  String get medicationNameTooShort => 'Medication name is too short';

  @override
  String get medicationNameTooLong => 'Medication name is too long';

  @override
  String get addPhotos => 'Add Photos';

  @override
  String get photosHelp => 'Add photos to identify your medication';

  @override
  String get visualTagsHelp => 'Add visual tags for your medication';

  @override
  String get noProfileSelected => 'No profile selected';

  @override
  String get noProfiles => 'No profiles';

  @override
  String get noProfilesDescription => 'Create a profile to get started';

  @override
  String get createProfile => 'Create Profile';

  @override
  String get profileCreated => 'Profile created';

  @override
  String get profileNameHint => 'Enter profile name';

  @override
  String get profileType => 'Profile Type';

  @override
  String get profileSettings => 'Profile Settings';

  @override
  String get managedProfile => 'Managed Profile';

  @override
  String get managedProfileDescription => 'A profile for someone you care for';

  @override
  String get linkedProfile => 'Linked Profile';

  @override
  String get linkedProfileDescription => 'A profile for someone caring for you';

  @override
  String get linkedProfileDisclaimer =>
      'This person will be able to see your medications';

  @override
  String get linkWithCaregiver => 'Link with Caregiver';

  @override
  String get linkingWithCaregiver => 'Linking...';

  @override
  String get linkedSuccessfully => 'Linked successfully';

  @override
  String get linkedSuccessfullyDescription => 'Profile linked successfully';

  @override
  String get acceptAndLink => 'Accept and Link';

  @override
  String get permissions => 'Permissions';

  @override
  String get choosePermissions => 'Choose Permissions';

  @override
  String get canChangePermissionsLater => 'You can change permissions later';

  @override
  String get medicationsOnly => 'Medications Only';

  @override
  String get medicationsOnlyDescription => 'View medications only';

  @override
  String get medicationsAndLog => 'Medications and Log';

  @override
  String get medicationsAndLogDescription =>
      'View medications and adherence log';

  @override
  String get manageMediactions => 'Manage Medications';

  @override
  String get manageMedicationsDescription => 'Add and edit medications';

  @override
  String get receiveAlerts => 'Receive Alerts';

  @override
  String get receiveAlertsDescription => 'Receive alerts when doses are missed';

  @override
  String get viewAdherenceLog => 'View Adherence Log';

  @override
  String get viewAdherenceLogDescription => 'View medication history';

  @override
  String get shareQr => 'Share QR';

  @override
  String get shareQrDescription => 'Share QR code for linking';

  @override
  String get generateQrCode => 'Generate QR Code';

  @override
  String get qrShareDisclaimer => 'Share this code with your caregiver';

  @override
  String get qrStep1 => 'Open the app on caregiver device';

  @override
  String get qrStep2 => 'Tap Add Linked Profile';

  @override
  String get qrStep3 => 'Scan the QR code';

  @override
  String get qrStep4 => 'Accept the link request';

  @override
  String get howItWorks => 'How it works';

  @override
  String get copyLink => 'Copy Link';

  @override
  String get linkCopied => 'Link copied';

  @override
  String get shareOptions => 'Share Options';

  @override
  String get expiresIn => 'Expires in';

  @override
  String get inviteCreated => 'Invite created';

  @override
  String get inviteExpiresIn72Hours => 'Invite expires in 72 hours';

  @override
  String get inviteInstructions => 'Send this link to your caregiver';

  @override
  String get sendInvite => 'Send Invite';

  @override
  String get revoke => 'Revoke';

  @override
  String get shareSessionRevoked => 'Share session revoked';

  @override
  String get sharing => 'Sharing';

  @override
  String get whatToShare => 'What to share';

  @override
  String get shareWithDoctorDescription => 'Share your info with your doctor';

  @override
  String get doctorVisitDescription => 'Information for doctor visit';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get generatingPdf => 'Generating PDF...';

  @override
  String get pdfGenerated => 'PDF generated';

  @override
  String get download => 'Download';

  @override
  String get enterPairCodeDescription => 'Enter the pair code';

  @override
  String get whereToFindCode => 'Where to find the code?';

  @override
  String get whereToFindCodeDescription =>
      'Ask the person you want to link with';

  @override
  String get caregiverConsentDisclaimer =>
      'By accepting, you will be able to see this person\'s medications';

  @override
  String get verify => 'Verify';

  @override
  String get processing => 'Processing...';

  @override
  String get all => 'All';

  @override
  String get daily => 'Daily';

  @override
  String get specificDays => 'Specific Days';

  @override
  String get interval => 'Interval';

  @override
  String get repeatEvery => 'Repeat every';

  @override
  String get hour => 'hour';

  @override
  String get hours => 'hours';

  @override
  String get times => 'times';

  @override
  String get atLeastOneTime => 'At least one time';

  @override
  String get before => 'Before';

  @override
  String get dateRange => 'Date Range';

  @override
  String get filters => 'Filters';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get filtersApplied => 'Filters applied';

  @override
  String get clear => 'Clear';

  @override
  String get clearAll => 'Clear All';

  @override
  String get eventType => 'Event Type';

  @override
  String get skipped => 'Skipped';

  @override
  String get snoozed => 'Snoozed';

  @override
  String get snoozedFor => 'Snoozed for';

  @override
  String get snoozeFor => 'Snooze for';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get other => 'Other';

  @override
  String get noEventsFound => 'No events found';

  @override
  String get adherenceLog => 'Adherence Log';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get errorLoadingMedications => 'Error loading medications';

  @override
  String get errorLoadingProfiles => 'Error loading profiles';

  @override
  String get noActiveMedications => 'No active medications';

  @override
  String get noArchivedMedications => 'No archived medications';

  @override
  String get noPausedMedications => 'No paused medications';

  @override
  String get noDosesScheduled => 'No doses scheduled';

  @override
  String get allDoneForToday => 'All done for today';

  @override
  String get doseTakenSuccess => 'Dose recorded';

  @override
  String get doseSkipped => 'Dose skipped';

  @override
  String get pause => 'Pause';

  @override
  String get paused => 'Paused';

  @override
  String get resume => 'Resume';

  @override
  String get archived => 'Archived';

  @override
  String get deleteMedication => 'Delete Medication';

  @override
  String get medication => 'Medication';

  @override
  String get traveling => 'Traveling';

  @override
  String get notAvailable => 'Not available';

  @override
  String get account => 'Account';

  @override
  String get appSettings => 'App Settings';

  @override
  String get pinSecurity => 'PIN Security';

  @override
  String get setUpPin => 'Set up PIN';

  @override
  String get createPin => 'Create PIN';

  @override
  String get createPinSubtitle => 'Create a 4-digit PIN';

  @override
  String get confirmPinSubtitle => 'Re-enter your PIN';

  @override
  String get enterPinSubtitle => 'Enter your PIN';

  @override
  String get removePin => 'Remove PIN';

  @override
  String get pinRemoved => 'PIN removed';

  @override
  String get pinsDoNotMatch => 'PINs do not match';

  @override
  String get incorrectPin => 'Incorrect PIN';

  @override
  String get errorSavingPin => 'Error saving PIN';

  @override
  String get biometricUnlock => 'Biometric Unlock';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get faq => 'FAQ';

  @override
  String get faq1Question => 'How do I add a medication?';

  @override
  String get faq1Answer => 'Tap the + button on the home screen';

  @override
  String get faq2Question => 'How do I link with a caregiver?';

  @override
  String get faq2Answer => 'Go to Profiles and select Share QR';

  @override
  String get faq3Question => 'How do I export a report?';

  @override
  String get faq3Answer => 'Go to Doctor Visit and select Export PDF';

  @override
  String get logoutConfirm => 'Do you want to log out?';

  @override
  String get forgot => 'Forgot?';

  @override
  String get goToApp => 'Go to App';

  @override
  String get profile => 'Profile';

  @override
  String get feature => 'Feature';

  @override
  String get free => 'Free';

  @override
  String get unlimited => 'Unlimited';

  @override
  String get recommended => 'Recommended';

  @override
  String get proPrice => '\$9.99/year';

  @override
  String get youAreOnFree => 'You are on the Free plan';

  @override
  String get youAreOnPro => 'You are on the Pro plan';

  @override
  String get upgradeRequired => 'Upgrade Required';

  @override
  String get upgradeToAddMoreProfiles => 'Upgrade to add more profiles';

  @override
  String get upgradeConfirmation => 'Do you want to upgrade?';

  @override
  String get upgradeSuccess => 'Upgrade successful';

  @override
  String get paymentNote => 'Payment via app store';

  @override
  String get freeFeature1 => '1 Profile';

  @override
  String get freeFeature1Unlimited => 'Unlimited Profiles';

  @override
  String get freeFeature2 => '5 Medications';

  @override
  String get freeFeature2Unlimited => 'Unlimited Medications';

  @override
  String get freeFeature3 => 'Basic Reminders';

  @override
  String get freeFeature4 => '7-day Log';

  @override
  String get proFeature1 => 'Unlimited Profiles';

  @override
  String get proFeature2 => 'Unlimited Medications';

  @override
  String get proFeature3 => 'PDF Export';

  @override
  String get proFeature4 => 'Full Log';

  @override
  String get featureComparison => 'Feature Comparison';

  @override
  String get featureMedications => 'Medications';

  @override
  String get featureProfiles => 'Profiles';

  @override
  String get featureReminders => 'Reminders';

  @override
  String get featureAdherenceLog => 'Adherence Log';

  @override
  String get featurePdfExport => 'PDF Export';

  @override
  String get featureQrShare => 'QR Share';

  @override
  String get featureAdvancedSummaries => 'Advanced Summaries';

  @override
  String get featureCaregiverEscalation => 'Caregiver Escalation';

  @override
  String get noNotificationsDescription => 'No notifications';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get allNotificationsMarkedRead => 'All notifications marked read';

  @override
  String get patientPhone => 'Patient Phone';

  @override
  String get patientPhoneHelper => 'Enter phone number';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get invalidPhoneFormat => 'Invalid phone format';

  @override
  String get nameTooShort => 'Name is too short';

  @override
  String get paste => 'Paste';
}
