import 'package:flutter/foundation.dart';

enum ProfileType {
  self_('SELF'),
  managed('MANAGED');

  final String value;
  const ProfileType(this.value);

  static ProfileType fromString(String value) {
    return ProfileType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ProfileType.managed,
    );
  }
}

enum Gender {
  male('MALE'),
  female('FEMALE');

  final String value;
  const Gender(this.value);

  static Gender? fromString(String? value) {
    if (value == null) return null;
    return Gender.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Gender.male,
    );
  }
}

enum Relationship {
  self_('self', 'أنا', 'Self', null),
  mother('mother', 'أمي', 'Mother', Gender.female),
  father('father', 'أبي', 'Father', Gender.male),
  wife('wife', 'زوجتي', 'Wife', Gender.female),
  husband('husband', 'زوجي', 'Husband', Gender.male),
  son('son', 'ابني', 'Son', Gender.male),
  daughter('daughter', 'ابنتي', 'Daughter', Gender.female),
  brother('brother', 'أخي', 'Brother', Gender.male),
  sister('sister', 'أختي', 'Sister', Gender.female),
  grandmother('grandmother', 'جدتي', 'Grandmother', Gender.female),
  grandfather('grandfather', 'جدي', 'Grandfather', Gender.male),
  uncle('uncle', 'عمي/خالي', 'Uncle', Gender.male),
  aunt('aunt', 'عمتي/خالتي', 'Aunt', Gender.female),
  friend('friend', 'صديق/ة', 'Friend', null),
  other('other', 'آخر', 'Other', null);

  final String value;
  final String labelAr;
  final String labelEn;
  final Gender? defaultGender;

  const Relationship(this.value, this.labelAr, this.labelEn, this.defaultGender);

  String getLabel(String locale) => locale == 'ar' ? labelAr : labelEn;

  static Relationship fromString(String value) {
    return Relationship.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Relationship.other,
    );
  }

  static List<Relationship> get forOthers =>
      Relationship.values.where((r) => r != Relationship.self_).toList();
}

@immutable
class Profile {
  final String id;
  final String userId;
  final String displayName;
  final ProfileType type;
  final Relationship relationship;
  final Gender? gender;
  final DateTime? dateOfBirth;
  final double? weightKg;
  final double? heightCm;
  final String? bloodType;
  final List<String> allergies;
  final List<String> medicalConditions;
  final Map<String, String> emergencyContacts;
  final String? notes;
  final String? avatarUrl;
  final String? timezoneHome;
  final String? timezoneTravel;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.type,
    required this.relationship,
    this.gender,
    this.dateOfBirth,
    this.weightKg,
    this.heightCm,
    this.bloodType,
    this.allergies = const [],
    this.medicalConditions = const [],
    this.emergencyContacts = const {},
    this.notes,
    this.avatarUrl,
    this.timezoneHome,
    this.timezoneTravel,
    required this.createdAt,
    required this.updatedAt,
  });

  String get initials {
    final parts = displayName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
  }

  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      userId: json['owner_user_id'] as String,
      displayName: json['display_name'] as String,
      type: ProfileType.fromString(json['type'] as String? ?? 'managed'),
      relationship: Relationship.fromString(json['relationship'] as String? ?? 'other'),
      gender: Gender.fromString(json['gender'] as String?),
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      heightCm: (json['height_cm'] as num?)?.toDouble(),
      bloodType: json['blood_type'] as String?,
      allergies: (json['allergies'] as List<dynamic>?)?.cast<String>() ?? [],
      medicalConditions: (json['medical_conditions'] as List<dynamic>?)?.cast<String>() ?? [],
      emergencyContacts: (json['emergency_contacts'] as Map<String, dynamic>?)?.cast<String, String>() ?? {},
      notes: json['notes'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      timezoneHome: json['timezone_home'] as String?,
      timezoneTravel: json['timezone_travel'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_user_id': userId,
      'display_name': displayName,
      'type': type.value,
      'relationship': relationship.value,
      'gender': gender?.value,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T').first,
      'weight_kg': weightKg,
      'height_cm': heightCm,
      'blood_type': bloodType,
      'allergies': allergies,
      'medical_conditions': medicalConditions,
      'emergency_contacts': emergencyContacts,
      'notes': notes,
      'avatar_url': avatarUrl,
      'timezone_home': timezoneHome,
      'timezone_travel': timezoneTravel,
    };
  }

  Profile copyWith({
    String? id,
    String? userId,
    String? displayName,
    ProfileType? type,
    Relationship? relationship,
    Gender? gender,
    DateTime? dateOfBirth,
    double? weightKg,
    double? heightCm,
    String? bloodType,
    List<String>? allergies,
    List<String>? medicalConditions,
    Map<String, String>? emergencyContacts,
    String? notes,
    String? avatarUrl,
    String? timezoneHome,
    String? timezoneTravel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      type: type ?? this.type,
      relationship: relationship ?? this.relationship,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      notes: notes ?? this.notes,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      timezoneHome: timezoneHome ?? this.timezoneHome,
      timezoneTravel: timezoneTravel ?? this.timezoneTravel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

