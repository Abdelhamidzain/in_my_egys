import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/repositories/auth_repository.dart';

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});

/// Auth state provider - streams auth changes
final authStateProvider = StreamProvider<User?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange.map((event) => event.session?.user);
});

/// Immediate auth check - no stream waiting (FAST)
final isLoggedInProvider = Provider<bool>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.currentSession != null;
});

/// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

/// Is admin provider
final isAdminProvider = StateProvider<bool>((ref) => false);

/// PIN verified provider
final pinVerifiedProvider = StateProvider<bool>((ref) => false);

/// Secure storage provider
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

/// Auth notifier for login/signup/logout actions
class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.signUp(email: email, password: password);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.signIn(email: email, password: password);

      // Check admin in background - don't block login
      _checkAdminAsync();

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _checkAdminAsync() async {
    try {
      final isAdmin = await _repository.checkIsAdmin().timeout(
        const Duration(seconds: 3),
        onTimeout: () => false,
      );
      _ref.read(isAdminProvider.notifier).state = isAdmin;
    } catch (_) {}
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repository.signOut();
      _ref.read(isAdminProvider.notifier).state = false;
      _ref.read(pinVerifiedProvider.notifier).state = false;
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    try {
      await _repository.resetPassword(email);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePassword(String newPassword) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updatePassword(newPassword);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref,
  );
});

/// PIN management
class PinNotifier extends StateNotifier<AsyncValue<void>> {
  final FlutterSecureStorage _storage;
  final Ref _ref;

  static const _pinKey = 'app_pin';
  static const _biometricEnabledKey = 'biometric_enabled';

  PinNotifier(this._storage, this._ref) : super(const AsyncValue.data(null));

  Future<bool> hasPin() async {
    final pin = await _storage.read(key: _pinKey);
    return pin != null && pin.isNotEmpty;
  }

  Future<void> setPin(String pin) async {
    state = const AsyncValue.loading();
    try {
      await _storage.write(key: _pinKey, value: pin);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> verifyPin(String pin) async {
    final storedPin = await _storage.read(key: _pinKey);
    final isValid = storedPin == pin;
    if (isValid) {
      _ref.read(pinVerifiedProvider.notifier).state = true;
    }
    return isValid;
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _pinKey);
    _ref.read(pinVerifiedProvider.notifier).state = false;
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _biometricEnabledKey, value: enabled.toString());
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _biometricEnabledKey);
    return value == 'true';
  }
}

final pinNotifierProvider = StateNotifierProvider<PinNotifier, AsyncValue<void>>((ref) {
  return PinNotifier(
    ref.watch(secureStorageProvider),
    ref,
  );
});
