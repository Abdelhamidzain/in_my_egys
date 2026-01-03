import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/medication.dart';
import '../../data/repositories/medication_repository.dart';
import 'profile_provider.dart';
import 'auth_provider.dart';

/// Medication repository provider
final medicationRepositoryProvider = Provider<MedicationRepository>((ref) {
  return MedicationRepository(ref.watch(supabaseClientProvider));
});

/// All medications for current profile
final medicationsProvider = FutureProvider<List<Medication>>((ref) async {
  final profile = ref.watch(currentProfileProvider);
  if (profile == null) return [];
  
  final repository = ref.watch(medicationRepositoryProvider);
  return repository.getMedications(profile.id);
});

/// Today doses provider
final todayDosesProvider = Provider<List<ScheduledDose>>((ref) {
  final medications = ref.watch(medicationsProvider).valueOrNull ?? [];
  // For now return empty - will implement scheduling later
  return [];
});

/// Medication notifier for mutations
class MedicationNotifier extends StateNotifier<AsyncValue<void>> {
  final MedicationRepository _repository;
  final Ref _ref;

  MedicationNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<String?> createMedication({
    required String profileId,
    required String name,
    String? instructionsText,
  }) async {
    state = const AsyncValue.loading();
    try {
      final medicationId = await _repository.createMedication(
        profileId: profileId,
        name: name,
        instructionsText: instructionsText,
      );
      
      _ref.invalidate(medicationsProvider);
      state = const AsyncValue.data(null);
      return medicationId;
    } catch (e, st) {
      print('Error creating medication: $e');
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> deleteMedication(String medicationId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteMedication(medicationId);
      _ref.invalidate(medicationsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final medicationNotifierProvider = StateNotifierProvider<MedicationNotifier, AsyncValue<void>>((ref) {
  return MedicationNotifier(
    ref.watch(medicationRepositoryProvider),
    ref,
  );
});

/// Scheduled dose model
class ScheduledDose {
  final Medication medication;
  final MedSchedule schedule;
  final DateTime scheduledTime;

  ScheduledDose({
    required this.medication,
    required this.schedule,
    required this.scheduledTime,
  });

  bool get isOverdue => scheduledTime.isBefore(DateTime.now());
  
  Duration get timeUntil => scheduledTime.difference(DateTime.now());
  
  String get timeUntilFormatted {
    final duration = timeUntil;
    if (duration.isNegative) {
      final overdue = duration.abs();
      if (overdue.inHours > 0) {
        return '${overdue.inHours}h overdue';
      }
      return '${overdue.inMinutes}m overdue';
    }
    if (duration.inHours > 0) {
      return 'in ${duration.inHours}h';
    }
    return 'in ${duration.inMinutes}m';
  }
}
