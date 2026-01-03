import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// Dose instance status (server-side tracking)
enum DoseStatus {
  due('DUE'),
  taken('TAKEN'),
  snoozed('SNOOZED'),
  skipped('SKIPPED'),
  missed('MISSED');
  
  const DoseStatus(this.value);
  final String value;
  
  static DoseStatus fromString(String value) {
    return DoseStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DoseStatus.due,
    );
  }
}

/// Dose instance entity (server-side)
@immutable
class DoseInstance {
  const DoseInstance({
    required this.id,
    required this.profileId,
    required this.medicationId,
    required this.scheduledTimeUtc,
    required this.scheduledTimeLocal,
    required this.status,
    required this.statusUpdatedAt,
  });
  
  final String id;
  final String profileId;
  final String medicationId;
  final DateTime scheduledTimeUtc;
  final DateTime scheduledTimeLocal;
  final DoseStatus status;
  final DateTime statusUpdatedAt;
  
  factory DoseInstance.fromJson(Map<String, dynamic> json) {
    return DoseInstance(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      medicationId: json['medication_id'] as String,
      scheduledTimeUtc: DateTime.parse(json['scheduled_time_utc'] as String),
      scheduledTimeLocal: DateTime.parse(json['scheduled_time_local'] as String),
      status: DoseStatus.fromString(json['status'] as String),
      statusUpdatedAt: DateTime.parse(json['status_updated_at'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'medication_id': medicationId,
      'scheduled_time_utc': scheduledTimeUtc.toUtc().toIso8601String(),
      'scheduled_time_local': scheduledTimeLocal.toIso8601String(),
      'status': status.value,
      'status_updated_at': statusUpdatedAt.toUtc().toIso8601String(),
    };
  }
}

/// Adherence event type enum
enum AdherenceEventType {
  notifShown('NOTIF_SHOWN'),
  notifOpened('NOTIF_OPENED'),
  taken('TAKEN'),
  snooze('SNOOZE'),
  skip('SKIP');
  
  const AdherenceEventType(this.value);
  final String value;
  
  static AdherenceEventType fromString(String value) {
    return AdherenceEventType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AdherenceEventType.taken,
    );
  }
  
  String getLabel(String languageCode) {
    switch (this) {
      case AdherenceEventType.notifShown:
        return languageCode == 'ar' ? 'ظهر الإشعار' : 'Notification shown';
      case AdherenceEventType.notifOpened:
        return languageCode == 'ar' ? 'فتح الإشعار' : 'Notification opened';
      case AdherenceEventType.taken:
        return languageCode == 'ar' ? 'تم التناول' : 'Taken';
      case AdherenceEventType.snooze:
        return languageCode == 'ar' ? 'تأجيل' : 'Snoozed';
      case AdherenceEventType.skip:
        return languageCode == 'ar' ? 'تخطي' : 'Skipped';
    }
  }
}

/// Skip reason enum
enum SkipReason {
  forgot('FORGOT', 'نسيت', 'Forgot'),
  notAvailable('NOT_AVAILABLE', 'غير متوفر', 'Not available'),
  travel('TRAVEL', 'سفر', 'Travel'),
  other('OTHER', 'سبب آخر', 'Other');
  
  const SkipReason(this.value, this.labelAr, this.labelEn);
  final String value;
  final String labelAr;
  final String labelEn;
  
  String getLabel(String languageCode) {
    return languageCode == 'ar' ? labelAr : labelEn;
  }
  
  static SkipReason fromString(String value) {
    return SkipReason.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SkipReason.other,
    );
  }
}

/// Adherence event entity
@immutable
class AdherenceEvent {
  const AdherenceEvent({
    required this.id,
    required this.profileId,
    required this.medicationId,
    this.doseInstanceId,
    required this.eventType,
    this.skipReason,
    this.notes,
    required this.timestampUtc,
    required this.timezone,
    required this.deviceId,
    required this.idempotencyKey,
    required this.createdAt,
    this.synced = false,
  });
  
