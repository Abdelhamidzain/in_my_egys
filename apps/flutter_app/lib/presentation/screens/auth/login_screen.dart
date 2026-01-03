import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:carecompanion/l10n/generated/app_localizations.dart';

import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/validators.dart';
import '../../../core/theme/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authNotifierProvider.notifier).signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final authState = ref.read(authNotifierProvider);
      if (authState.hasError && mounted) {
        String errorMessage = _parseError(authState.error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _parseError(Object? error) {
    final errorStr = error.toString();
    final isAr = AppLocalizations.of(context)!.localeName == 'ar';
    
    if (errorStr.contains('Invalid login credentials')) {
      return isAr ? 'البريد الإلكتروني أو كلمة المرور غير صحيحة' : 'Invalid email or password';
    }
    if (errorStr.contains('Email not confirmed')) {
      return isAr ? 'يرجى تأكيد بريدك الإلكتروني أولاً' : 'Please confirm your email first';
    }
    if (errorStr.contains('User not found')) {
      return isAr ? 'المستخدم غير موجود' : 'User not found';
    }
    if (errorStr.contains('network') || errorStr.contains('fetch') || errorStr.contains('Failed')) {
      return isAr ? 'خطأ في الاتصال، تحقق من الإنترنت' : 'Connection error, check your internet';
    }
    return errorStr;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authNotifierProvider);
    final isLoading = _isLoading || authState.isLoading;
    final isRtl = ref.watch(isRtlProvider);
    final isAr = l10n.localeName == 'ar';

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        title: Text(l10n.login, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
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
                    Icon(Icons.medication_outlined, size: 64, color: AppColors.primary700),
                    const SizedBox(height: 16),
                    Text(l10n.appName, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary800, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text(l10n.welcomeSubtitle, style: TextStyle(color: AppColors.neutral500), textAlign: TextAlign.center),
                    const SizedBox(height: 32),
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
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleLogin(),
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
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: isRtl ? Alignment.centerLeft : Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push(AppRoutes.forgotPassword),
                        style: TextButton.styleFrom(foregroundColor: AppColors.primary700),
                        child: Text(l10n.forgotPassword),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: isLoading ? null : _handleLogin,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary700,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: const StadiumBorder(),
                      ),
                      child: isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(l10n.login, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(isAr ? 'ليس لديك حساب؟' : 'Don\'t have an account?', style: TextStyle(color: AppColors.neutral500)),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.signup),
                          style: TextButton.styleFrom(foregroundColor: AppColors.primary700),
                          child: Text(l10n.signup, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
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
