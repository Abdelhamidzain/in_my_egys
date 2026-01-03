import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/adherence.dart';
import '../../data/repositories/adherence_repository.dart';
import '../../data/local/database.dart';
import 'auth_provider.dart';
import 'profile_provider.dart';

/// Adherence repository provider
final adherenceRepositoryProvider = Provider<AdherenceRepository>((ref) {
  return AdherenceRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(databaseProvider),
  );
});

/// Adherence events provider
final adherenceEventsProvider = FutureProvider<List<AdherenceEvent>>((ref) async {
  final profile = ref.watch(currentProfileProvider);
  if (profile == null) return [];
  
  final repository = ref.watch(adherenceRepositoryProvider);
  return repository.getEvents(profileId: profile.id);
});

/// Adherence summary provider
final adherenceSummaryProvider = FutureProvider.family<AdherenceSummary, int>((ref, days) async {
  final profile = ref.watch(currentProfileProvider);
  if (profile == null) {
    return AdherenceSummary(
      profileId: '',
      medicationId: null,
      periodDays: days,
      totalDoses: 0,
      takenCount: 0,
      skippedCount: 0,
      missedCount: 0,
    );
  }
  
  final repository = ref.watch(adherenceRepositoryProvider);
  return repository.getSummary(profileId: profile.id, periodDays: days);
});

/// 7-day adherence summary
final weeklyAdherenceProvider = FutureProvider<AdherenceSummary>((ref) async {
  return ref.watch(adherenceSummaryProvider(7).future);
});

/// 30-day adherence summary  
final monthlyAdherenceProvider = FutureProvider<AdherenceSummary>((ref) async {
  return ref.watch(adherenceSummaryProvider(30).future);
});
