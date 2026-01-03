import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client;
  
  AuthRepository(this._client);
  
  /// Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }
  
  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  /// Send password reset email
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }
  
  /// Update password (after reset)
  Future<void> updatePassword(String newPassword) async {
    await _client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }
  
  /// Check if current user is admin
  Future<bool> checkIsAdmin() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    
    try {
      final response = await _client
          .from('admin_users')
          .select('user_id')
          .eq('user_id', userId)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      return false;
    }
  }
  
  /// Get current user
  User? get currentUser => _client.auth.currentUser;
  
  /// Get current session
  Session? get currentSession => _client.auth.currentSession;
  
  /// Stream auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  
  /// Sign in with phone OTP (for linked profiles)
  Future<void> signInWithOtp({required String phone}) async {
    await _client.auth.signInWithOtp(phone: phone);
  }
  
  /// Verify phone OTP
  Future<AuthResponse> verifyOtp({
    required String phone,
    required String token,
  }) async {
    return await _client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }
  
  /// Resend email confirmation
  Future<void> resendConfirmation(String email) async {
    await _client.auth.resend(
      type: OtpType.email,
      email: email,
    );
  }
}
