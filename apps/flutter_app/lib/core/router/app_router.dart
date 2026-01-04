import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/signup_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/auth/language_screen.dart';
import '../../presentation/screens/auth/pin_screen.dart';
import '../../presentation/screens/app/today_screen.dart';
import '../../presentation/screens/app/medications_screen.dart';
import '../../presentation/screens/app/log_screen.dart';
import '../../presentation/screens/app/profiles_screen.dart';
import '../../presentation/screens/app/create_profile_screen.dart';
import '../../presentation/screens/app/setup_profile_screen.dart';
import '../../presentation/screens/app/settings_screen.dart';
import '../../presentation/widgets/app_shell.dart';

abstract class AppRoutes {
  static const String language = '/lang';
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String forgotPassword = '/auth/forgot';
  static const String pin = '/pin';
  static const String setupProfile = '/setup-profile';
  static const String today = '/app/today';
  static const String medications = '/app/medications';
  static const String log = '/app/log';
  static const String profiles = '/app/profiles';
  static const String createProfile = '/app/profiles/create';
  static const String settings = '/app/settings';
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

/// Auth state notifier for router refresh
class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier() {
    _subscription = Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      notifyListeners();
    });
  }
  
  late final StreamSubscription<AuthState> _subscription;
  
  bool get isLoggedIn => Supabase.instance.client.auth.currentSession != null;
  
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final authChangeNotifierProvider = ChangeNotifierProvider<AuthChangeNotifier>((ref) {
  return AuthChangeNotifier();
});

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authChangeNotifierProvider);

  return GoRouter(
    refreshListenable: authNotifier,
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.language,
    debugLogDiagnostics: true,

    redirect: (context, state) {
      final isLoggedIn = authNotifier.isLoggedIn;
      final location = state.matchedLocation;
      final isAuthRoute = location.startsWith('/auth') || location == AppRoutes.language;
      final isSetupRoute = location == AppRoutes.setupProfile;

      // Not logged in - must be on auth route
      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.login;
      }

      // Logged in but on auth route - go to today
      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.today;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.language,
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.pin,
        builder: (context, state) => const PinScreen(),
      ),
      GoRoute(
        path: AppRoutes.setupProfile,
        builder: (context, state) => const SetupProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.createProfile,
        builder: (context, state) => const CreateProfileScreen(),
      ),

      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.today,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TodayScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.medications,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MedicationsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.log,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LogScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profiles,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilesScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri}')),
    ),
  );
});

