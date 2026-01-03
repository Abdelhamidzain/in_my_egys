import 'package:flutter/foundation.dart';

/// Subscription plan enum
enum SubscriptionPlan {
  free('FREE'),
  pro('PRO');
  
  const SubscriptionPlan(this.value);
  final String value;
  
  static SubscriptionPlan fromString(String value) {
    return SubscriptionPlan.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SubscriptionPlan.free,
    );
  }
  
  String getLabel(String languageCode) {
    switch (this) {
      case SubscriptionPlan.free:
        return languageCode == 'ar' ? 'مجاني' : 'Free';
      case SubscriptionPlan.pro:
        return languageCode == 'ar' ? 'برو' : 'Pro';
    }
  }
}

/// Subscription provider enum
enum SubscriptionProvider {
  none('NONE'),
  stripe('STRIPE'),
  apple('APPLE'),
  google('GOOGLE');
  
  const SubscriptionProvider(this.value);
  final String value;
  
  static SubscriptionProvider fromString(String value) {
    return SubscriptionProvider.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SubscriptionProvider.none,
    );
  }
}

/// Subscription status enum
enum SubscriptionStatus {
  active('ACTIVE'),
  canceled('CANCELED'),
  pastDue('PAST_DUE'),
  incomplete('INCOMPLETE');
  
  const SubscriptionStatus(this.value);
  final String value;
  
  static SubscriptionStatus fromString(String value) {
    return SubscriptionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SubscriptionStatus.active,
    );
  }
}

/// Subscription entity
@immutable
class Subscription {
  const Subscription({
    required this.id,
    required this.userId,
    required this.plan,
    required this.provider,
    this.providerCustomerId,
    this.providerSubscriptionId,
    this.currentPeriodEnd,
    required this.status,
    required this.updatedAt,
  });
  
  final String id;
  final String userId;
  final SubscriptionPlan plan;
  final SubscriptionProvider provider;
  final String? providerCustomerId;
  final String? providerSubscriptionId;
  final DateTime? currentPeriodEnd;
  final SubscriptionStatus status;
  final DateTime updatedAt;
  
  /// Check if user has Pro plan
  bool get isPro => plan == SubscriptionPlan.pro && status == SubscriptionStatus.active;
  
  /// Check if subscription is active
  bool get isActive => status == SubscriptionStatus.active;
  
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      plan: SubscriptionPlan.fromString(json['plan'] as String),
      provider: SubscriptionProvider.fromString(json['provider'] as String),
      providerCustomerId: json['provider_customer_id'] as String?,
      providerSubscriptionId: json['provider_subscription_id'] as String?,
      currentPeriodEnd: json['current_period_end'] != null
          ? DateTime.parse(json['current_period_end'] as String)
          : null,
      status: SubscriptionStatus.fromString(json['status'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plan': plan.value,
      'provider': provider.value,
      'provider_customer_id': providerCustomerId,
      'provider_subscription_id': providerSubscriptionId,
      'current_period_end': currentPeriodEnd?.toUtc().toIso8601String(),
      'status': status.value,
    };
  }
  
  /// Default free subscription
  factory Subscription.free(String userId) {
    return Subscription(
      id: '',
      userId: userId,
      plan: SubscriptionPlan.free,
      provider: SubscriptionProvider.none,
      status: SubscriptionStatus.active,
      updatedAt: DateTime.now(),
    );
  }
}

/// Pairing invite status enum
enum PairingInviteStatus {
  pending('PENDING'),
  accepted('ACCEPTED'),
  expired('EXPIRED'),
  revoked('REVOKED');
  
  const PairingInviteStatus(this.value);
  final String value;
  
  static PairingInviteStatus fromString(String value) {
    return PairingInviteStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PairingInviteStatus.pending,
    );
  }
}

/// Pairing invite entity
@immutable
class PairingInvite {
  const PairingInvite({
    required this.id,
    required this.profileId,
    required this.caregiverUserId,
    required this.patientPhoneE164,
    required this.pairCode,
    required this.universalLink,
    required this.expiresAt,
    required this.status,
    required this.createdAt,
  });
  