  final String id;
  final String profileId;
  final String medicationId;
  final String? doseInstanceId;
  final AdherenceEventType eventType;
  final SkipReason? skipReason;
  final String? notes;
  final DateTime timestampUtc;
  final String timezone;
  final String deviceId;
  final String idempotencyKey;
  final DateTime createdAt;
  final bool synced; // Local-only field for offline sync tracking
  
  /// Create a new adherence event with generated IDs
  factory AdherenceEvent.create({
    required String profileId,
    required String medicationId,
    String? doseInstanceId,
    required AdherenceEventType eventType,
    SkipReason? skipReason,
    String? notes,
    required String timezone,
    required String deviceId,
  }) {
    final uuid = const Uuid();
    final now = DateTime.now().toUtc();
    return AdherenceEvent(
      id: uuid.v4(),
      profileId: profileId,
      medicationId: medicationId,
      doseInstanceId: doseInstanceId,
      eventType: eventType,
      skipReason: skipReason,
      notes: notes,
      timestampUtc: now,
      timezone: timezone,
      deviceId: deviceId,
      idempotencyKey: '${profileId}_${medicationId}_${eventType.value}_${now.millisecondsSinceEpoch}',
      createdAt: now,
      synced: false,
    );
  }
  
  factory AdherenceEvent.fromJson(Map<String, dynamic> json) {
    return AdherenceEvent(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      medicationId: json['medication_id'] as String,
      doseInstanceId: json['dose_instance_id'] as String?,
      eventType: AdherenceEventType.fromString(json['event_type'] as String),
      skipReason: json['skip_reason'] != null 
          ? SkipReason.fromString(json['skip_reason'] as String)
          : null,
      notes: json['notes'] as String?,
      timestampUtc: DateTime.parse(json['timestamp_utc'] as String),
      timezone: json['timezone'] as String,
      deviceId: json['device_id'] as String,
      idempotencyKey: json['idempotency_key'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      synced: true, // If from server, it's synced
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'medication_id': medicationId,
      'dose_instance_id': doseInstanceId,
      'event_type': eventType.value,
      'skip_reason': skipReason?.value,
      'notes': notes,
      'timestamp_utc': timestampUtc.toUtc().toIso8601String(),
      'timezone': timezone,
      'device_id': deviceId,
      'idempotency_key': idempotencyKey,
    };
  }
  
  AdherenceEvent copyWith({
    String? id,
    String? profileId,
    String? medicationId,
    String? doseInstanceId,
    AdherenceEventType? eventType,
    SkipReason? skipReason,
    String? notes,
    DateTime? timestampUtc,
    String? timezone,
    String? deviceId,
    String? idempotencyKey,
    DateTime? createdAt,
    bool? synced,
  }) {
    return AdherenceEvent(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      medicationId: medicationId ?? this.medicationId,
      doseInstanceId: doseInstanceId ?? this.doseInstanceId,
      eventType: eventType ?? this.eventType,
      skipReason: skipReason ?? this.skipReason,
      notes: notes ?? this.notes,
      timestampUtc: timestampUtc ?? this.timestampUtc,
      timezone: timezone ?? this.timezone,
      deviceId: deviceId ?? this.deviceId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdherenceEvent && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}

/// Adherence summary for a time period
@immutable
class AdherenceSummary {
  const AdherenceSummary({
    required this.profileId,
    required this.medicationId,
    required this.periodDays,
    required this.totalDoses,
    required this.takenCount,
    required this.skippedCount,
    required this.missedCount,
  });
  
  final String profileId;
  final String? medicationId; // null for overall profile summary
  final int periodDays;
  final int totalDoses;
  final int takenCount;
  final int skippedCount;
  final int missedCount;
  
  /// Calculate adherence percentage
  double get adherencePercentage {
    if (totalDoses == 0) return 100.0;
    return (takenCount / totalDoses) * 100;
  }
  
  /// Format adherence as string
  String getAdherenceDisplay() {
    return '${adherencePercentage.toStringAsFixed(0)}%';
  }
  
  /// Get summary text
  String getSummaryText(String languageCode) {
    if (languageCode == 'ar') {
      return '$takenCount من $totalDoses جرعة';
    }
    return '$takenCount of $totalDoses doses';
  }
}
