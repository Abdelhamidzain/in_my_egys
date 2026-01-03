import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/locale_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.secondary400, width: 3),
                ),
                child: Icon(
                  Icons.language,
                  size: 48,
                  color: AppColors.secondary400,
                ),
              ),
              const SizedBox(height: 32),
              // Title
              Text(
                'Choose Language',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary800,
                ),
              ),
              Text(
                'اختر اللغة',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary800,
                ),
              ),
              const SizedBox(height: 48),
              // Arabic button - Dark green background
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () {
                    ref.read(localeProvider.notifier).setLocale(const Locale('ar'));
                    context.go(AppRoutes.login);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary700,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('العربية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 16),
              // English button - Light green background with dark text
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () {
                    ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                    context.go(AppRoutes.login);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.cardLight,
                    foregroundColor: AppColors.primary700,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('English', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
