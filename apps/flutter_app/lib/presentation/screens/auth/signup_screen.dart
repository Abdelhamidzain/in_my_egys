import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:carecompanion/l10n/generated/app_localizations.dart';

import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/validators.dart';
import '../../../core/theme/app_theme.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authNotifierProvider.notifier).signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    final authState = ref.read(authNotifierProvider);
    if (authState.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.error.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    } else if (!authState.hasError && mounted) {
      // Go directly to create profile (mandatory for new users)
      context.go(AppRoutes.setupProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final isRtl = ref.watch(isRtlProvider);
    final isAr = l10n.localeName == 'ar';

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        title: Text(l10n.signup, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextButton(
              onPressed: () => ref.read(localeProvider.notifier).toggleLocale(),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.secondary400.withValues(alpha: 0.2),
                foregroundColor: AppColors.secondary400,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(isRtl ? 'EN' : 'AR', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.person_add_outlined, size: 64, color: AppColors.primary700),
                    const SizedBox(height: 16),
                    Text(
                      l10n.welcome,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primary800,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.welcomeSubtitle,
                      style: TextStyle(color: AppColors.neutral500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        prefixIcon: Icon(Icons.email_outlined, color: AppColors.neutral400),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return l10n.emailRequired;
                        if (!Validators.isValidEmail(value)) return l10n.emailInvalid;
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: l10n.password,
                        prefixIcon: Icon(Icons.lock_outlined, color: AppColors.neutral400),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.neutral400),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return l10n.passwordRequired;
                        if (value.length < 8) return l10n.passwordTooShort;
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleSignup(),
                      decoration: InputDecoration(
                        labelText: l10n.confirmPassword,
                        prefixIcon: Icon(Icons.lock_outlined, color: AppColors.neutral400),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.neutral400),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return l10n.passwordRequired;
                        if (value != _passwordController.text) return l10n.passwordsDoNotMatch;
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Signup button
                    FilledButton(
                      onPressed: isLoading ? null : _handleSignup,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary700,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: const StadiumBorder(),
                      ),
                      child: isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(l10n.signup, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 16),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(isAr ? 'لديك حساب بالفعل؟' : 'Already have an account?', style: TextStyle(color: AppColors.neutral500)),
                        TextButton(
                          onPressed: () => context.pop(),
                          style: TextButton.styleFrom(foregroundColor: AppColors.primary700),
                          child: Text(l10n.login, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Disclaimer
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.neutral300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 20, color: AppColors.neutral500),
                          const SizedBox(width: 12),
                          Expanded(child: Text(l10n.disclaimer, style: TextStyle(fontSize: 12, color: AppColors.neutral500))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


