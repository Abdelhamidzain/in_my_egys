import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/profile.dart';

class ProfileRepository {
  final SupabaseClient _client;

  ProfileRepository(this._client);

  Future<List<Profile>> getProfiles() async {
    final userId = _client.auth.currentUser?.id;
    print('=== GET PROFILES ===');
    print('User ID: $userId');
    
    if (userId == null) {
      print('No user logged in!');
      return [];
    }

    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('owner_user_id', userId)
          .order('created_at', ascending: true);

      print('Response: $response');
      print('Count: ${(response as List).length}');
      
      final profiles = (response as List).map((json) => Profile.fromJson(json)).toList();
      print('Parsed profiles: ${profiles.map((p) => p.displayName).toList()}');
      return profiles;
    } catch (e) {
      print('ERROR loading profiles: $e');
      return [];
    }
  }

  Future<String?> createProfile({
    required String displayName,
    required String relationship,
    required ProfileType type,
    DateTime? dateOfBirth,
    Gender? gender,
    String? timezoneHome,
  }) async {
    final userId = _client.auth.currentUser?.id;
    print('=== CREATE PROFILE ===');
    print('User ID: $userId');
    print('Display Name: $displayName');
    print('Relationship: $relationship');
    print('Type: ${type.value}');
    print('Gender: ${gender?.value}');
    
    if (userId == null) throw Exception('Not authenticated');

    try {
      final data = <String, dynamic>{
        'owner_user_id': userId,
        'type': type.value,
        'display_name': displayName,
        'relationship': relationship,
      };

      if (dateOfBirth != null) {
        data['date_of_birth'] = dateOfBirth.toIso8601String().split('T')[0];
      }
      if (gender != null) {
        data['gender'] = gender.value;
      }
      if (timezoneHome != null) {
        data['timezone_home'] = timezoneHome;
      }

      print('Insert data: $data');

      final profileResponse = await _client
          .from('profiles')
          .insert(data)
          .select()
          .single();

      print('SUCCESS! Created profile: $profileResponse');
      return profileResponse['id'] as String;
    } catch (e) {
      print('ERROR creating profile: $e');
      rethrow;
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
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (displayName != null) updates['display_name'] = displayName;
    if (relationship != null) updates['relationship'] = relationship;
    if (dateOfBirth != null) updates['date_of_birth'] = dateOfBirth.toIso8601String().split('T')[0];
    if (gender != null) updates['gender'] = gender.value;
    if (weightKg != null) updates['weight_kg'] = weightKg;
    if (heightCm != null) updates['height_cm'] = heightCm;
    if (bloodType != null) updates['blood_type'] = bloodType;
    if (allergies != null) updates['allergies'] = allergies;
    if (medicalConditions != null) updates['medical_conditions'] = medicalConditions;
    if (emergencyContact != null) updates['emergency_contact'] = emergencyContact;
    if (emergencyPhone != null) updates['emergency_phone'] = emergencyPhone;
    if (notes != null) updates['notes'] = notes;
    if (timezoneHome != null) updates['timezone_home'] = timezoneHome;
    if (timezoneCurrent != null) updates['timezone_current'] = timezoneCurrent;

    await _client.from('profiles').update(updates).eq('id', profileId);
  }

  Future<void> deleteProfile(String profileId) async {
    await _client.from('profiles').delete().eq('id', profileId);
  }
}
