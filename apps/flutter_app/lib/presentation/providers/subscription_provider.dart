import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_provider.dart';

enum SubscriptionPlan { free, pro }

final subscriptionProvider = StateProvider<SubscriptionPlan>((ref) {
  return SubscriptionPlan.free;
});

final canAddMedicationProvider = Provider<bool>((ref) {
  final profile = ref.watch(currentProfileProvider);
  return profile != null;
});

final canAddProfileProvider = Provider<bool>((ref) {
  final profiles = ref.watch(profilesProvider).valueOrNull ?? [];
  final plan = ref.watch(subscriptionProvider);
  
  if (plan == SubscriptionPlan.pro) return true;
  return profiles.length < 2; // Free plan: max 2 profiles
});
