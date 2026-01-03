import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/profile.dart';
import '../../data/repositories/profile_repository.dart';
import 'auth_provider.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(supabaseClientProvider));
});

final profilesProvider = FutureProvider<List<Profile>>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfiles();
});

final selectedProfileIdProvider = StateProvider<String?>((ref) => null);

final currentProfileProvider = Provider<Profile?>((ref) {
  final selectedId = ref.watch(selectedProfileIdProvider);
  final profiles = ref.watch(profilesProvider).valueOrNull ?? [];
  
  if (profiles.isEmpty) return null;
  
  if (selectedId != null) {
    final found = profiles.where((p) => p.id == selectedId).toList();
    if (found.isNotEmpty) return found.first;
  }
  
  return profiles.first;
});

class ProfileNotifier extends StateNotifier<AsyncValue<void>> {
  final ProfileRepository _repository;
  final Ref _ref;

  ProfileNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<String?> createProfile({
    required String displayName,
    required String relationship,
    required ProfileType type,
    DateTime? dateOfBirth,
    Gender? gender,
    String? timezoneHome,
  }) async {
    state = const AsyncValue.loading();
    try {
      final id = await _repository.createProfile(
        displayName: displayName,
        relationship: relationship,
        type: type,
        dateOfBirth: dateOfBirth,
        gender: gender,
        timezoneHome: timezoneHome,
      );
      _ref.invalidate(profilesProvider);
      state = const AsyncValue.data(null);
      return id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> updateProfile({
    required String profileId,
    String? displayName,
    String? relationship,
    DateTime? dateOfBirth,
    Gender? gender,
    double? weightKg,
    double? heightCm,
    String? bloodType,
    List<String>? allergies,
    List<String>? medicalConditions,
    String? emergencyContact,
    String? emergencyPhone,
    String? notes,
    String? timezoneHome,
    String? timezoneCurrent,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateProfile(
        profileId: profileId,
        displayName: displayName,
        relationship: relationship,
        dateOfBirth: dateOfBirth,
        gender: gender,
        weightKg: weightKg,
        heightCm: heightCm,
        bloodType: bloodType,
        allergies: allergies,
        medicalConditions: medicalConditions,
        emergencyContact: emergencyContact,
        emergencyPhone: emergencyPhone,
        notes: notes,
        timezoneHome: timezoneHome,
        timezoneCurrent: timezoneCurrent,
      );
      _ref.invalidate(profilesProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteProfile(String profileId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteProfile(profileId);
      _ref.invalidate(profilesProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final profileNotifierProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<void>>((ref) {
  return ProfileNotifier(ref.watch(profileRepositoryProvider), ref);
});

final canAddMedicationProvider = Provider<bool>((ref) {
  final profile = ref.watch(currentProfileProvider);
  return profile != null;
});

final canEditProfileProvider = Provider<bool>((ref) {
  final profile = ref.watch(currentProfileProvider);
  return profile != null;
});

final canViewLogProvider = Provider<bool>((ref) {
  final profile = ref.watch(currentProfileProvider);
  return profile != null;
});
