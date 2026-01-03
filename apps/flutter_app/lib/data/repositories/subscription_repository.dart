import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/subscription.dart';

class SubscriptionRepository {
  final SupabaseClient _client;
  
  SubscriptionRepository(this._client);
  
  /// Get current user's subscription
  Future<Subscription?> getSubscription() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;
    
    final response = await _client
        .from('subscriptions')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    
    if (response == null) {
      // Create default free subscription
      await _createDefaultSubscription(userId);
      return Subscription(
        id: '',
        userId: userId,
        plan: SubscriptionPlan.free,
        provider: SubscriptionProvider.none,
        status: SubscriptionStatus.active,
        updatedAt: DateTime.now(),
      );
    }
    
    return Subscription.fromJson(response);
  }
  
  /// Create default free subscription
  Future<void> _createDefaultSubscription(String userId) async {
    await _client.from('subscriptions').insert({
      'user_id': userId,
      'plan': 'FREE',
      'provider': 'NONE',
      'status': 'ACTIVE',
    });
  }
  
  /// Update subscription plan (for MVP testing)
  Future<void> updatePlan(SubscriptionPlan plan) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');
    
    await _client
        .from('subscriptions')
        .update({
          'plan': plan.name.toUpperCase(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId);
  }
  
  /// Restore purchase (placeholder for IAP integration)
  Future<void> restorePurchase() async {
    // In a real app, this would:
    // 1. Check with Apple/Google for active subscriptions
    // 2. Verify receipt with server
    // 3. Update subscription status
    
    // For MVP, just refresh from server
    await getSubscription();
  }
  
  /// Verify and update from Stripe webhook (server-side)
  Future<void> handleStripeWebhook(Map<String, dynamic> event) async {
    // This would be called from an Edge Function
    // Not directly from the app
  }
  
  /// Check if user has Pro features
  Future<bool> hasPro() async {
    final subscription = await getSubscription();
    return subscription?.plan == SubscriptionPlan.pro &&
           subscription?.status == SubscriptionStatus.active;
  }
}
