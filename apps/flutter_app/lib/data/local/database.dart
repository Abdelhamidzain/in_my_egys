import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock database for web - will be replaced with proper implementation for mobile
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

class AppDatabase {
  // Placeholder methods - data will come from Supabase for now
  Future<void> close() async {}
}