  final String id;
  final String profileId;
  final String caregiverUserId;
  final String patientPhoneE164;
  final String pairCode;
  final String universalLink;
  final DateTime expiresAt;
  final PairingInviteStatus status;
  final DateTime createdAt;
  
  /// Check if invite is still valid
  bool get isValid => 
      status == PairingInviteStatus.pending && 
      DateTime.now().isBefore(expiresAt);
  
  /// Get WhatsApp click-to-chat URL
  String get whatsappUrl {
    final phone = patientPhoneE164.replaceAll('+', '');
    final message = Uri.encodeComponent(
      'مرحباً! تم دعوتك للانضمام إلى CareCompanion. '
      'الرمز: $pairCode\n'
      'رابط التحميل: $universalLink'
    );
    return 'https://wa.me/$phone?text=$message';
  }
  
  factory PairingInvite.fromJson(Map<String, dynamic> json) {
    return PairingInvite(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      caregiverUserId: json['caregiver_user_id'] as String,
      patientPhoneE164: json['patient_phone_e164'] as String,
      pairCode: json['pair_code'] as String,
      universalLink: json['universal_link'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      status: PairingInviteStatus.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'caregiver_user_id': caregiverUserId,
      'patient_phone_e164': patientPhoneE164,
      'pair_code': pairCode,
      'universal_link': universalLink,
      'expires_at': expiresAt.toUtc().toIso8601String(),
      'status': status.value,
    };
  }
}

/// Share session scope enum
enum ShareScope {
  medsOnly('MEDS_ONLY'),
  medsAndLog('MEDS_AND_LOG');
  
  const ShareScope(this.value);
  final String value;
  
  static ShareScope fromString(String value) {
    return ShareScope.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ShareScope.medsOnly,
    );
  }
  
  String getLabel(String languageCode) {
    switch (this) {
      case ShareScope.medsOnly:
        return languageCode == 'ar' ? 'الأدوية فقط' : 'Medications only';
      case ShareScope.medsAndLog:
        return languageCode == 'ar' ? 'الأدوية وسجل الالتزام' : 'Medications and adherence log';
    }
  }
}

/// Share session entity (for QR doctor sharing)
@immutable
class ShareSession {
  const ShareSession({
    required this.id,
    required this.profileId,
    required this.createdByUserId,
    required this.scope,
    required this.token,
    required this.expiresAt,
    this.revokedAt,
    required this.createdAt,
  });
  
  final String id;
  final String profileId;
  final String createdByUserId;
  final ShareScope scope;
  final String token;
  final DateTime expiresAt;
  final DateTime? revokedAt;
  final DateTime createdAt;
  
  /// Check if session is still valid
  bool get isValid => 
      revokedAt == null && 
      DateTime.now().isBefore(expiresAt);
  
  /// Get remaining time in minutes
  int get remainingMinutes {
    if (!isValid) return 0;
    return expiresAt.difference(DateTime.now()).inMinutes;
  }
  
  /// Get QR view URL
  String getQrViewUrl(String baseUrl) {
    return '$baseUrl/functions/v1/get_share_payload?token=$token';
  }
  
  factory ShareSession.fromJson(Map<String, dynamic> json) {
    return ShareSession(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      createdByUserId: json['created_by_user_id'] as String,
      scope: ShareScope.fromString(json['scope'] as String),
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      revokedAt: json['revoked_at'] != null 
          ? DateTime.parse(json['revoked_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'created_by_user_id': createdByUserId,
      'scope': scope.value,
      'token': token,
      'expires_at': expiresAt.toUtc().toIso8601String(),
      'revoked_at': revokedAt?.toUtc().toIso8601String(),
    };
  }
}

/// In-app notification entity
@immutable
class InAppNotification {
  const InAppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.read,
    required this.createdAt,
  });
  
  final String id;
  final String userId;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final bool read;
  final DateTime createdAt;
  
  factory InAppNotification.fromJson(Map<String, dynamic> json) {
    return InAppNotification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as Map<String, dynamic>? ?? {},
      read: json['read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'body': body,
      'data': data,
      'read': read,
    };
  }
  
  InAppNotification copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    bool? read,
    DateTime? createdAt,
  }) {
    return InAppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
