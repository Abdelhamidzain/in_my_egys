import 'package:flutter/foundation.dart';

enum MedicationStatus {
  active('ACTIVE'),
  paused('PAUSED'),
  discontinued('DISCONTINUED');

  const MedicationStatus(this.value);
  final String value;

  static MedicationStatus fromString(String? value) {
    if (value == null) return MedicationStatus.active;
    return MedicationStatus.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => MedicationStatus.active,
    );
  }
}

enum MedType {
  pill('pill', 'حبة', 'Pill', '💊'),
  capsule('capsule', 'كبسولة', 'Capsule', '💊'),
  injection('injection', 'حقنة', 'Injection', '💉'),
  liquid('liquid', 'سائل', 'Liquid', '🧴'),
  drops('drops', 'قطرة', 'Drops', '💧'),
  cream('cream', 'كريم', 'Cream', '🧴'),
  inhaler('inhaler', 'بخاخ', 'Inhaler', '🌬️'),
  patch('patch', 'لصقة', 'Patch', '🩹');

  const MedType(this.value, this.labelAr, this.labelEn, this.emoji);
  final String value;
  final String labelAr;
  final String labelEn;
  final String emoji;

  String getLabel(String lang) => lang == 'ar' ? labelAr : labelEn;

  static MedType fromString(String? value) {
    if (value == null) return MedType.pill;
    return MedType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => MedType.pill,
    );
  }
}

enum VisualTag {
  pink('PINK', 'وردي', 'Pink'),
  green('GREEN', 'أخضر', 'Green'),
  blue('BLUE', 'أزرق', 'Blue'),
  red('RED', 'أحمر', 'Red'),
  yellow('YELLOW', 'أصفر', 'Yellow'),
  white('WHITE', 'أبيض', 'White'),
  orange('ORANGE', 'برتقالي', 'Orange'),
  small('SMALL', 'صغير', 'Small'),
  large('LARGE', 'كبير', 'Large'),
  oval('OVAL', 'بيضاوي', 'Oval'),
  round('ROUND', 'دائري', 'Round');

  const VisualTag(this.value, this.labelAr, this.labelEn);
  final String value;
  final String labelAr;
  final String labelEn;

  String getLabel(String lang) => lang == 'ar' ? labelAr : labelEn;

  static VisualTag fromString(String value) {
    return VisualTag.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => VisualTag.white,
    );
  }
}

@immutable
class Medication {
  const Medication({
    required this.id,
    required this.profileId,
    required this.name,
    this.medType = MedType.pill,
    this.instructionsText,
    this.dosageAmount = 1,
    this.dosageUnit = 'pill',
    this.remainingQuantity,
    this.photoUrl,
    this.pillPhotoPath,
    this.boxPhotoPath,
    this.visualTags = const [],
    this.status = MedicationStatus.active,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String profileId;
  final String name;
  final MedType medType;
  final String? instructionsText;
  final double dosageAmount;
  final String dosageUnit;
  final int? remainingQuantity;
  final String? photoUrl;
  final String? pillPhotoPath;
  final String? boxPhotoPath;
  final List<VisualTag> visualTags;
  final MedicationStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  bool get isActive => status == MedicationStatus.active;
  bool get hasPhoto => photoUrl != null || pillPhotoPath != null;

  factory Medication.fromJson(Map<String, dynamic> json) {
    List<VisualTag> tags = [];
    if (json['visual_tags'] != null) {
      tags = (json['visual_tags'] as List)
          .map((t) => VisualTag.fromString(t.toString()))
          .toList();
    }

    return Medication(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      name: json['name'] as String,
      medType: MedType.fromString(json['med_type'] as String?),
      instructionsText: json['instructions_text'] as String?,
      dosageAmount: (json['dosage_amount'] as num?)?.toDouble() ?? 1,
      dosageUnit: json['dosage_unit'] as String? ?? 'pill',
      remainingQuantity: json['remaining_quantity'] as int?,
      photoUrl: json['photo_url'] as String?,
      pillPhotoPath: json['pill_photo_path'] as String?,
      boxPhotoPath: json['box_photo_path'] as String?,
      visualTags: tags,
      status: MedicationStatus.fromString(json['status'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile_id': profileId,
      'name': name,
      'med_type': medType.value,
      'instructions_text': instructionsText,
      'dosage_amount': dosageAmount,
      'dosage_unit': dosageUnit,
      'remaining_quantity': remainingQuantity,
      'photo_url': photoUrl,
      'visual_tags': visualTags.map((t) => t.value).toList(),
      'status': status.value,
    };
  }

  Medication copyWith({
    String? id,
    String? profileId,
    String? name,
    MedType? medType,
    String? instructionsText,
    double? dosageAmount,
    String? dosageUnit,
    int? remainingQuantity,
    String? photoUrl,
    List<VisualTag>? visualTags,
    MedicationStatus? status,
  }) {
    return Medication(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      medType: medType ?? this.medType,
      instructionsText: instructionsText ?? this.instructionsText,
      dosageAmount: dosageAmount ?? this.dosageAmount,
      dosageUnit: dosageUnit ?? this.dosageUnit,
      remainingQuantity: remainingQuantity ?? this.remainingQuantity,
      photoUrl: photoUrl ?? this.photoUrl,
      visualTags: visualTags ?? this.visualTags,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

enum ScheduleType {
  daily('DAILY', 'يومياً', 'Daily'),
  specificDays('SPECIFIC_DAYS', 'أيام محددة', 'Specific Days'),
  everyXHours('EVERY_X_HOURS', 'كل عدة ساعات', 'Every X Hours'),
  asNeeded('AS_NEEDED', 'عند الحاجة', 'As Needed');

  const ScheduleType(this.value, this.labelAr, this.labelEn);
  final String value;
  final String labelAr;
  final String labelEn;

  String getLabel(String lang) => lang == 'ar' ? labelAr : labelEn;

  static ScheduleType fromString(String? value) {
    if (value == null) return ScheduleType.daily;
    return ScheduleType.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => ScheduleType.daily,
    );
  }
}

@immutable
class MedSchedule {
  const MedSchedule({
    required this.id,
    required this.medicationId,
    this.scheduleType = ScheduleType.daily,
    this.timesLocal = const ['08:00'],
    this.daysOfWeek,
    this.everyXHours,
    this.reminderMinutesBefore = 15,
    required this.startDate,
    this.endDate,
  });

  final String id;
  final String medicationId;
  final ScheduleType scheduleType;
  final List<String> timesLocal;
  final List<int>? daysOfWeek;
  final int? everyXHours;
  final int reminderMinutesBefore;
  final DateTime startDate;
  final DateTime? endDate;

  factory MedSchedule.fromJson(Map<String, dynamic> json) {
    return MedSchedule(
      id: json['id'] as String,
      medicationId: json['medication_id'] as String,
      scheduleType: ScheduleType.fromString(json['schedule_type'] as String?),
      timesLocal: (json['times_local'] as List?)?.cast<String>() ?? ['08:00'],
      daysOfWeek: (json['days_of_week'] as List?)?.cast<int>(),
      everyXHours: json['every_x_hours'] as int?,
      reminderMinutesBefore: json['reminder_minutes_before'] as int? ?? 15,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medication_id': medicationId,
      'schedule_type': scheduleType.value,
      'times_local': timesLocal,
      'days_of_week': daysOfWeek,
      'every_x_hours': everyXHours,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate?.toIso8601String().split('T')[0],
    };
  }
}
