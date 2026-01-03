import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  Future<void> initialize() async {}
  Future<void> scheduleDoseReminder({required String medicationId, required DateTime time}) async {}
  Future<void> cancelReminder(String id) async {}
}
