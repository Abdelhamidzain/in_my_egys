import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sync service provider - placeholder
final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});

/// Sync state provider
final syncStateProvider = StateProvider<SyncState>((ref) => SyncState.idle);

enum SyncState { idle, syncing, error }

class SyncService {
  Future<void> sync() async {
    // Placeholder - will be implemented later
  }
  
  Future<bool> isOnline() async => true;
}
