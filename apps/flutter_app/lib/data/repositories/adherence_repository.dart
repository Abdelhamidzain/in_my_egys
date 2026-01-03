import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/adherence.dart';
import '../local/database.dart';

class AdherenceRepository {
  final SupabaseClient _supabase;
  final AppDatabase _db;

  AdherenceRepository(this._supabase, this._db);

  Future<List<AdherenceEvent>> getEvents({
    required String profileId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _supabase
          .from('adherence_events')
          .select()
          .eq('profile_id', profileId);
      
      if (startDate != null) {
        query = query.gte('timestamp_utc', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('timestamp_utc', endDate.toIso8601String());
      }
      
      final response = await query.order('timestamp_utc', ascending: false);
      
      return (response as List).map((json) => AdherenceEvent.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> recordDose({
    required String eventId,
    required DoseStatus status,
    String? notes,
  }) async {
    await _supabase.from('dose_instances').update({
      'status': status.value,
      'status_updated_at': DateTime.now().toIso8601String(),
    }).eq('id', eventId);
  }

  Future<AdherenceSummary> getSummary({
    required String profileId,
    String? medicationId,
    required int periodDays,
  }) async {
    final startDate = DateTime.now().subtract(Duration(days: periodDays));
    final events = await getEvents(
      profileId: profileId,
      startDate: startDate,
      endDate: DateTime.now(),
    );
    
    final taken = events.where((e) => e.eventType == AdherenceEventType.taken).length;
    final skipped = events.where((e) => e.eventType == AdherenceEventType.skip).length;
    final missed = 0; // Calculate from dose_instances
    final total = events.length;
    
    return AdherenceSummary(
      profileId: profileId,
      medicationId: medicationId,
      periodDays: periodDays,
      totalDoses: total,
      takenCount: taken,
      skippedCount: skipped,
      missedCount: missed,
    );
  }
}
