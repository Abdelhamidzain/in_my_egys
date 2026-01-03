// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'في عيوني';

  @override
  String get disclaimer =>
      'هذا التطبيق للتذكير والمتابعة فقط ولا يقدم نصائح طبية. اتبع تعليمات طبيبك دائمًا.';

  @override
  String get welcome => 'مرحباً بك';

  @override
  String get welcomeSubtitle => 'تطبيق في عيوني للعائلة';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get confirmEmail => 'تأكيد البريد الإلكتروني';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get phone => 'رقم الجوال';

  @override
  String get name => 'الاسم';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get emailInvalid => 'البريد الإلكتروني غير صحيح';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordTooShort => 'كلمة المرور قصيرة جداً (8 أحرف على الأقل)';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get today => 'اليوم';

  @override
  String get medications => 'الأدوية';

  @override
  String get log => 'السجل';

  @override
  String get settings => 'الإعدادات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get nextDose => 'الجرعة القادمة';

  @override
  String dueAt(String time) {
    return 'موعدها الساعة $time';
  }

  @override
  String dueIn(String duration) {
    return 'بعد $duration';
  }

  @override
  String get overdue => 'متأخر';

  @override
  String get taken => 'تم تناولها';

  @override
  String get snooze => 'تأجيل';

  @override
  String get skip => 'تخطي';

  @override
  String get snoozeOptions => 'خيارات التأجيل';

  @override
  String snoozeMinutes(int minutes) {
    return '$minutes دقائق';
  }

  @override
  String get skipReason => 'سبب التخطي';

  @override
  String get skipReasonForgot => 'نسيت';

  @override
  String get skipReasonNotAvailable => 'الدواء غير متوفر';

  @override
  String get skipReasonTravel => 'في سفر';

  @override
  String get skipReasonOther => 'سبب آخر';

  @override
  String get todaySchedule => 'جدول اليوم';

  @override
  String get noMedicationsToday => 'لا توجد أدوية مجدولة لليوم';

  @override
  String get allDosesCompleted => 'تم تناول جميع الجرعات!';

  @override
  String get profiles => 'الملفات الشخصية';

  @override
  String get addProfile => 'إضافة ملف';

  @override
  String get editProfile => 'تعديل الملف';

  @override
  String get deleteProfile => 'حذف الملف';

  @override
  String get switchProfile => 'تغيير الملف';

  @override
  String get profileName => 'اسم الملف';

  @override
  String get relationship => 'صلة القرابة';

  @override
  String get relationshipSelf => 'أنا';

  @override
  String get relationshipMother => 'أمي';

  @override
  String get relationshipFather => 'أبي';

  @override
  String get relationshipSpouse => 'زوجي/زوجتي';

  @override
  String get relationshipChild => 'ابني/ابنتي';

  @override
  String get relationshipGrandparent => 'جدي/جدتي';

  @override
  String get relationshipOther => 'آخر';

  @override
  String get profileTypeSelf => 'ملفي الشخصي';

  @override
  String get profileTypeManaged => 'ملف أديره';

  @override
  String get profileTypeLinked => 'ملف مرتبط';

  @override
  String get seniorMode => 'وضع كبار السن';

  @override
  String get seniorModeDescription => 'أزرار أكبر وواجهة أبسط';

  @override
  String get highContrast => 'تباين عالي';

  @override
  String get addMedication => 'إضافة دواء';

  @override
  String get editMedication => 'تعديل الدواء';

  @override
  String get medicationName => 'اسم الدواء';

  @override
  String get instructions => 'التعليمات';

  @override
  String get instructionsHint => 'مثال: قرص واحد بعد الأكل';

  @override
  String get medicationPhotos => 'صور الدواء';

  @override
  String get pillPhoto => 'صورة الحبة';

  @override
  String get boxPhoto => 'صورة العلبة';

  @override
  String get addPhoto => 'إضافة صورة';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get chooseFromGallery => 'اختيار من المعرض';

  @override
  String get visualTags => 'علامات مميزة';

  @override
  String get visualTagWhite => 'أبيض';

  @override
  String get visualTagPink => 'وردي';

  @override
  String get visualTagBlue => 'أزرق';

  @override
  String get visualTagYellow => 'أصفر';

  @override
  String get visualTagGreen => 'أخضر';

  @override
  String get visualTagRound => 'دائري';

  @override
  String get visualTagOval => 'بيضاوي';

  @override
  String get visualTagCapsule => 'كبسولة';

  @override
  String get visualTagSmall => 'صغير';

  @override
  String get visualTagLarge => 'كبير';

  @override
  String get schedule => 'الجدول';

  @override
  String get scheduleType => 'نوع الجدول';

  @override
  String get dailyFixedTimes => 'يومياً في أوقات محددة';

  @override
  String get daysOfWeek => 'أيام محددة من الأسبوع';

  @override
  String get everyXHours => 'كل عدة ساعات';

  @override
  String get selectTimes => 'اختر الأوقات';

  @override
  String get addTime => 'إضافة وقت';

  @override
  String get selectDays => 'اختر الأيام';

  @override
  String everyHours(int hours) {
    return 'كل $hours ساعات';
  }

  @override
  String get preAlert => 'تنبيه مسبق';

  @override
  String preAlertMinutes(int minutes) {
    return 'قبل $minutes دقيقة';
  }

  @override
  String get startDate => 'تاريخ البداية';

  @override
  String get endDate => 'تاريخ النهاية';

  @override
  String get ongoing => 'مستمر';

  @override
  String get medicationStatus => 'حالة الدواء';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusPaused => 'متوقف';

  @override
  String get statusArchived => 'مؤرشف';

  @override
  String get caregiver => 'مقدم الرعاية';

  @override
  String get caregivers => 'مقدمو الرعاية';

  @override
  String get addCaregiver => 'إضافة مقدم رعاية';

  @override
  String get inviteCaregiver => 'دعوة مقدم رعاية';

  @override
  String get caregiverPermissions => 'صلاحيات مقدم الرعاية';

  @override
  String get canAddEditMeds => 'يمكنه إضافة وتعديل الأدوية';

  @override
  String get canViewLog => 'يمكنه عرض سجل الالتزام';

  @override
  String get notifyIfNoConfirmation => 'إشعاري عند عدم تأكيد الجرعة';

  @override
  String get pairingInvite => 'دعوة ربط';

  @override
  String get pairCode => 'رمز الربط';

  @override
  String get enterPairCode => 'أدخل رمز الربط';

  @override
  String get sendViaWhatsApp => 'إرسال عبر واتساب';

  @override
  String inviteExpires(int hours) {
    return 'تنتهي الدعوة خلال $hours ساعة';
  }

  @override
  String get inviteAccepted => 'تم قبول الدعوة!';

  @override
  String get consent => 'الموافقة';

  @override
  String get consentTitle => 'صلاحيات مقدم الرعاية';

  @override
  String get consentDescription =>
      'اختر الصلاحيات التي تريد منحها لمقدم الرعاية';

  @override
  String get acceptAndContinue => 'موافقة ومتابعة';

  @override
  String get doctorVisitMode => 'وضع زيارة الطبيب';

  @override
  String get shareWithDoctor => 'مشاركة مع الطبيب';

  @override
  String get generateQR => 'إنشاء رمز QR';

  @override
  String get shareScope => 'نطاق المشاركة';

  @override
  String get scopeMedsOnly => 'الأدوية فقط';

  @override
  String get scopeMedsAndLog => 'الأدوية وسجل الالتزام';

  @override
  String get expiryTime => 'مدة الصلاحية';

  @override
  String minutes(int count) {
    return '$count دقيقة';
  }

  @override
  String get shareActive => 'المشاركة نشطة';

  @override
  String get shareExpired => 'انتهت المشاركة';

  @override
  String get revokeShare => 'إلغاء المشاركة';

  @override
  String get exportPDF => 'تصدير PDF';

  @override
  String get adherence => 'الالتزام';

  @override
  String get adherenceRate => 'نسبة الالتزام';

  @override
  String get adherenceSummary => 'ملخص الالتزام';

  @override
  String get last7Days => 'آخر 7 أيام';

  @override
  String get last30Days => 'آخر 30 يوم';

  @override
  String get dosesConfirmed => 'جرعات تم تناولها';

  @override
  String get dosesSkipped => 'جرعات تم تخطيها';

  @override
  String get dosesMissed => 'جرعات فائتة';

  @override
  String get subscription => 'الاشتراك';

  @override
  String get freePlan => 'الخطة المجانية';

  @override
  String get proPlan => 'الخطة المميزة';

  @override
  String get currentPlan => 'خطتك الحالية';

  @override
  String get upgradeToPro => 'ترقية للمميزة';

  @override
  String get freePlanFeatures =>
      'حتى ملفين\n3 أدوية لكل ملف\nتذكيرات وسجل الالتزام\nعرض ملخص أسبوعي';

  @override
  String get proPlanFeatures =>
      'ملفات غير محدودة\nأدوية غير محدودة\nإشعارات لمقدمي الرعاية\nمشاركة QR مع الطبيب\nتصدير PDF\nملخصات متقدمة';

  @override
  String get limitReached => 'وصلت للحد الأقصى';

  @override
  String get profileLimitReached =>
      'وصلت للحد الأقصى من الملفات في الخطة المجانية';

  @override
  String get medicationLimitReached =>
      'وصلت للحد الأقصى من الأدوية في الخطة المجانية';

  @override
  String get upgradeToAdd => 'قم بالترقية لإضافة المزيد';

  @override
  String get pin => 'رمز PIN';

  @override
  String get setPin => 'تعيين رمز PIN';

  @override
  String get enterPin => 'أدخل رمز PIN';

  @override
  String get confirmPin => 'تأكيد رمز PIN';

  @override
  String get changePin => 'تغيير رمز PIN';

  @override
  String get pinRequired => 'رمز PIN مطلوب للدخول';

  @override
  String get wrongPin => 'رمز PIN غير صحيح';

  @override
  String get biometricAuth => 'المصادقة البيومترية';

  @override
  String get useBiometric => 'استخدام البصمة / Face ID';

  @override
  String get language => 'اللغة';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get timezone => 'المنطقة الزمنية';

  @override
  String get timezoneHome => 'المنطقة الزمنية الأساسية';

  @override
  String get timezoneCurrent => 'المنطقة الزمنية الحالية';

  @override
  String get about => 'عن التطبيق';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsOfService => 'شروط الاستخدام';

  @override
  String get contactSupport => 'تواصل معنا';

  @override
  String get version => 'الإصدار';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get done => 'تم';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get confirm => 'تأكيد';

  @override
  String get close => 'إغلاق';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get saving => 'جاري الحفظ...';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'تم بنجاح';

  @override
  String get offline => 'غير متصل';

  @override
  String get offlineBanner => 'أنت غير متصل. التغييرات ستُحفظ عند الاتصال.';

  @override
  String get syncing => 'جاري المزامنة...';

  @override
  String get syncComplete => 'تمت المزامنة';

  @override
  String get deleteConfirmTitle => 'تأكيد الحذف';

  @override
  String get deleteProfileConfirm =>
      'هل أنت متأكد من حذف هذا الملف؟ سيتم حذف جميع الأدوية والسجلات المرتبطة به.';

  @override
  String get deleteMedicationConfirm => 'هل أنت متأكد من حذف هذا الدواء؟';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get markAsRead => 'تحديد كمقروء';

  @override
  String get markAllAsRead => 'تحديد الكل كمقروء';

  @override
  String get adminDashboard => 'لوحة التحكم';

  @override
  String get adminUsers => 'المستخدمون';

  @override
  String get adminProfiles => 'الملفات';

  @override
  String get adminMedications => 'الأدوية';

  @override
  String get adminExports => 'التصدير';

  @override
  String get adminAnalytics => 'الإحصائيات';

  @override
  String get adminAudit => 'سجل العمليات';

  @override
  String get searchUsers => 'بحث عن مستخدم...';

  @override
  String get searchProfiles => 'بحث عن ملف...';

  @override
  String get userDetails => 'تفاصيل المستخدم';

  @override
  String get banUser => 'حظر المستخدم';

  @override
  String get unbanUser => 'إلغاء حظر المستخدم';

  @override
  String get exportCSV => 'تصدير CSV';

  @override
  String get totalUsers => 'إجمالي المستخدمين';

  @override
  String get activeUsers => 'مستخدمون نشطون';

  @override
  String get dosesToday => 'جرعات اليوم';

  @override
  String get caregiverLinks => 'روابط مقدمي الرعاية';

  @override
  String get sunday => 'الأحد';

  @override
  String get monday => 'الاثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get saturday => 'السبت';

  @override
  String get analyticsOverview => 'نظرة عامة';

  @override
  String get analyticsUserStats => 'إحصائيات المستخدمين';

  @override
  String get analyticsAdherenceStats => 'إحصائيات الالتزام';

  @override
  String get analyticsFeatureUsage => 'استخدام الميزات';

  @override
  String get analyticsTrends => 'الاتجاهات';

  @override
  String get proUsers => 'مستخدمو Pro';

  @override
  String get freeUsers => 'مستخدمو المجاني';

  @override
  String get activeUsersLast7Days => 'نشطون (7 أيام)';

  @override
  String get activeUsersLast30Days => 'نشطون (30 يوم)';

  @override
  String get linkedProfiles => 'ملفات مرتبطة';

  @override
  String get managedProfiles => 'ملفات مُدارة';

  @override
  String get activeMedications => 'أدوية نشطة';

  @override
  String get takenToday => 'تم تناولها اليوم';

  @override
  String get missedToday => 'فائتة اليوم';

  @override
  String get takenThisWeek => 'تم تناولها هذا الأسبوع';

  @override
  String get missedThisWeek => 'فائتة هذا الأسبوع';

  @override
  String get takenThisMonth => 'تم تناولها هذا الشهر';

  @override
  String get missedThisMonth => 'فائتة هذا الشهر';

  @override
  String get qrShareSessions => 'جلسات مشاركة QR';

  @override
  String get pdfExports => 'تصديرات PDF';

  @override
  String get caregiverLinkRate => 'نسبة ربط مقدمي الرعاية';

  @override
  String get signupTrend => 'اتجاه التسجيل';

  @override
  String get adherenceTrend => 'اتجاه الالتزام';

  @override
  String get last7DaysChart => 'آخر 7 أيام';

  @override
  String get last30DaysChart => 'آخر 30 يوم';

  @override
  String get last90DaysChart => 'آخر 90 يوم';

  @override
  String get timeRange7d => '7 أيام';

  @override
  String get timeRange30d => '30 يوم';

  @override
  String get timeRange90d => '90 يوم';

  @override
  String get refresh => 'تحديث';

  @override
  String get refreshing => 'جاري التحديث...';

  @override
  String lastUpdated(String time) {
    return 'آخر تحديث: $time';
  }

  @override
  String get auditLogs => 'سجل العمليات';

  @override
  String get filterByActor => 'تصفية حسب البريد الإلكتروني';

  @override
  String get filterByAction => 'تصفية حسب الإجراء';

  @override
  String get filterByDate => 'تصفية حسب التاريخ';

  @override
  String get allActions => 'جميع الإجراءات';

  @override
  String get clearFilters => 'مسح الفلاتر';

  @override
  String get activeFilters => 'فلاتر نشطة';

  @override
  String get actionPairInviteCreated => 'إنشاء دعوة ربط';

  @override
  String get actionPairInviteAccepted => 'قبول دعوة ربط';

  @override
  String get actionShareSessionCreated => 'إنشاء جلسة مشاركة';

  @override
  String get actionShareSessionRevoked => 'إلغاء جلسة مشاركة';

  @override
  String get actionShareSessionViewed => 'عرض جلسة مشاركة';

  @override
  String get actionPdfGenerated => 'إنشاء PDF';

  @override
  String get actionEscalationSent => 'إرسال تصعيد';

  @override
  String get actionAdminExport => 'تصدير إداري';

  @override
  String get actionAdminBanUser => 'حظر مستخدم';

  @override
  String get actionAdminUnbanUser => 'إلغاء حظر مستخدم';

  @override
  String get actionProfileCreated => 'إنشاء ملف';

  @override
  String get actionProfileUpdated => 'تعديل ملف';

  @override
  String get actionProfileDeleted => 'حذف ملف';

  @override
  String get actionMedicationCreated => 'إضافة دواء';

  @override
  String get actionMedicationUpdated => 'تعديل دواء';

  @override
  String get actionMedicationDeleted => 'حذف دواء';

  @override
  String get actionCaregiverAdded => 'إضافة مقدم رعاية';

  @override
  String get actionCaregiverRemoved => 'إزالة مقدم رعاية';

  @override
  String get actionViewAnalytics => 'عرض الإحصائيات';

  @override
  String get auditLogDetails => 'تفاصيل السجل';

  @override
  String get actor => 'المنفذ';

  @override
  String get targetProfile => 'الملف المستهدف';

  @override
  String get timestamp => 'الوقت';

  @override
  String get metadata => 'البيانات التفصيلية';

  @override
  String get noLogsFound => 'لم يتم العثور على سجلات';

  @override
  String pageOf(int current, int total) {
    return 'صفحة $current من $total';
  }

  @override
  String get previousPage => 'السابق';

  @override
  String get nextPage => 'التالي';

  @override
  String perPage(int count) {
    return '$count لكل صفحة';
  }

  @override
  String get clearPhoto => 'مسح';

  @override
  String get replacePhoto => 'استبدال';

  @override
  String get confirmDeleteMedication => 'حذف الدواء';

  @override
  String get deleteWarning => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get dateFrom => 'من';

  @override
  String get dateTo => 'إلى';

  @override
  String get selectDateRange => 'اختر نطاق التاريخ';

  @override
  String get applyFilter => 'تطبيق';

  @override
  String get noPreAlert => 'بدون تنبيه مسبق';

  @override
  String get removeTime => 'إزالة الوقت';

  @override
  String get searchMedications => 'بحث عن دواء...';

  @override
  String get filterByProfile => 'تصفية حسب الملف';

  @override
  String get filterByStatus => 'تصفية حسب الحالة';

  @override
  String get allProfiles => 'جميع الملفات';

  @override
  String get allStatuses => 'جميع الحالات';

  @override
  String get userCreatedAt => 'تاريخ إنشاء الحساب';

  @override
  String get profilesOwned => 'الملفات المملوكة';

  @override
  String get banned => 'محظور';

  @override
  String get active => 'نشط';

  @override
  String get errorEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get errorEmailInvalid => 'البريد الإلكتروني غير صالح';

  @override
  String get errorPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get errorPasswordTooShort => 'كلمة المرور قصيرة جداً';

  @override
  String get errorConfirmPasswordRequired => 'تأكيد كلمة المرور مطلوب';

  @override
  String get errorPasswordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get errorPinRequired => 'الرمز السري مطلوب';

  @override
  String get errorPinInvalidLength => 'الرمز السري يجب أن يكون 4 أرقام';

  @override
  String get errorPinDigitsOnly => 'الرمز السري يجب أن يحتوي على أرقام فقط';

  @override
  String get errorPhoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get errorPhoneInvalid => 'رقم الهاتف غير صالح';

  @override
  String get errorRequired => 'هذا الحقل مطلوب';

  @override
  String errorFieldRequired(String field) {
    return '$field مطلوب';
  }

  @override
  String get errorMedNameRequired => 'اسم الدواء مطلوب';

  @override
  String get errorMedNameTooShort => 'اسم الدواء قصير جداً';

  @override
  String get errorMedNameTooLong => 'اسم الدواء طويل جداً';

  @override
  String get errorPairCodeRequired => 'رمز الاقتران مطلوب';

  @override
  String get errorPairCodeInvalid => 'رمز الاقتران غير صالح';

  @override
  String get errorEveryXHoursRequired => 'عدد الساعات مطلوب';

  @override
  String get errorEveryXHoursInvalid => 'عدد الساعات غير صالح';

  @override
  String get errorProfileNameRequired => 'اسم الملف مطلوب';

  @override
  String get errorProfileNameTooShort => 'اسم الملف قصير جداً';

  @override
  String get errorProfileNameTooLong => 'اسم الملف طويل جداً';

  @override
  String get errorScheduleTimesRequired => 'أوقات الجدول مطلوبة';

  @override
  String get errorScheduleTimesDuplicate => 'توجد أوقات مكررة';

  @override
  String get errorScheduleTimesTooMany => 'عدد الأوقات كبير جداً';

  @override
  String get errorShareExpiryRequired => 'تاريخ الانتهاء مطلوب';

  @override
  String get errorShareExpiryInvalid => 'تاريخ الانتهاء غير صالح';

  @override
  String get errorTimeRequired => 'الوقت مطلوب';

  @override
  String get errorTimeInvalid => 'الوقت غير صالح';

  @override
  String get errorTimezoneRequired => 'المنطقة الزمنية مطلوبة';

  @override
  String get errorTimezoneInvalid => 'المنطقة الزمنية غير صالحة';

  @override
  String get todaysSchedule => 'جدول اليوم';

  @override
  String get noMedicationsYet => 'لا توجد أدوية بعد';

  @override
  String get addFirstMedication => 'أضف أول دواء';

  @override
  String get pendingSync => 'في انتظار المزامنة';

  @override
  String get syncStateProvider => 'حالة المزامنة';

  @override
  String get pleaseSelectProfile => 'الرجاء اختيار ملف شخصي';

  @override
  String get upgrade => 'ترقية';

  @override
  String get medicationAdded => 'تمت إضافة الدواء';

  @override
  String get errorAddingMedication => 'خطأ في إضافة الدواء';

  @override
  String get basicInfo => 'المعلومات الأساسية';

  @override
  String get photos => 'الصور';

  @override
  String get medicationDetails => 'تفاصيل الدواء';

  @override
  String get medicationNameHint => 'أدخل اسم الدواء';

  @override
  String get medicationNameRequired => 'اسم الدواء مطلوب';

  @override
  String get medicationNameTooShort => 'اسم الدواء قصير جداً';

  @override
  String get medicationNameTooLong => 'اسم الدواء طويل جداً';

  @override
  String get addPhotos => 'إضافة صور';

  @override
  String get photosHelp => 'أضف صور للدواء للتعرف عليه بسهولة';

  @override
  String get visualTagsHelp => 'أضف علامات مرئية للدواء';

  @override
  String get noProfileSelected => 'لم يتم اختيار ملف';

  @override
  String get noProfiles => 'لا توجد ملفات';

  @override
  String get noProfilesDescription => 'أنشئ ملفاً شخصياً للبدء';

  @override
  String get createProfile => 'إنشاء ملف';

  @override
  String get profileCreated => 'تم إنشاء الملف';

  @override
  String get profileNameHint => 'أدخل اسم الملف';

  @override
  String get profileType => 'نوع الملف';

  @override
  String get profileSettings => 'إعدادات الملف';

  @override
  String get managedProfile => 'ملف مُدار';

  @override
  String get managedProfileDescription => 'ملف شخص تعتني به';

  @override
  String get linkedProfile => 'ملف مرتبط';

  @override
  String get linkedProfileDescription => 'ملف شخص يعتني بك';

  @override
  String get linkedProfileDisclaimer => 'سيتمكن هذا الشخص من رؤية أدويتك';

  @override
  String get linkWithCaregiver => 'ربط مع مقدم رعاية';

  @override
  String get linkingWithCaregiver => 'جاري الربط...';

  @override
  String get linkedSuccessfully => 'تم الربط بنجاح';

  @override
  String get linkedSuccessfullyDescription => 'تم ربط الملف بنجاح';

  @override
  String get acceptAndLink => 'قبول وربط';

  @override
  String get permissions => 'الصلاحيات';

  @override
  String get choosePermissions => 'اختر الصلاحيات';

  @override
  String get canChangePermissionsLater => 'يمكنك تغيير الصلاحيات لاحقاً';

  @override
  String get medicationsOnly => 'الأدوية فقط';

  @override
  String get medicationsOnlyDescription => 'عرض الأدوية فقط';

  @override
  String get medicationsAndLog => 'الأدوية والسجل';

  @override
  String get medicationsAndLogDescription => 'عرض الأدوية وسجل الالتزام';

  @override
  String get manageMediactions => 'إدارة الأدوية';

  @override
  String get manageMedicationsDescription => 'إضافة وتعديل الأدوية';

  @override
  String get receiveAlerts => 'استلام التنبيهات';

  @override
  String get receiveAlertsDescription => 'استلام تنبيهات عند تفويت جرعة';

  @override
  String get viewAdherenceLog => 'عرض سجل الالتزام';

  @override
  String get viewAdherenceLogDescription => 'عرض تاريخ تناول الأدوية';

  @override
  String get shareQr => 'مشاركة QR';

  @override
  String get shareQrDescription => 'مشاركة رمز QR للربط';

  @override
  String get generateQrCode => 'إنشاء رمز QR';

  @override
  String get qrShareDisclaimer => 'شارك هذا الرمز مع مقدم الرعاية';

  @override
  String get qrStep1 => 'افتح التطبيق على جهاز مقدم الرعاية';

  @override
  String get qrStep2 => 'اضغط على إضافة ملف مرتبط';

  @override
  String get qrStep3 => 'امسح رمز QR';

  @override
  String get qrStep4 => 'اقبل طلب الربط';

  @override
  String get howItWorks => 'كيف يعمل';

  @override
  String get copyLink => 'نسخ الرابط';

  @override
  String get linkCopied => 'تم نسخ الرابط';

  @override
  String get shareOptions => 'خيارات المشاركة';

  @override
  String get expiresIn => 'ينتهي في';

  @override
  String get inviteCreated => 'تم إنشاء الدعوة';

  @override
  String get inviteExpiresIn72Hours => 'تنتهي الدعوة خلال 72 ساعة';

  @override
  String get inviteInstructions => 'أرسل هذا الرابط لمقدم الرعاية';

  @override
  String get sendInvite => 'إرسال دعوة';

  @override
  String get revoke => 'إلغاء';

  @override
  String get shareSessionRevoked => 'تم إلغاء جلسة المشاركة';

  @override
  String get sharing => 'المشاركة';

  @override
  String get whatToShare => 'ماذا تريد مشاركته';

  @override
  String get shareWithDoctorDescription => 'شارك معلوماتك مع طبيبك';

  @override
  String get doctorVisitDescription => 'معلومات لزيارة الطبيب';

  @override
  String get exportPdf => 'تصدير PDF';

  @override
  String get generatingPdf => 'جاري إنشاء PDF...';

  @override
  String get pdfGenerated => 'تم إنشاء PDF';

  @override
  String get download => 'تحميل';

  @override
  String get enterPairCodeDescription => 'أدخل رمز الاقتران';

  @override
  String get whereToFindCode => 'أين أجد الرمز؟';

  @override
  String get whereToFindCodeDescription =>
      'اطلب الرمز من الشخص الذي تريد الربط معه';

  @override
  String get caregiverConsentDisclaimer =>
      'بالموافقة، ستتمكن من رؤية أدوية هذا الشخص';

  @override
  String get verify => 'تحقق';

  @override
  String get processing => 'جاري المعالجة...';

  @override
  String get all => 'الكل';

  @override
  String get daily => 'يومي';

  @override
  String get specificDays => 'أيام محددة';

  @override
  String get interval => 'فترة زمنية';

  @override
  String get repeatEvery => 'تكرار كل';

  @override
  String get hour => 'ساعة';

  @override
  String get hours => 'ساعات';

  @override
  String get times => 'مرات';

  @override
  String get atLeastOneTime => 'وقت واحد على الأقل';

  @override
  String get before => 'قبل';

  @override
  String get dateRange => 'نطاق التاريخ';

  @override
  String get filters => 'الفلاتر';

  @override
  String get applyFilters => 'تطبيق الفلاتر';

  @override
  String get filtersApplied => 'تم تطبيق الفلاتر';

  @override
  String get clear => 'مسح';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get eventType => 'نوع الحدث';

  @override
  String get skipped => 'تم تخطيه';

  @override
  String get snoozed => 'تم تأجيله';

  @override
  String get snoozedFor => 'مؤجل لـ';

  @override
  String get snoozeFor => 'تأجيل لـ';

  @override
  String get yesterday => 'أمس';

  @override
  String get other => 'أخرى';

  @override
  String get noEventsFound => 'لا توجد أحداث';

  @override
  String get adherenceLog => 'سجل الالتزام';

  @override
  String get errorLoadingData => 'خطأ في تحميل البيانات';

  @override
  String get errorLoadingMedications => 'خطأ في تحميل الأدوية';

  @override
  String get errorLoadingProfiles => 'خطأ في تحميل الملفات';

  @override
  String get noActiveMedications => 'لا توجد أدوية نشطة';

  @override
  String get noArchivedMedications => 'لا توجد أدوية مؤرشفة';

  @override
  String get noPausedMedications => 'لا توجد أدوية موقوفة';

  @override
  String get noDosesScheduled => 'لا توجد جرعات مجدولة';

  @override
  String get allDoneForToday => 'انتهيت من كل شيء اليوم';

  @override
  String get doseTakenSuccess => 'تم تسجيل الجرعة';

  @override
  String get doseSkipped => 'تم تخطي الجرعة';

  @override
  String get pause => 'إيقاف';

  @override
  String get paused => 'موقوف';

  @override
  String get resume => 'استئناف';

  @override
  String get archived => 'مؤرشف';

  @override
  String get deleteMedication => 'حذف الدواء';

  @override
  String get medication => 'دواء';

  @override
  String get traveling => 'مسافر';

  @override
  String get notAvailable => 'غير متوفر';

  @override
  String get account => 'الحساب';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get pinSecurity => 'أمان الرمز السري';

  @override
  String get setUpPin => 'إعداد رمز سري';

  @override
  String get createPin => 'إنشاء رمز سري';

  @override
  String get createPinSubtitle => 'أنشئ رمزاً سرياً من 4 أرقام';

  @override
  String get confirmPinSubtitle => 'أعد إدخال الرمز السري';

  @override
  String get enterPinSubtitle => 'أدخل الرمز السري';

  @override
  String get removePin => 'إزالة الرمز السري';

  @override
  String get pinRemoved => 'تم إزالة الرمز السري';

  @override
  String get pinsDoNotMatch => 'الرمزان غير متطابقين';

  @override
  String get incorrectPin => 'رمز سري غير صحيح';

  @override
  String get errorSavingPin => 'خطأ في حفظ الرمز السري';

  @override
  String get biometricUnlock => 'فتح ببصمة الإصبع';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get faq1Question => 'كيف أضيف دواء؟';

  @override
  String get faq1Answer => 'اضغط على زر + في الشاشة الرئيسية';

  @override
  String get faq2Question => 'كيف أربط مع مقدم رعاية؟';

  @override
  String get faq2Answer => 'اذهب إلى الملفات واختر مشاركة QR';

  @override
  String get faq3Question => 'كيف أصدر تقريراً؟';

  @override
  String get faq3Answer => 'اذهب إلى زيارة الطبيب واختر تصدير PDF';

  @override
  String get logoutConfirm => 'هل تريد تسجيل الخروج؟';

  @override
  String get forgot => 'نسيت؟';

  @override
  String get goToApp => 'الذهاب للتطبيق';

  @override
  String get profile => 'الملف';

  @override
  String get feature => 'ميزة';

  @override
  String get free => 'مجاني';

  @override
  String get unlimited => 'غير محدود';

  @override
  String get recommended => 'موصى به';

  @override
  String get proPrice => '٩٩ ريال/سنة';

  @override
  String get youAreOnFree => 'أنت على الخطة المجانية';

  @override
  String get youAreOnPro => 'أنت على خطة Pro';

  @override
  String get upgradeRequired => 'الترقية مطلوبة';

  @override
  String get upgradeToAddMoreProfiles => 'قم بالترقية لإضافة المزيد من الملفات';

  @override
  String get upgradeConfirmation => 'هل تريد الترقية؟';

  @override
  String get upgradeSuccess => 'تمت الترقية بنجاح';

  @override
  String get paymentNote => 'سيتم الدفع عبر المتجر';

  @override
  String get freeFeature1 => 'ملف واحد';

  @override
  String get freeFeature1Unlimited => 'ملفات غير محدودة';

  @override
  String get freeFeature2 => '5 أدوية';

  @override
  String get freeFeature2Unlimited => 'أدوية غير محدودة';

  @override
  String get freeFeature3 => 'تذكيرات أساسية';

  @override
  String get freeFeature4 => 'سجل 7 أيام';

  @override
  String get proFeature1 => 'ملفات غير محدودة';

  @override
  String get proFeature2 => 'أدوية غير محدودة';

  @override
  String get proFeature3 => 'تصدير PDF';

  @override
  String get proFeature4 => 'سجل كامل';

  @override
  String get featureComparison => 'مقارنة الميزات';

  @override
  String get featureMedications => 'الأدوية';

  @override
  String get featureProfiles => 'الملفات';

  @override
  String get featureReminders => 'التذكيرات';

  @override
  String get featureAdherenceLog => 'سجل الالتزام';

  @override
  String get featurePdfExport => 'تصدير PDF';

  @override
  String get featureQrShare => 'مشاركة QR';

  @override
  String get featureAdvancedSummaries => 'ملخصات متقدمة';

  @override
  String get featureCaregiverEscalation => 'تصعيد لمقدم الرعاية';

  @override
  String get noNotificationsDescription => 'لا توجد إشعارات';

  @override
  String get markAllRead => 'تعليم الكل كمقروء';

  @override
  String get allNotificationsMarkedRead => 'تم تعليم كل الإشعارات كمقروءة';

  @override
  String get patientPhone => 'رقم هاتف المريض';

  @override
  String get patientPhoneHelper => 'أدخل رقم الهاتف';

  @override
  String get phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get invalidPhoneFormat => 'صيغة الهاتف غير صحيحة';

  @override
  String get nameTooShort => 'الاسم قصير جداً';

  @override
  String get paste => 'لصق';
}
