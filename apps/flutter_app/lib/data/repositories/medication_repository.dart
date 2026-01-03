import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/medication.dart';

class MedicationRepository {
  final SupabaseClient _client;

  MedicationRepository(this._client);

  Future<List<Medication>> getMedications(String profileId) async {
    try {
      final response = await _client
          .from('medications')
          .select()
          .eq('profile_id', profileId)
          .order('created_at', ascending: false);

      return (response as List).map((json) => Medication.fromJson(json)).toList();
    } catch (e) {
      print('Error loading medications: $e');
      return [];
    }
  }

  Future<String?> createMedication({
    required String profileId,
    required String name,
    String? instructionsText,
  }) async {
    try {
      final response = await _client
          .from('medications')
          .insert({
            'profile_id': profileId,
            'name': name,
            'instructions_text': instructionsText,
            'status': 'ACTIVE',
          })
          .select()
          .single();

      return response['id'] as String;
    } catch (e) {
      print('Error creating medication: $e');
      rethrow;
    }
  }

  Future<void> updateMedication({
    required String medicationId,
    String? name,
    String? instructionsText,
    MedicationStatus? status,
  }) async {
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (name != null) updates['name'] = name;
    if (instructionsText != null) updates['instructions_text'] = instructionsText;
    if (status != null) updates['status'] = status.name.toUpperCase();

    await _client.from('medications').update(updates).eq('id', medicationId);
  }

  Future<void> deleteMedication(String medicationId) async {
    await _client.from('medications').delete().eq('id', medicationId);
  }
}
