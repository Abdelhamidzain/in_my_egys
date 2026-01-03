import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// Application name
  ///
  /// In ar, this message translates to:
  /// **'في عيوني'**
  String get appName;

  /// Medical disclaimer shown throughout the app
  ///
  /// In ar, this message translates to:
  /// **'هذا التطبيق للتذكير والمتابعة فقط ولا يقدم نصائح طبية. اتبع تعليمات طبيبك دائمًا.'**
  String get disclaimer;

  /// No description provided for @welcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك'**
  String get welcome;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق في عيوني للعائلة'**
  String get welcomeSubtitle;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get signup;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين كلمة المرور'**
  String get resetPassword;

  /// No description provided for @confirmEmail.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد البريد الإلكتروني'**
  String get confirmEmail;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get confirmPassword;

  /// No description provided for @phone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الجوال'**
  String get phone;

  /// No description provided for @name.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get name;

  /// No description provided for @emailRequired.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني مطلوب'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني غير صحيح'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور مطلوبة'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور قصيرة جداً (8 أحرف على الأقل)'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمات المرور غير متطابقة'**
  String get passwordsDoNotMatch;

  /// No description provided for @nameRequired.
  ///
  /// In ar, this message translates to:
  /// **'الاسم مطلوب'**
  String get nameRequired;

  /// No description provided for @today.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get today;

  /// No description provided for @medications.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية'**
  String get medications;

  /// No description provided for @log.
  ///
  /// In ar, this message translates to:
  /// **'السجل'**
  String get log;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @nextDose.
  ///
  /// In ar, this message translates to:
  /// **'الجرعة القادمة'**
  String get nextDose;

  /// No description provided for @dueAt.
  ///
  /// In ar, this message translates to:
  /// **'موعدها الساعة {time}'**
  String dueAt(String time);

  /// No description provided for @dueIn.
  ///
  /// In ar, this message translates to:
  /// **'بعد {duration}'**
  String dueIn(String duration);

  /// No description provided for @overdue.
  ///
  /// In ar, this message translates to:
  /// **'متأخر'**
  String get overdue;

  /// No description provided for @taken.
  ///
  /// In ar, this message translates to:
  /// **'تم تناولها'**
  String get taken;

  /// No description provided for @snooze.
  ///
  /// In ar, this message translates to:
  /// **'تأجيل'**
  String get snooze;

  /// No description provided for @skip.
  ///
  /// In ar, this message translates to:
  /// **'تخطي'**
  String get skip;

  /// No description provided for @snoozeOptions.
  ///
  /// In ar, this message translates to:
  /// **'خيارات التأجيل'**
  String get snoozeOptions;

  /// No description provided for @snoozeMinutes.
  ///
  /// In ar, this message translates to:
  /// **'{minutes} دقائق'**
  String snoozeMinutes(int minutes);

  /// No description provided for @skipReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب التخطي'**
  String get skipReason;

  /// No description provided for @skipReasonForgot.
  ///
  /// In ar, this message translates to:
  /// **'نسيت'**
  String get skipReasonForgot;

  /// No description provided for @skipReasonNotAvailable.
  ///
  /// In ar, this message translates to:
  /// **'الدواء غير متوفر'**
  String get skipReasonNotAvailable;

  /// No description provided for @skipReasonTravel.
  ///
  /// In ar, this message translates to:
  /// **'في سفر'**
  String get skipReasonTravel;

  /// No description provided for @skipReasonOther.
  ///
  /// In ar, this message translates to:
  /// **'سبب آخر'**
  String get skipReasonOther;

  /// No description provided for @todaySchedule.
  ///
  /// In ar, this message translates to:
  /// **'جدول اليوم'**
  String get todaySchedule;

  /// No description provided for @noMedicationsToday.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أدوية مجدولة لليوم'**
  String get noMedicationsToday;

  /// No description provided for @allDosesCompleted.
  ///
  /// In ar, this message translates to:
  /// **'تم تناول جميع الجرعات!'**
  String get allDosesCompleted;

  /// No description provided for @profiles.
  ///
  /// In ar, this message translates to:
  /// **'الملفات الشخصية'**
  String get profiles;

  /// No description provided for @addProfile.
  ///
  /// In ar, this message translates to:
  /// **'إضافة ملف'**
  String get addProfile;

  /// No description provided for @editProfile.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملف'**
  String get editProfile;

  /// No description provided for @deleteProfile.
  ///
  /// In ar, this message translates to:
  /// **'حذف الملف'**
  String get deleteProfile;

  /// No description provided for @switchProfile.
  ///
  /// In ar, this message translates to:
  /// **'تغيير الملف'**
  String get switchProfile;

  /// No description provided for @profileName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الملف'**
  String get profileName;

  /// No description provided for @relationship.
  ///
  /// In ar, this message translates to:
  /// **'صلة القرابة'**
  String get relationship;

  /// No description provided for @relationshipSelf.
  ///
  /// In ar, this message translates to:
  /// **'أنا'**
  String get relationshipSelf;

  /// No description provided for @relationshipMother.
  ///
  /// In ar, this message translates to:
  /// **'أمي'**
  String get relationshipMother;

  /// No description provided for @relationshipFather.
  ///
  /// In ar, this message translates to:
  /// **'أبي'**
  String get relationshipFather;

  /// No description provided for @relationshipSpouse.
  ///
  /// In ar, this message translates to:
  /// **'زوجي/زوجتي'**
  String get relationshipSpouse;

  /// No description provided for @relationshipChild.
  ///
  /// In ar, this message translates to:
  /// **'ابني/ابنتي'**
  String get relationshipChild;

  /// No description provided for @relationshipGrandparent.
  ///
  /// In ar, this message translates to:
  /// **'جدي/جدتي'**
  String get relationshipGrandparent;

  /// No description provided for @relationshipOther.
  ///
  /// In ar, this message translates to:
  /// **'آخر'**
  String get relationshipOther;

  /// No description provided for @profileTypeSelf.
  ///
  /// In ar, this message translates to:
  /// **'ملفي الشخصي'**
  String get profileTypeSelf;

  /// No description provided for @profileTypeManaged.
  ///
  /// In ar, this message translates to:
  /// **'ملف أديره'**
  String get profileTypeManaged;

  /// No description provided for @profileTypeLinked.
  ///
  /// In ar, this message translates to:
  /// **'ملف مرتبط'**
  String get profileTypeLinked;

  /// No description provided for @seniorMode.
  ///
  /// In ar, this message translates to:
  /// **'وضع كبار السن'**
  String get seniorMode;

  /// No description provided for @seniorModeDescription.
  ///
  /// In ar, this message translates to:
  /// **'أزرار أكبر وواجهة أبسط'**
  String get seniorModeDescription;

  /// No description provided for @highContrast.
  ///
  /// In ar, this message translates to:
  /// **'تباين عالي'**
  String get highContrast;

  /// No description provided for @addMedication.
  ///
  /// In ar, this message translates to:
  /// **'إضافة دواء'**
  String get addMedication;

  /// No description provided for @editMedication.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الدواء'**
  String get editMedication;

  /// No description provided for @medicationName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء'**
  String get medicationName;

  /// No description provided for @instructions.
  ///
  /// In ar, this message translates to:
  /// **'التعليمات'**
  String get instructions;

  /// No description provided for @instructionsHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: قرص واحد بعد الأكل'**
  String get instructionsHint;

  /// No description provided for @medicationPhotos.
  ///
  /// In ar, this message translates to:
  /// **'صور الدواء'**
  String get medicationPhotos;

  /// No description provided for @pillPhoto.
  ///
  /// In ar, this message translates to:
  /// **'صورة الحبة'**
  String get pillPhoto;

  /// No description provided for @boxPhoto.
  ///
  /// In ar, this message translates to:
  /// **'صورة العلبة'**
  String get boxPhoto;

  /// No description provided for @addPhoto.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صورة'**
  String get addPhoto;

  /// No description provided for @takePhoto.
  ///
  /// In ar, this message translates to:
  /// **'التقاط صورة'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In ar, this message translates to:
  /// **'اختيار من المعرض'**
  String get chooseFromGallery;

  /// No description provided for @visualTags.
  ///
  /// In ar, this message translates to:
  /// **'علامات مميزة'**
  String get visualTags;

  /// No description provided for @visualTagWhite.
  ///
  /// In ar, this message translates to:
  /// **'أبيض'**
  String get visualTagWhite;

  /// No description provided for @visualTagPink.
  ///
  /// In ar, this message translates to:
  /// **'وردي'**
  String get visualTagPink;

  /// No description provided for @visualTagBlue.
  ///
  /// In ar, this message translates to:
  /// **'أزرق'**
  String get visualTagBlue;

  /// No description provided for @visualTagYellow.
  ///
  /// In ar, this message translates to:
  /// **'أصفر'**
  String get visualTagYellow;

  /// No description provided for @visualTagGreen.
  ///
  /// In ar, this message translates to:
  /// **'أخضر'**
  String get visualTagGreen;

  /// No description provided for @visualTagRound.
  ///
  /// In ar, this message translates to:
  /// **'دائري'**
  String get visualTagRound;

  /// No description provided for @visualTagOval.
  ///
  /// In ar, this message translates to:
  /// **'بيضاوي'**
  String get visualTagOval;

  /// No description provided for @visualTagCapsule.
  ///
  /// In ar, this message translates to:
  /// **'كبسولة'**
  String get visualTagCapsule;

  /// No description provided for @visualTagSmall.
  ///
  /// In ar, this message translates to:
  /// **'صغير'**
  String get visualTagSmall;

  /// No description provided for @visualTagLarge.
  ///
  /// In ar, this message translates to:
  /// **'كبير'**
  String get visualTagLarge;

  /// No description provided for @schedule.
  ///
  /// In ar, this message translates to:
  /// **'الجدول'**
  String get schedule;

  /// No description provided for @scheduleType.
  ///
  /// In ar, this message translates to:
  /// **'نوع الجدول'**
  String get scheduleType;

  /// No description provided for @dailyFixedTimes.
  ///
  /// In ar, this message translates to:
  /// **'يومياً في أوقات محددة'**
  String get dailyFixedTimes;

  /// No description provided for @daysOfWeek.
  ///
  /// In ar, this message translates to:
  /// **'أيام محددة من الأسبوع'**
  String get daysOfWeek;

  /// No description provided for @everyXHours.
  ///
  /// In ar, this message translates to:
  /// **'كل عدة ساعات'**
  String get everyXHours;

  /// No description provided for @selectTimes.
  ///
  /// In ar, this message translates to:
  /// **'اختر الأوقات'**
  String get selectTimes;

  /// No description provided for @addTime.
  ///
  /// In ar, this message translates to:
  /// **'إضافة وقت'**
  String get addTime;

  /// No description provided for @selectDays.
  ///
  /// In ar, this message translates to:
  /// **'اختر الأيام'**
  String get selectDays;

  /// No description provided for @everyHours.
  ///
  /// In ar, this message translates to:
  /// **'كل {hours} ساعات'**
  String everyHours(int hours);

  /// No description provided for @preAlert.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه مسبق'**
  String get preAlert;

  /// No description provided for @preAlertMinutes.
  ///
  /// In ar, this message translates to:
  /// **'قبل {minutes} دقيقة'**
  String preAlertMinutes(int minutes);

  /// No description provided for @startDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ البداية'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ النهاية'**
  String get endDate;

  /// No description provided for @ongoing.
  ///
  /// In ar, this message translates to:
  /// **'مستمر'**
  String get ongoing;

  /// No description provided for @medicationStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة الدواء'**
  String get medicationStatus;

  /// No description provided for @statusActive.
  ///
  /// In ar, this message translates to:
  /// **'نشط'**
  String get statusActive;

  /// No description provided for @statusPaused.
  ///
  /// In ar, this message translates to:
  /// **'متوقف'**
  String get statusPaused;

  /// No description provided for @statusArchived.
  ///
  /// In ar, this message translates to:
  /// **'مؤرشف'**
  String get statusArchived;

  /// No description provided for @caregiver.
  ///
  /// In ar, this message translates to:
  /// **'مقدم الرعاية'**
  String get caregiver;

  /// No description provided for @caregivers.
  ///
  /// In ar, this message translates to:
  /// **'مقدمو الرعاية'**
  String get caregivers;

  /// No description provided for @addCaregiver.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مقدم رعاية'**
  String get addCaregiver;

  /// No description provided for @inviteCaregiver.
  ///
  /// In ar, this message translates to:
  /// **'دعوة مقدم رعاية'**
  String get inviteCaregiver;

  /// No description provided for @caregiverPermissions.
  ///
  /// In ar, this message translates to:
  /// **'صلاحيات مقدم الرعاية'**
  String get caregiverPermissions;

  /// No description provided for @canAddEditMeds.
  ///
  /// In ar, this message translates to:
  /// **'يمكنه إضافة وتعديل الأدوية'**
  String get canAddEditMeds;

  /// No description provided for @canViewLog.
  ///
  /// In ar, this message translates to:
  /// **'يمكنه عرض سجل الالتزام'**
  String get canViewLog;

  /// No description provided for @notifyIfNoConfirmation.
  ///
  /// In ar, this message translates to:
  /// **'إشعاري عند عدم تأكيد الجرعة'**
  String get notifyIfNoConfirmation;

  /// No description provided for @pairingInvite.
  ///
  /// In ar, this message translates to:
  /// **'دعوة ربط'**
  String get pairingInvite;

  /// No description provided for @pairCode.
  ///
  /// In ar, this message translates to:
  /// **'رمز الربط'**
  String get pairCode;

  /// No description provided for @enterPairCode.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز الربط'**
  String get enterPairCode;

  /// No description provided for @sendViaWhatsApp.
  ///
  /// In ar, this message translates to:
  /// **'إرسال عبر واتساب'**
  String get sendViaWhatsApp;

  /// No description provided for @inviteExpires.
  ///
  /// In ar, this message translates to:
  /// **'تنتهي الدعوة خلال {hours} ساعة'**
  String inviteExpires(int hours);

  /// No description provided for @inviteAccepted.
  ///
  /// In ar, this message translates to:
  /// **'تم قبول الدعوة!'**
  String get inviteAccepted;

  /// No description provided for @consent.
  ///
  /// In ar, this message translates to:
  /// **'الموافقة'**
  String get consent;

  /// No description provided for @consentTitle.
  ///
  /// In ar, this message translates to:
  /// **'صلاحيات مقدم الرعاية'**
  String get consentTitle;

  /// No description provided for @consentDescription.
  ///
  /// In ar, this message translates to:
  /// **'اختر الصلاحيات التي تريد منحها لمقدم الرعاية'**
  String get consentDescription;

  /// No description provided for @acceptAndContinue.
  ///
  /// In ar, this message translates to:
  /// **'موافقة ومتابعة'**
  String get acceptAndContinue;

  /// No description provided for @doctorVisitMode.
  ///
  /// In ar, this message translates to:
  /// **'وضع زيارة الطبيب'**
  String get doctorVisitMode;

  /// No description provided for @shareWithDoctor.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة مع الطبيب'**
  String get shareWithDoctor;

  /// No description provided for @generateQR.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء رمز QR'**
  String get generateQR;

  /// No description provided for @shareScope.
  ///
  /// In ar, this message translates to:
  /// **'نطاق المشاركة'**
  String get shareScope;

  /// No description provided for @scopeMedsOnly.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية فقط'**
  String get scopeMedsOnly;

  /// No description provided for @scopeMedsAndLog.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية وسجل الالتزام'**
  String get scopeMedsAndLog;

  /// No description provided for @expiryTime.
  ///
  /// In ar, this message translates to:
  /// **'مدة الصلاحية'**
  String get expiryTime;

  /// No description provided for @minutes.
  ///
  /// In ar, this message translates to:
  /// **'{count} دقيقة'**
  String minutes(int count);

  /// No description provided for @shareActive.
  ///
  /// In ar, this message translates to:
  /// **'المشاركة نشطة'**
  String get shareActive;

  /// No description provided for @shareExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت المشاركة'**
  String get shareExpired;

  /// No description provided for @revokeShare.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء المشاركة'**
  String get revokeShare;

  /// No description provided for @exportPDF.
  ///
  /// In ar, this message translates to:
  /// **'تصدير PDF'**
  String get exportPDF;

  /// No description provided for @adherence.
  ///
  /// In ar, this message translates to:
  /// **'الالتزام'**
  String get adherence;

  /// No description provided for @adherenceRate.
  ///
  /// In ar, this message translates to:
  /// **'نسبة الالتزام'**
  String get adherenceRate;

  /// No description provided for @adherenceSummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص الالتزام'**
  String get adherenceSummary;

  /// No description provided for @last7Days.
  ///
  /// In ar, this message translates to:
  /// **'آخر 7 أيام'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In ar, this message translates to:
  /// **'آخر 30 يوم'**
  String get last30Days;

  /// No description provided for @dosesConfirmed.
  ///
  /// In ar, this message translates to:
  /// **'جرعات تم تناولها'**
  String get dosesConfirmed;

  /// No description provided for @dosesSkipped.
  ///
  /// In ar, this message translates to:
  /// **'جرعات تم تخطيها'**
  String get dosesSkipped;

  /// No description provided for @dosesMissed.
  ///
  /// In ar, this message translates to:
  /// **'جرعات فائتة'**
  String get dosesMissed;

  /// No description provided for @subscription.
  ///
  /// In ar, this message translates to:
  /// **'الاشتراك'**
  String get subscription;

  /// No description provided for @freePlan.
  ///
  /// In ar, this message translates to:
  /// **'الخطة المجانية'**
  String get freePlan;

  /// No description provided for @proPlan.
  ///
  /// In ar, this message translates to:
  /// **'الخطة المميزة'**
  String get proPlan;

  /// No description provided for @currentPlan.
  ///
  /// In ar, this message translates to:
  /// **'خطتك الحالية'**
  String get currentPlan;

  /// No description provided for @upgradeToPro.
  ///
  /// In ar, this message translates to:
  /// **'ترقية للمميزة'**
  String get upgradeToPro;

  /// No description provided for @freePlanFeatures.
  ///
  /// In ar, this message translates to:
  /// **'حتى ملفين\n3 أدوية لكل ملف\nتذكيرات وسجل الالتزام\nعرض ملخص أسبوعي'**
  String get freePlanFeatures;

  /// No description provided for @proPlanFeatures.
  ///
  /// In ar, this message translates to:
  /// **'ملفات غير محدودة\nأدوية غير محدودة\nإشعارات لمقدمي الرعاية\nمشاركة QR مع الطبيب\nتصدير PDF\nملخصات متقدمة'**
  String get proPlanFeatures;

  /// No description provided for @limitReached.
  ///
  /// In ar, this message translates to:
  /// **'وصلت للحد الأقصى'**
  String get limitReached;

  /// No description provided for @profileLimitReached.
  ///
  /// In ar, this message translates to:
  /// **'وصلت للحد الأقصى من الملفات في الخطة المجانية'**
  String get profileLimitReached;

  /// No description provided for @medicationLimitReached.
  ///
  /// In ar, this message translates to:
  /// **'وصلت للحد الأقصى من الأدوية في الخطة المجانية'**
  String get medicationLimitReached;

  /// No description provided for @upgradeToAdd.
  ///
  /// In ar, this message translates to:
  /// **'قم بالترقية لإضافة المزيد'**
  String get upgradeToAdd;

  /// No description provided for @pin.
  ///
  /// In ar, this message translates to:
  /// **'رمز PIN'**
  String get pin;

  /// No description provided for @setPin.
  ///
  /// In ar, this message translates to:
  /// **'تعيين رمز PIN'**
  String get setPin;

  /// No description provided for @enterPin.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز PIN'**
  String get enterPin;

  /// No description provided for @confirmPin.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد رمز PIN'**
  String get confirmPin;

  /// No description provided for @changePin.
  ///
  /// In ar, this message translates to:
  /// **'تغيير رمز PIN'**
  String get changePin;

  /// No description provided for @pinRequired.
  ///
  /// In ar, this message translates to:
  /// **'رمز PIN مطلوب للدخول'**
  String get pinRequired;

  /// No description provided for @wrongPin.
  ///
  /// In ar, this message translates to:
  /// **'رمز PIN غير صحيح'**
  String get wrongPin;

  /// No description provided for @biometricAuth.
  ///
  /// In ar, this message translates to:
  /// **'المصادقة البيومترية'**
  String get biometricAuth;

  /// No description provided for @useBiometric.
  ///
  /// In ar, this message translates to:
  /// **'استخدام البصمة / Face ID'**
  String get useBiometric;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @languageArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @timezone.
  ///
  /// In ar, this message translates to:
  /// **'المنطقة الزمنية'**
  String get timezone;

  /// No description provided for @timezoneHome.
  ///
  /// In ar, this message translates to:
  /// **'المنطقة الزمنية الأساسية'**
  String get timezoneHome;

  /// No description provided for @timezoneCurrent.
  ///
  /// In ar, this message translates to:
  /// **'المنطقة الزمنية الحالية'**
  String get timezoneCurrent;

  /// No description provided for @about.
  ///
  /// In ar, this message translates to:
  /// **'عن التطبيق'**
  String get about;

  /// No description provided for @privacyPolicy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In ar, this message translates to:
  /// **'شروط الاستخدام'**
  String get termsOfService;

  /// No description provided for @contactSupport.
  ///
  /// In ar, this message translates to:
  /// **'تواصل معنا'**
  String get contactSupport;

  /// No description provided for @version.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار'**
  String get version;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @done.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get done;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get next;

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get back;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get close;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get loading;

  /// No description provided for @saving.
  ///
  /// In ar, this message translates to:
  /// **'جاري الحفظ...'**
  String get saving;

  /// No description provided for @error.
  ///
  /// In ar, this message translates to:
  /// **'خطأ'**
  String get error;

  /// No description provided for @success.
  ///
  /// In ar, this message translates to:
  /// **'تم بنجاح'**
  String get success;

  /// No description provided for @offline.
  ///
  /// In ar, this message translates to:
  /// **'غير متصل'**
  String get offline;

  /// No description provided for @offlineBanner.
  ///
  /// In ar, this message translates to:
  /// **'أنت غير متصل. التغييرات ستُحفظ عند الاتصال.'**
  String get offlineBanner;

  /// No description provided for @syncing.
  ///
  /// In ar, this message translates to:
  /// **'جاري المزامنة...'**
  String get syncing;

  /// No description provided for @syncComplete.
  ///
  /// In ar, this message translates to:
  /// **'تمت المزامنة'**
  String get syncComplete;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الحذف'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteProfileConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف هذا الملف؟ سيتم حذف جميع الأدوية والسجلات المرتبطة به.'**
  String get deleteProfileConfirm;

  /// No description provided for @deleteMedicationConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف هذا الدواء؟'**
  String get deleteMedicationConfirm;

  /// No description provided for @noNotifications.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات'**
  String get noNotifications;

  /// No description provided for @markAsRead.
  ///
  /// In ar, this message translates to:
  /// **'تحديد كمقروء'**
  String get markAsRead;

  /// No description provided for @markAllAsRead.
  ///
  /// In ar, this message translates to:
  /// **'تحديد الكل كمقروء'**
  String get markAllAsRead;

  /// No description provided for @adminDashboard.
  ///
  /// In ar, this message translates to:
  /// **'لوحة التحكم'**
  String get adminDashboard;

  /// No description provided for @adminUsers.
  ///
  /// In ar, this message translates to:
  /// **'المستخدمون'**
  String get adminUsers;

  /// No description provided for @adminProfiles.
  ///
  /// In ar, this message translates to:
  /// **'الملفات'**
  String get adminProfiles;

  /// No description provided for @adminMedications.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية'**
  String get adminMedications;

  /// No description provided for @adminExports.
  ///
  /// In ar, this message translates to:
  /// **'التصدير'**
  String get adminExports;

  /// No description provided for @adminAnalytics.
  ///
  /// In ar, this message translates to:
  /// **'الإحصائيات'**
  String get adminAnalytics;

  /// No description provided for @adminAudit.
  ///
  /// In ar, this message translates to:
  /// **'سجل العمليات'**
  String get adminAudit;

  /// No description provided for @searchUsers.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن مستخدم...'**
  String get searchUsers;

  /// No description provided for @searchProfiles.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن ملف...'**
  String get searchProfiles;

  /// No description provided for @userDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المستخدم'**
  String get userDetails;

  /// No description provided for @banUser.
  ///
  /// In ar, this message translates to:
  /// **'حظر المستخدم'**
  String get banUser;

  /// No description provided for @unbanUser.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء حظر المستخدم'**
  String get unbanUser;

  /// No description provided for @exportCSV.
  ///
  /// In ar, this message translates to:
  /// **'تصدير CSV'**
  String get exportCSV;

  /// No description provided for @totalUsers.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المستخدمين'**
  String get totalUsers;

  /// No description provided for @activeUsers.
  ///
  /// In ar, this message translates to:
  /// **'مستخدمون نشطون'**
  String get activeUsers;

  /// No description provided for @dosesToday.
  ///
  /// In ar, this message translates to:
  /// **'جرعات اليوم'**
  String get dosesToday;

  /// No description provided for @caregiverLinks.
  ///
  /// In ar, this message translates to:
  /// **'روابط مقدمي الرعاية'**
  String get caregiverLinks;

  /// No description provided for @sunday.
  ///
  /// In ar, this message translates to:
  /// **'الأحد'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In ar, this message translates to:
  /// **'الاثنين'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In ar, this message translates to:
  /// **'الثلاثاء'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In ar, this message translates to:
  /// **'الأربعاء'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In ar, this message translates to:
  /// **'الخميس'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In ar, this message translates to:
  /// **'الجمعة'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In ar, this message translates to:
  /// **'السبت'**
  String get saturday;

  /// No description provided for @analyticsOverview.
  ///
  /// In ar, this message translates to:
  /// **'نظرة عامة'**
  String get analyticsOverview;

  /// No description provided for @analyticsUserStats.
  ///
  /// In ar, this message translates to:
  /// **'إحصائيات المستخدمين'**
  String get analyticsUserStats;

  /// No description provided for @analyticsAdherenceStats.
  ///
  /// In ar, this message translates to:
  /// **'إحصائيات الالتزام'**
  String get analyticsAdherenceStats;

  /// No description provided for @analyticsFeatureUsage.
  ///
  /// In ar, this message translates to:
  /// **'استخدام الميزات'**
  String get analyticsFeatureUsage;

  /// No description provided for @analyticsTrends.
  ///
  /// In ar, this message translates to:
  /// **'الاتجاهات'**
  String get analyticsTrends;

  /// No description provided for @proUsers.
  ///
  /// In ar, this message translates to:
  /// **'مستخدمو Pro'**
  String get proUsers;

  /// No description provided for @freeUsers.
  ///
  /// In ar, this message translates to:
  /// **'مستخدمو المجاني'**
  String get freeUsers;

  /// No description provided for @activeUsersLast7Days.
  ///
  /// In ar, this message translates to:
  /// **'نشطون (7 أيام)'**
  String get activeUsersLast7Days;

  /// No description provided for @activeUsersLast30Days.
  ///
  /// In ar, this message translates to:
  /// **'نشطون (30 يوم)'**
  String get activeUsersLast30Days;

  /// No description provided for @linkedProfiles.
  ///
  /// In ar, this message translates to:
  /// **'ملفات مرتبطة'**
  String get linkedProfiles;

  /// No description provided for @managedProfiles.
  ///
  /// In ar, this message translates to:
  /// **'ملفات مُدارة'**
  String get managedProfiles;

  /// No description provided for @activeMedications.
  ///
  /// In ar, this message translates to:
  /// **'أدوية نشطة'**
  String get activeMedications;

  /// No description provided for @takenToday.
  ///
  /// In ar, this message translates to:
  /// **'تم تناولها اليوم'**
  String get takenToday;

  /// No description provided for @missedToday.
  ///
  /// In ar, this message translates to:
  /// **'فائتة اليوم'**
  String get missedToday;

  /// No description provided for @takenThisWeek.
  ///
  /// In ar, this message translates to:
  /// **'تم تناولها هذا الأسبوع'**
  String get takenThisWeek;

  /// No description provided for @missedThisWeek.
  ///
  /// In ar, this message translates to:
  /// **'فائتة هذا الأسبوع'**
  String get missedThisWeek;

  /// No description provided for @takenThisMonth.
  ///
  /// In ar, this message translates to:
  /// **'تم تناولها هذا الشهر'**
  String get takenThisMonth;

  /// No description provided for @missedThisMonth.
  ///
  /// In ar, this message translates to:
  /// **'فائتة هذا الشهر'**
  String get missedThisMonth;

  /// No description provided for @qrShareSessions.
  ///
  /// In ar, this message translates to:
  /// **'جلسات مشاركة QR'**
  String get qrShareSessions;

  /// No description provided for @pdfExports.
  ///
  /// In ar, this message translates to:
  /// **'تصديرات PDF'**
  String get pdfExports;

  /// No description provided for @caregiverLinkRate.
  ///
  /// In ar, this message translates to:
  /// **'نسبة ربط مقدمي الرعاية'**
  String get caregiverLinkRate;

  /// No description provided for @signupTrend.
  ///
  /// In ar, this message translates to:
  /// **'اتجاه التسجيل'**
  String get signupTrend;

  /// No description provided for @adherenceTrend.
  ///
  /// In ar, this message translates to:
  /// **'اتجاه الالتزام'**
  String get adherenceTrend;

  /// No description provided for @last7DaysChart.
  ///
  /// In ar, this message translates to:
  /// **'آخر 7 أيام'**
  String get last7DaysChart;

  /// No description provided for @last30DaysChart.
  ///
  /// In ar, this message translates to:
  /// **'آخر 30 يوم'**
  String get last30DaysChart;

  /// No description provided for @last90DaysChart.
  ///
  /// In ar, this message translates to:
  /// **'آخر 90 يوم'**
  String get last90DaysChart;

  /// No description provided for @timeRange7d.
  ///
  /// In ar, this message translates to:
  /// **'7 أيام'**
  String get timeRange7d;

  /// No description provided for @timeRange30d.
  ///
  /// In ar, this message translates to:
  /// **'30 يوم'**
  String get timeRange30d;

  /// No description provided for @timeRange90d.
  ///
  /// In ar, this message translates to:
  /// **'90 يوم'**
  String get timeRange90d;

  /// No description provided for @refresh.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get refresh;

  /// No description provided for @refreshing.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحديث...'**
  String get refreshing;

  /// No description provided for @lastUpdated.
  ///
  /// In ar, this message translates to:
  /// **'آخر تحديث: {time}'**
  String lastUpdated(String time);

  /// No description provided for @auditLogs.
  ///
  /// In ar, this message translates to:
  /// **'سجل العمليات'**
  String get auditLogs;

  /// No description provided for @filterByActor.
  ///
  /// In ar, this message translates to:
  /// **'تصفية حسب البريد الإلكتروني'**
  String get filterByActor;

  /// No description provided for @filterByAction.
  ///
  /// In ar, this message translates to:
  /// **'تصفية حسب الإجراء'**
  String get filterByAction;

  /// No description provided for @filterByDate.
  ///
  /// In ar, this message translates to:
  /// **'تصفية حسب التاريخ'**
  String get filterByDate;

  /// No description provided for @allActions.
  ///
  /// In ar, this message translates to:
  /// **'جميع الإجراءات'**
  String get allActions;

  /// No description provided for @clearFilters.
  ///
  /// In ar, this message translates to:
  /// **'مسح الفلاتر'**
  String get clearFilters;

  /// No description provided for @activeFilters.
  ///
  /// In ar, this message translates to:
  /// **'فلاتر نشطة'**
  String get activeFilters;

  /// No description provided for @actionPairInviteCreated.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء دعوة ربط'**
  String get actionPairInviteCreated;

  /// No description provided for @actionPairInviteAccepted.
  ///
  /// In ar, this message translates to:
  /// **'قبول دعوة ربط'**
  String get actionPairInviteAccepted;

  /// No description provided for @actionShareSessionCreated.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء جلسة مشاركة'**
  String get actionShareSessionCreated;

  /// No description provided for @actionShareSessionRevoked.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء جلسة مشاركة'**
  String get actionShareSessionRevoked;

  /// No description provided for @actionShareSessionViewed.
  ///
  /// In ar, this message translates to:
  /// **'عرض جلسة مشاركة'**
  String get actionShareSessionViewed;

  /// No description provided for @actionPdfGenerated.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء PDF'**
  String get actionPdfGenerated;

  /// No description provided for @actionEscalationSent.
  ///
  /// In ar, this message translates to:
  /// **'إرسال تصعيد'**
  String get actionEscalationSent;

  /// No description provided for @actionAdminExport.
  ///
  /// In ar, this message translates to:
  /// **'تصدير إداري'**
  String get actionAdminExport;

  /// No description provided for @actionAdminBanUser.
  ///
  /// In ar, this message translates to:
  /// **'حظر مستخدم'**
  String get actionAdminBanUser;

  /// No description provided for @actionAdminUnbanUser.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء حظر مستخدم'**
  String get actionAdminUnbanUser;

  /// No description provided for @actionProfileCreated.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء ملف'**
  String get actionProfileCreated;

  /// No description provided for @actionProfileUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تعديل ملف'**
  String get actionProfileUpdated;

  /// No description provided for @actionProfileDeleted.
  ///
  /// In ar, this message translates to:
  /// **'حذف ملف'**
  String get actionProfileDeleted;

  /// No description provided for @actionMedicationCreated.
  ///
  /// In ar, this message translates to:
  /// **'إضافة دواء'**
  String get actionMedicationCreated;

  /// No description provided for @actionMedicationUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تعديل دواء'**
  String get actionMedicationUpdated;

  /// No description provided for @actionMedicationDeleted.
  ///
  /// In ar, this message translates to:
  /// **'حذف دواء'**
  String get actionMedicationDeleted;

  /// No description provided for @actionCaregiverAdded.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مقدم رعاية'**
  String get actionCaregiverAdded;

  /// No description provided for @actionCaregiverRemoved.
  ///
  /// In ar, this message translates to:
  /// **'إزالة مقدم رعاية'**
  String get actionCaregiverRemoved;

  /// No description provided for @actionViewAnalytics.
  ///
  /// In ar, this message translates to:
  /// **'عرض الإحصائيات'**
  String get actionViewAnalytics;

  /// No description provided for @auditLogDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل السجل'**
  String get auditLogDetails;

  /// No description provided for @actor.
  ///
  /// In ar, this message translates to:
  /// **'المنفذ'**
  String get actor;

  /// No description provided for @targetProfile.
  ///
  /// In ar, this message translates to:
  /// **'الملف المستهدف'**
  String get targetProfile;

  /// No description provided for @timestamp.
  ///
  /// In ar, this message translates to:
  /// **'الوقت'**
  String get timestamp;

  /// No description provided for @metadata.
  ///
  /// In ar, this message translates to:
  /// **'البيانات التفصيلية'**
  String get metadata;

  /// No description provided for @noLogsFound.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على سجلات'**
  String get noLogsFound;

  /// No description provided for @pageOf.
  ///
  /// In ar, this message translates to:
  /// **'صفحة {current} من {total}'**
  String pageOf(int current, int total);

  /// No description provided for @previousPage.
  ///
  /// In ar, this message translates to:
  /// **'السابق'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get nextPage;

  /// No description provided for @perPage.
  ///
  /// In ar, this message translates to:
  /// **'{count} لكل صفحة'**
  String perPage(int count);

  /// No description provided for @clearPhoto.
  ///
  /// In ar, this message translates to:
  /// **'مسح'**
  String get clearPhoto;

  /// No description provided for @replacePhoto.
  ///
  /// In ar, this message translates to:
  /// **'استبدال'**
  String get replacePhoto;

  /// No description provided for @confirmDeleteMedication.
  ///
  /// In ar, this message translates to:
  /// **'حذف الدواء'**
  String get confirmDeleteMedication;

  /// No description provided for @deleteWarning.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن التراجع عن هذا الإجراء.'**
  String get deleteWarning;

  /// No description provided for @dateFrom.
  ///
  /// In ar, this message translates to:
  /// **'من'**
  String get dateFrom;

  /// No description provided for @dateTo.
  ///
  /// In ar, this message translates to:
  /// **'إلى'**
  String get dateTo;

  /// No description provided for @selectDateRange.
  ///
  /// In ar, this message translates to:
  /// **'اختر نطاق التاريخ'**
  String get selectDateRange;

  /// No description provided for @applyFilter.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق'**
  String get applyFilter;

  /// No description provided for @noPreAlert.
  ///
  /// In ar, this message translates to:
  /// **'بدون تنبيه مسبق'**
  String get noPreAlert;

  /// No description provided for @removeTime.
  ///
  /// In ar, this message translates to:
  /// **'إزالة الوقت'**
  String get removeTime;

  /// No description provided for @searchMedications.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن دواء...'**
  String get searchMedications;

  /// No description provided for @filterByProfile.
  ///
  /// In ar, this message translates to:
  /// **'تصفية حسب الملف'**
  String get filterByProfile;

  /// No description provided for @filterByStatus.
  ///
  /// In ar, this message translates to:
  /// **'تصفية حسب الحالة'**
  String get filterByStatus;

  /// No description provided for @allProfiles.
  ///
  /// In ar, this message translates to:
  /// **'جميع الملفات'**
  String get allProfiles;

  /// No description provided for @allStatuses.
  ///
  /// In ar, this message translates to:
  /// **'جميع الحالات'**
  String get allStatuses;

  /// No description provided for @userCreatedAt.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ إنشاء الحساب'**
  String get userCreatedAt;

  /// No description provided for @profilesOwned.
  ///
  /// In ar, this message translates to:
  /// **'الملفات المملوكة'**
  String get profilesOwned;

  /// No description provided for @banned.
  ///
  /// In ar, this message translates to:
  /// **'محظور'**
  String get banned;

  /// No description provided for @active.
  ///
  /// In ar, this message translates to:
  /// **'نشط'**
  String get active;

  /// No description provided for @errorEmailRequired.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني مطلوب'**
  String get errorEmailRequired;

  /// No description provided for @errorEmailInvalid.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني غير صالح'**
  String get errorEmailInvalid;

  /// No description provided for @errorPasswordRequired.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور مطلوبة'**
  String get errorPasswordRequired;

  /// No description provided for @errorPasswordTooShort.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور قصيرة جداً'**
  String get errorPasswordTooShort;

  /// No description provided for @errorConfirmPasswordRequired.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور مطلوب'**
  String get errorConfirmPasswordRequired;

  /// No description provided for @errorPasswordsDoNotMatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمتا المرور غير متطابقتين'**
  String get errorPasswordsDoNotMatch;

  /// No description provided for @errorPinRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرمز السري مطلوب'**
  String get errorPinRequired;

  /// No description provided for @errorPinInvalidLength.
  ///
  /// In ar, this message translates to:
  /// **'الرمز السري يجب أن يكون 4 أرقام'**
  String get errorPinInvalidLength;

  /// No description provided for @errorPinDigitsOnly.
  ///
  /// In ar, this message translates to:
  /// **'الرمز السري يجب أن يحتوي على أرقام فقط'**
  String get errorPinDigitsOnly;

  /// No description provided for @errorPhoneRequired.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف مطلوب'**
  String get errorPhoneRequired;

  /// No description provided for @errorPhoneInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف غير صالح'**
  String get errorPhoneInvalid;

  /// No description provided for @errorRequired.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get errorRequired;

  /// No description provided for @errorFieldRequired.
  ///
  /// In ar, this message translates to:
  /// **'{field} مطلوب'**
  String errorFieldRequired(String field);

  /// No description provided for @errorMedNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء مطلوب'**
  String get errorMedNameRequired;

  /// No description provided for @errorMedNameTooShort.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء قصير جداً'**
  String get errorMedNameTooShort;

  /// No description provided for @errorMedNameTooLong.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء طويل جداً'**
  String get errorMedNameTooLong;

  /// No description provided for @errorPairCodeRequired.
  ///
  /// In ar, this message translates to:
  /// **'رمز الاقتران مطلوب'**
  String get errorPairCodeRequired;

  /// No description provided for @errorPairCodeInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رمز الاقتران غير صالح'**
  String get errorPairCodeInvalid;

  /// No description provided for @errorEveryXHoursRequired.
  ///
  /// In ar, this message translates to:
  /// **'عدد الساعات مطلوب'**
  String get errorEveryXHoursRequired;

  /// No description provided for @errorEveryXHoursInvalid.
  ///
  /// In ar, this message translates to:
  /// **'عدد الساعات غير صالح'**
  String get errorEveryXHoursInvalid;

  /// No description provided for @errorProfileNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'اسم الملف مطلوب'**
  String get errorProfileNameRequired;

  /// No description provided for @errorProfileNameTooShort.
  ///
  /// In ar, this message translates to:
  /// **'اسم الملف قصير جداً'**
  String get errorProfileNameTooShort;

  /// No description provided for @errorProfileNameTooLong.
  ///
  /// In ar, this message translates to:
  /// **'اسم الملف طويل جداً'**
  String get errorProfileNameTooLong;

  /// No description provided for @errorScheduleTimesRequired.
  ///
  /// In ar, this message translates to:
  /// **'أوقات الجدول مطلوبة'**
  String get errorScheduleTimesRequired;

  /// No description provided for @errorScheduleTimesDuplicate.
  ///
  /// In ar, this message translates to:
  /// **'توجد أوقات مكررة'**
  String get errorScheduleTimesDuplicate;

  /// No description provided for @errorScheduleTimesTooMany.
  ///
  /// In ar, this message translates to:
  /// **'عدد الأوقات كبير جداً'**
  String get errorScheduleTimesTooMany;

  /// No description provided for @errorShareExpiryRequired.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الانتهاء مطلوب'**
  String get errorShareExpiryRequired;

  /// No description provided for @errorShareExpiryInvalid.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الانتهاء غير صالح'**
  String get errorShareExpiryInvalid;

  /// No description provided for @errorTimeRequired.
  ///
  /// In ar, this message translates to:
  /// **'الوقت مطلوب'**
  String get errorTimeRequired;

  /// No description provided for @errorTimeInvalid.
  ///
  /// In ar, this message translates to:
  /// **'الوقت غير صالح'**
  String get errorTimeInvalid;

  /// No description provided for @errorTimezoneRequired.
  ///
  /// In ar, this message translates to:
  /// **'المنطقة الزمنية مطلوبة'**
  String get errorTimezoneRequired;

  /// No description provided for @errorTimezoneInvalid.
  ///
  /// In ar, this message translates to:
  /// **'المنطقة الزمنية غير صالحة'**
  String get errorTimezoneInvalid;

  /// No description provided for @todaysSchedule.
  ///
  /// In ar, this message translates to:
  /// **'جدول اليوم'**
  String get todaysSchedule;

  /// No description provided for @noMedicationsYet.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أدوية بعد'**
  String get noMedicationsYet;

  /// No description provided for @addFirstMedication.
  ///
  /// In ar, this message translates to:
  /// **'أضف أول دواء'**
  String get addFirstMedication;

  /// No description provided for @pendingSync.
  ///
  /// In ar, this message translates to:
  /// **'في انتظار المزامنة'**
  String get pendingSync;

  /// No description provided for @syncStateProvider.
  ///
  /// In ar, this message translates to:
  /// **'حالة المزامنة'**
  String get syncStateProvider;

  /// No description provided for @pleaseSelectProfile.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار ملف شخصي'**
  String get pleaseSelectProfile;

  /// No description provided for @upgrade.
  ///
  /// In ar, this message translates to:
  /// **'ترقية'**
  String get upgrade;

  /// No description provided for @medicationAdded.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة الدواء'**
  String get medicationAdded;

  /// No description provided for @errorAddingMedication.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في إضافة الدواء'**
  String get errorAddingMedication;

  /// No description provided for @basicInfo.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الأساسية'**
  String get basicInfo;

  /// No description provided for @photos.
  ///
  /// In ar, this message translates to:
  /// **'الصور'**
  String get photos;

  /// No description provided for @medicationDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الدواء'**
  String get medicationDetails;

  /// No description provided for @medicationNameHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم الدواء'**
  String get medicationNameHint;

  /// No description provided for @medicationNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء مطلوب'**
  String get medicationNameRequired;

  /// No description provided for @medicationNameTooShort.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء قصير جداً'**
  String get medicationNameTooShort;

  /// No description provided for @medicationNameTooLong.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء طويل جداً'**
  String get medicationNameTooLong;

  /// No description provided for @addPhotos.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صور'**
  String get addPhotos;

  /// No description provided for @photosHelp.
  ///
  /// In ar, this message translates to:
  /// **'أضف صور للدواء للتعرف عليه بسهولة'**
  String get photosHelp;

  /// No description provided for @visualTagsHelp.
  ///
  /// In ar, this message translates to:
  /// **'أضف علامات مرئية للدواء'**
  String get visualTagsHelp;

  /// No description provided for @noProfileSelected.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم اختيار ملف'**
  String get noProfileSelected;

  /// No description provided for @noProfiles.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد ملفات'**
  String get noProfiles;

  /// No description provided for @noProfilesDescription.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ ملفاً شخصياً للبدء'**
  String get noProfilesDescription;

  /// No description provided for @createProfile.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء ملف'**
  String get createProfile;

  /// No description provided for @profileCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الملف'**
  String get profileCreated;

  /// No description provided for @profileNameHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم الملف'**
  String get profileNameHint;

  /// No description provided for @profileType.
  ///
  /// In ar, this message translates to:
  /// **'نوع الملف'**
  String get profileType;

  /// No description provided for @profileSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الملف'**
  String get profileSettings;

  /// No description provided for @managedProfile.
  ///
  /// In ar, this message translates to:
  /// **'ملف مُدار'**
  String get managedProfile;

  /// No description provided for @managedProfileDescription.
  ///
  /// In ar, this message translates to:
  /// **'ملف شخص تعتني به'**
  String get managedProfileDescription;

  /// No description provided for @linkedProfile.
  ///
  /// In ar, this message translates to:
  /// **'ملف مرتبط'**
  String get linkedProfile;

  /// No description provided for @linkedProfileDescription.
  ///
  /// In ar, this message translates to:
  /// **'ملف شخص يعتني بك'**
  String get linkedProfileDescription;

  /// No description provided for @linkedProfileDisclaimer.
  ///
  /// In ar, this message translates to:
  /// **'سيتمكن هذا الشخص من رؤية أدويتك'**
  String get linkedProfileDisclaimer;

  /// No description provided for @linkWithCaregiver.
  ///
  /// In ar, this message translates to:
  /// **'ربط مع مقدم رعاية'**
  String get linkWithCaregiver;

  /// No description provided for @linkingWithCaregiver.
  ///
  /// In ar, this message translates to:
  /// **'جاري الربط...'**
  String get linkingWithCaregiver;

  /// No description provided for @linkedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم الربط بنجاح'**
  String get linkedSuccessfully;

  /// No description provided for @linkedSuccessfullyDescription.
  ///
  /// In ar, this message translates to:
  /// **'تم ربط الملف بنجاح'**
  String get linkedSuccessfullyDescription;

  /// No description provided for @acceptAndLink.
  ///
  /// In ar, this message translates to:
  /// **'قبول وربط'**
  String get acceptAndLink;

  /// No description provided for @permissions.
  ///
  /// In ar, this message translates to:
  /// **'الصلاحيات'**
  String get permissions;

  /// No description provided for @choosePermissions.
  ///
  /// In ar, this message translates to:
  /// **'اختر الصلاحيات'**
  String get choosePermissions;

  /// No description provided for @canChangePermissionsLater.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك تغيير الصلاحيات لاحقاً'**
  String get canChangePermissionsLater;

  /// No description provided for @medicationsOnly.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية فقط'**
  String get medicationsOnly;

  /// No description provided for @medicationsOnlyDescription.
  ///
  /// In ar, this message translates to:
  /// **'عرض الأدوية فقط'**
  String get medicationsOnlyDescription;

  /// No description provided for @medicationsAndLog.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية والسجل'**
  String get medicationsAndLog;

  /// No description provided for @medicationsAndLogDescription.
  ///
  /// In ar, this message translates to:
  /// **'عرض الأدوية وسجل الالتزام'**
  String get medicationsAndLogDescription;

  /// No description provided for @manageMediactions.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الأدوية'**
  String get manageMediactions;

  /// No description provided for @manageMedicationsDescription.
  ///
  /// In ar, this message translates to:
  /// **'إضافة وتعديل الأدوية'**
  String get manageMedicationsDescription;

  /// No description provided for @receiveAlerts.
  ///
  /// In ar, this message translates to:
  /// **'استلام التنبيهات'**
  String get receiveAlerts;

  /// No description provided for @receiveAlertsDescription.
  ///
  /// In ar, this message translates to:
  /// **'استلام تنبيهات عند تفويت جرعة'**
  String get receiveAlertsDescription;

  /// No description provided for @viewAdherenceLog.
  ///
  /// In ar, this message translates to:
  /// **'عرض سجل الالتزام'**
  String get viewAdherenceLog;

  /// No description provided for @viewAdherenceLogDescription.
  ///
  /// In ar, this message translates to:
  /// **'عرض تاريخ تناول الأدوية'**
  String get viewAdherenceLogDescription;

  /// No description provided for @shareQr.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة QR'**
  String get shareQr;

  /// No description provided for @shareQrDescription.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة رمز QR للربط'**
  String get shareQrDescription;

  /// No description provided for @generateQrCode.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء رمز QR'**
  String get generateQrCode;

  /// No description provided for @qrShareDisclaimer.
  ///
  /// In ar, this message translates to:
  /// **'شارك هذا الرمز مع مقدم الرعاية'**
  String get qrShareDisclaimer;

  /// No description provided for @qrStep1.
  ///
  /// In ar, this message translates to:
  /// **'افتح التطبيق على جهاز مقدم الرعاية'**
  String get qrStep1;

  /// No description provided for @qrStep2.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على إضافة ملف مرتبط'**
  String get qrStep2;

  /// No description provided for @qrStep3.
  ///
  /// In ar, this message translates to:
  /// **'امسح رمز QR'**
  String get qrStep3;

  /// No description provided for @qrStep4.
  ///
  /// In ar, this message translates to:
  /// **'اقبل طلب الربط'**
  String get qrStep4;

  /// No description provided for @howItWorks.
  ///
  /// In ar, this message translates to:
  /// **'كيف يعمل'**
  String get howItWorks;

  /// No description provided for @copyLink.
  ///
  /// In ar, this message translates to:
  /// **'نسخ الرابط'**
  String get copyLink;

  /// No description provided for @linkCopied.
  ///
  /// In ar, this message translates to:
  /// **'تم نسخ الرابط'**
  String get linkCopied;

  /// No description provided for @shareOptions.
  ///
  /// In ar, this message translates to:
  /// **'خيارات المشاركة'**
  String get shareOptions;

  /// No description provided for @expiresIn.
  ///
  /// In ar, this message translates to:
  /// **'ينتهي في'**
  String get expiresIn;

  /// No description provided for @inviteCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الدعوة'**
  String get inviteCreated;

  /// No description provided for @inviteExpiresIn72Hours.
  ///
  /// In ar, this message translates to:
  /// **'تنتهي الدعوة خلال 72 ساعة'**
  String get inviteExpiresIn72Hours;

  /// No description provided for @inviteInstructions.
  ///
  /// In ar, this message translates to:
  /// **'أرسل هذا الرابط لمقدم الرعاية'**
  String get inviteInstructions;

  /// No description provided for @sendInvite.
  ///
  /// In ar, this message translates to:
  /// **'إرسال دعوة'**
  String get sendInvite;

  /// No description provided for @revoke.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get revoke;

  /// No description provided for @shareSessionRevoked.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء جلسة المشاركة'**
  String get shareSessionRevoked;

  /// No description provided for @sharing.
  ///
  /// In ar, this message translates to:
  /// **'المشاركة'**
  String get sharing;

  /// No description provided for @whatToShare.
  ///
  /// In ar, this message translates to:
  /// **'ماذا تريد مشاركته'**
  String get whatToShare;

  /// No description provided for @shareWithDoctorDescription.
  ///
  /// In ar, this message translates to:
  /// **'شارك معلوماتك مع طبيبك'**
  String get shareWithDoctorDescription;

  /// No description provided for @doctorVisitDescription.
  ///
  /// In ar, this message translates to:
  /// **'معلومات لزيارة الطبيب'**
  String get doctorVisitDescription;

  /// No description provided for @exportPdf.
  ///
  /// In ar, this message translates to:
  /// **'تصدير PDF'**
  String get exportPdf;

  /// No description provided for @generatingPdf.
  ///
  /// In ar, this message translates to:
  /// **'جاري إنشاء PDF...'**
  String get generatingPdf;

  /// No description provided for @pdfGenerated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء PDF'**
  String get pdfGenerated;

  /// No description provided for @download.
  ///
  /// In ar, this message translates to:
  /// **'تحميل'**
  String get download;

  /// No description provided for @enterPairCodeDescription.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز الاقتران'**
  String get enterPairCodeDescription;

  /// No description provided for @whereToFindCode.
  ///
  /// In ar, this message translates to:
  /// **'أين أجد الرمز؟'**
  String get whereToFindCode;

  /// No description provided for @whereToFindCodeDescription.
  ///
  /// In ar, this message translates to:
  /// **'اطلب الرمز من الشخص الذي تريد الربط معه'**
  String get whereToFindCodeDescription;

  /// No description provided for @caregiverConsentDisclaimer.
  ///
  /// In ar, this message translates to:
  /// **'بالموافقة، ستتمكن من رؤية أدوية هذا الشخص'**
  String get caregiverConsentDisclaimer;

  /// No description provided for @verify.
  ///
  /// In ar, this message translates to:
  /// **'تحقق'**
  String get verify;

  /// No description provided for @processing.
  ///
  /// In ar, this message translates to:
  /// **'جاري المعالجة...'**
  String get processing;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @daily.
  ///
  /// In ar, this message translates to:
  /// **'يومي'**
  String get daily;

  /// No description provided for @specificDays.
  ///
  /// In ar, this message translates to:
  /// **'أيام محددة'**
  String get specificDays;

  /// No description provided for @interval.
  ///
  /// In ar, this message translates to:
  /// **'فترة زمنية'**
  String get interval;

  /// No description provided for @repeatEvery.
  ///
  /// In ar, this message translates to:
  /// **'تكرار كل'**
  String get repeatEvery;

  /// No description provided for @hour.
  ///
  /// In ar, this message translates to:
  /// **'ساعة'**
  String get hour;

  /// No description provided for @hours.
  ///
  /// In ar, this message translates to:
  /// **'ساعات'**
  String get hours;

  /// No description provided for @times.
  ///
  /// In ar, this message translates to:
  /// **'مرات'**
  String get times;

  /// No description provided for @atLeastOneTime.
  ///
  /// In ar, this message translates to:
  /// **'وقت واحد على الأقل'**
  String get atLeastOneTime;

  /// No description provided for @before.
  ///
  /// In ar, this message translates to:
  /// **'قبل'**
  String get before;

  /// No description provided for @dateRange.
  ///
  /// In ar, this message translates to:
  /// **'نطاق التاريخ'**
  String get dateRange;

  /// No description provided for @filters.
  ///
  /// In ar, this message translates to:
  /// **'الفلاتر'**
  String get filters;

  /// No description provided for @applyFilters.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق الفلاتر'**
  String get applyFilters;

  /// No description provided for @filtersApplied.
  ///
  /// In ar, this message translates to:
  /// **'تم تطبيق الفلاتر'**
  String get filtersApplied;

  /// No description provided for @clear.
  ///
  /// In ar, this message translates to:
  /// **'مسح'**
  String get clear;

  /// No description provided for @clearAll.
  ///
  /// In ar, this message translates to:
  /// **'مسح الكل'**
  String get clearAll;

  /// No description provided for @eventType.
  ///
  /// In ar, this message translates to:
  /// **'نوع الحدث'**
  String get eventType;

  /// No description provided for @skipped.
  ///
  /// In ar, this message translates to:
  /// **'تم تخطيه'**
  String get skipped;

  /// No description provided for @snoozed.
  ///
  /// In ar, this message translates to:
  /// **'تم تأجيله'**
  String get snoozed;

  /// No description provided for @snoozedFor.
  ///
  /// In ar, this message translates to:
  /// **'مؤجل لـ'**
  String get snoozedFor;

  /// No description provided for @snoozeFor.
  ///
  /// In ar, this message translates to:
  /// **'تأجيل لـ'**
  String get snoozeFor;

  /// No description provided for @yesterday.
  ///
  /// In ar, this message translates to:
  /// **'أمس'**
  String get yesterday;

  /// No description provided for @other.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get other;

  /// No description provided for @noEventsFound.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أحداث'**
  String get noEventsFound;

  /// No description provided for @adherenceLog.
  ///
  /// In ar, this message translates to:
  /// **'سجل الالتزام'**
  String get adherenceLog;

  /// No description provided for @errorLoadingData.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل البيانات'**
  String get errorLoadingData;

  /// No description provided for @errorLoadingMedications.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل الأدوية'**
  String get errorLoadingMedications;

  /// No description provided for @errorLoadingProfiles.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل الملفات'**
  String get errorLoadingProfiles;

  /// No description provided for @noActiveMedications.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أدوية نشطة'**
  String get noActiveMedications;

  /// No description provided for @noArchivedMedications.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أدوية مؤرشفة'**
  String get noArchivedMedications;

  /// No description provided for @noPausedMedications.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أدوية موقوفة'**
  String get noPausedMedications;

  /// No description provided for @noDosesScheduled.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد جرعات مجدولة'**
  String get noDosesScheduled;

  /// No description provided for @allDoneForToday.
  ///
  /// In ar, this message translates to:
  /// **'انتهيت من كل شيء اليوم'**
  String get allDoneForToday;

  /// No description provided for @doseTakenSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الجرعة'**
  String get doseTakenSuccess;

  /// No description provided for @doseSkipped.
  ///
  /// In ar, this message translates to:
  /// **'تم تخطي الجرعة'**
  String get doseSkipped;

  /// No description provided for @pause.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف'**
  String get pause;

  /// No description provided for @paused.
  ///
  /// In ar, this message translates to:
  /// **'موقوف'**
  String get paused;

  /// No description provided for @resume.
  ///
  /// In ar, this message translates to:
  /// **'استئناف'**
  String get resume;

  /// No description provided for @archived.
  ///
  /// In ar, this message translates to:
  /// **'مؤرشف'**
  String get archived;

  /// No description provided for @deleteMedication.
  ///
  /// In ar, this message translates to:
  /// **'حذف الدواء'**
  String get deleteMedication;

  /// No description provided for @medication.
  ///
  /// In ar, this message translates to:
  /// **'دواء'**
  String get medication;

  /// No description provided for @traveling.
  ///
  /// In ar, this message translates to:
  /// **'مسافر'**
  String get traveling;

  /// No description provided for @notAvailable.
  ///
  /// In ar, this message translates to:
  /// **'غير متوفر'**
  String get notAvailable;

  /// No description provided for @account.
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get account;

  /// No description provided for @appSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات التطبيق'**
  String get appSettings;

  /// No description provided for @pinSecurity.
  ///
  /// In ar, this message translates to:
  /// **'أمان الرمز السري'**
  String get pinSecurity;

  /// No description provided for @setUpPin.
  ///
  /// In ar, this message translates to:
  /// **'إعداد رمز سري'**
  String get setUpPin;

  /// No description provided for @createPin.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء رمز سري'**
  String get createPin;

  /// No description provided for @createPinSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ رمزاً سرياً من 4 أرقام'**
  String get createPinSubtitle;

  /// No description provided for @confirmPinSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أعد إدخال الرمز السري'**
  String get confirmPinSubtitle;

  /// No description provided for @enterPinSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرمز السري'**
  String get enterPinSubtitle;

  /// No description provided for @removePin.
  ///
  /// In ar, this message translates to:
  /// **'إزالة الرمز السري'**
  String get removePin;

  /// No description provided for @pinRemoved.
  ///
  /// In ar, this message translates to:
  /// **'تم إزالة الرمز السري'**
  String get pinRemoved;

  /// No description provided for @pinsDoNotMatch.
  ///
  /// In ar, this message translates to:
  /// **'الرمزان غير متطابقين'**
  String get pinsDoNotMatch;

  /// No description provided for @incorrectPin.
  ///
  /// In ar, this message translates to:
  /// **'رمز سري غير صحيح'**
  String get incorrectPin;

  /// No description provided for @errorSavingPin.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في حفظ الرمز السري'**
  String get errorSavingPin;

  /// No description provided for @biometricUnlock.
  ///
  /// In ar, this message translates to:
  /// **'فتح ببصمة الإصبع'**
  String get biometricUnlock;

  /// No description provided for @helpSupport.
  ///
  /// In ar, this message translates to:
  /// **'المساعدة والدعم'**
  String get helpSupport;

  /// No description provided for @faq.
  ///
  /// In ar, this message translates to:
  /// **'الأسئلة الشائعة'**
  String get faq;

  /// No description provided for @faq1Question.
  ///
  /// In ar, this message translates to:
  /// **'كيف أضيف دواء؟'**
  String get faq1Question;

  /// No description provided for @faq1Answer.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على زر + في الشاشة الرئيسية'**
  String get faq1Answer;

  /// No description provided for @faq2Question.
  ///
  /// In ar, this message translates to:
  /// **'كيف أربط مع مقدم رعاية؟'**
  String get faq2Question;

  /// No description provided for @faq2Answer.
  ///
  /// In ar, this message translates to:
  /// **'اذهب إلى الملفات واختر مشاركة QR'**
  String get faq2Answer;

  /// No description provided for @faq3Question.
  ///
  /// In ar, this message translates to:
  /// **'كيف أصدر تقريراً؟'**
  String get faq3Question;

  /// No description provided for @faq3Answer.
  ///
  /// In ar, this message translates to:
  /// **'اذهب إلى زيارة الطبيب واختر تصدير PDF'**
  String get faq3Answer;

  /// No description provided for @logoutConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد تسجيل الخروج؟'**
  String get logoutConfirm;

  /// No description provided for @forgot.
  ///
  /// In ar, this message translates to:
  /// **'نسيت؟'**
  String get forgot;

  /// No description provided for @goToApp.
  ///
  /// In ar, this message translates to:
  /// **'الذهاب للتطبيق'**
  String get goToApp;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'الملف'**
  String get profile;

  /// No description provided for @feature.
  ///
  /// In ar, this message translates to:
  /// **'ميزة'**
  String get feature;

  /// No description provided for @free.
  ///
  /// In ar, this message translates to:
  /// **'مجاني'**
  String get free;

  /// No description provided for @unlimited.
  ///
  /// In ar, this message translates to:
  /// **'غير محدود'**
  String get unlimited;

  /// No description provided for @recommended.
  ///
  /// In ar, this message translates to:
  /// **'موصى به'**
  String get recommended;

  /// No description provided for @proPrice.
  ///
  /// In ar, this message translates to:
  /// **'٩٩ ريال/سنة'**
  String get proPrice;

  /// No description provided for @youAreOnFree.
  ///
  /// In ar, this message translates to:
  /// **'أنت على الخطة المجانية'**
  String get youAreOnFree;

  /// No description provided for @youAreOnPro.
  ///
  /// In ar, this message translates to:
  /// **'أنت على خطة Pro'**
  String get youAreOnPro;

  /// No description provided for @upgradeRequired.
  ///
  /// In ar, this message translates to:
  /// **'الترقية مطلوبة'**
  String get upgradeRequired;

  /// No description provided for @upgradeToAddMoreProfiles.
  ///
  /// In ar, this message translates to:
  /// **'قم بالترقية لإضافة المزيد من الملفات'**
  String get upgradeToAddMoreProfiles;

  /// No description provided for @upgradeConfirmation.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد الترقية؟'**
  String get upgradeConfirmation;

  /// No description provided for @upgradeSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تمت الترقية بنجاح'**
  String get upgradeSuccess;

  /// No description provided for @paymentNote.
  ///
  /// In ar, this message translates to:
  /// **'سيتم الدفع عبر المتجر'**
  String get paymentNote;

  /// No description provided for @freeFeature1.
  ///
  /// In ar, this message translates to:
  /// **'ملف واحد'**
  String get freeFeature1;

  /// No description provided for @freeFeature1Unlimited.
  ///
  /// In ar, this message translates to:
  /// **'ملفات غير محدودة'**
  String get freeFeature1Unlimited;

  /// No description provided for @freeFeature2.
  ///
  /// In ar, this message translates to:
  /// **'5 أدوية'**
  String get freeFeature2;

  /// No description provided for @freeFeature2Unlimited.
  ///
  /// In ar, this message translates to:
  /// **'أدوية غير محدودة'**
  String get freeFeature2Unlimited;

  /// No description provided for @freeFeature3.
  ///
  /// In ar, this message translates to:
  /// **'تذكيرات أساسية'**
  String get freeFeature3;

  /// No description provided for @freeFeature4.
  ///
  /// In ar, this message translates to:
  /// **'سجل 7 أيام'**
  String get freeFeature4;

  /// No description provided for @proFeature1.
  ///
  /// In ar, this message translates to:
  /// **'ملفات غير محدودة'**
  String get proFeature1;

  /// No description provided for @proFeature2.
  ///
  /// In ar, this message translates to:
  /// **'أدوية غير محدودة'**
  String get proFeature2;

  /// No description provided for @proFeature3.
  ///
  /// In ar, this message translates to:
  /// **'تصدير PDF'**
  String get proFeature3;

  /// No description provided for @proFeature4.
  ///
  /// In ar, this message translates to:
  /// **'سجل كامل'**
  String get proFeature4;

  /// No description provided for @featureComparison.
  ///
  /// In ar, this message translates to:
  /// **'مقارنة الميزات'**
  String get featureComparison;

  /// No description provided for @featureMedications.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية'**
  String get featureMedications;

  /// No description provided for @featureProfiles.
  ///
  /// In ar, this message translates to:
  /// **'الملفات'**
  String get featureProfiles;

  /// No description provided for @featureReminders.
  ///
  /// In ar, this message translates to:
  /// **'التذكيرات'**
  String get featureReminders;

  /// No description provided for @featureAdherenceLog.
  ///
  /// In ar, this message translates to:
  /// **'سجل الالتزام'**
  String get featureAdherenceLog;

  /// No description provided for @featurePdfExport.
  ///
  /// In ar, this message translates to:
  /// **'تصدير PDF'**
  String get featurePdfExport;

  /// No description provided for @featureQrShare.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة QR'**
  String get featureQrShare;

  /// No description provided for @featureAdvancedSummaries.
  ///
  /// In ar, this message translates to:
  /// **'ملخصات متقدمة'**
  String get featureAdvancedSummaries;

  /// No description provided for @featureCaregiverEscalation.
  ///
  /// In ar, this message translates to:
  /// **'تصعيد لمقدم الرعاية'**
  String get featureCaregiverEscalation;

  /// No description provided for @noNotificationsDescription.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات'**
  String get noNotificationsDescription;

  /// No description provided for @markAllRead.
  ///
  /// In ar, this message translates to:
  /// **'تعليم الكل كمقروء'**
  String get markAllRead;

  /// No description provided for @allNotificationsMarkedRead.
  ///
  /// In ar, this message translates to:
  /// **'تم تعليم كل الإشعارات كمقروءة'**
  String get allNotificationsMarkedRead;

  /// No description provided for @patientPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف المريض'**
  String get patientPhone;

  /// No description provided for @patientPhoneHelper.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم الهاتف'**
  String get patientPhoneHelper;

  /// No description provided for @phoneRequired.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف مطلوب'**
  String get phoneRequired;

  /// No description provided for @invalidPhoneFormat.
  ///
  /// In ar, this message translates to:
  /// **'صيغة الهاتف غير صحيحة'**
  String get invalidPhoneFormat;

  /// No description provided for @nameTooShort.
  ///
  /// In ar, this message translates to:
  /// **'الاسم قصير جداً'**
  String get nameTooShort;

  /// No description provided for @paste.
  ///
  /// In ar, this message translates to:
  /// **'لصق'**
  String get paste;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
