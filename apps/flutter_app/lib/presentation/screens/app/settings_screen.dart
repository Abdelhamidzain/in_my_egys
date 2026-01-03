import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:carecompanion/l10n/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../../core/router/app_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = ref.watch(localeProvider);
    
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              l10n.settings,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Account section
            _SectionHeader(title: l10n.account, theme: theme),
            _SettingsTile(
              icon: Icons.person_outline,
              title: l10n.profile,
              subtitle: l10n.localeName == 'ar' ? 'إدارة حسابك' : 'Manage your account',
              theme: theme,
              onTap: () {},
            ),
            
            // App settings section
            const SizedBox(height: 24),
            _SectionHeader(title: l10n.appSettings, theme: theme),
            _SettingsTile(
              icon: Icons.language,
              title: l10n.localeName == 'ar' ? 'اللغة' : 'Language',
              subtitle: locale.languageCode == 'ar' ? 'العربية' : 'English',
              theme: theme,
              onTap: () => _showLanguageDialog(context, ref, l10n, theme),
            ),
            _SettingsTile(
              icon: Icons.notifications_outlined,
              title: l10n.notifications,
              subtitle: l10n.localeName == 'ar' ? 'إدارة الإشعارات' : 'Manage notifications',
              theme: theme,
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.lock_outline,
              title: l10n.pinSecurity,
              subtitle: l10n.localeName == 'ar' ? 'حماية التطبيق' : 'App protection',
              theme: theme,
              onTap: () {},
            ),
            
            // Support section
            const SizedBox(height: 24),
            _SectionHeader(title: l10n.helpSupport, theme: theme),
            _SettingsTile(
              icon: Icons.help_outline,
              title: l10n.faq,
              theme: theme,
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.info_outline,
              title: l10n.localeName == 'ar' ? 'عن التطبيق' : 'About',
              theme: theme,
              onTap: () => _showAboutDialog(context, theme),
            ),
            
            // Logout
            const SizedBox(height: 24),
            _SettingsTile(
              icon: Icons.logout,
              title: l10n.logout,
              theme: theme,
              isDestructive: true,
              onTap: () => _showLogoutDialog(context, ref, l10n, theme),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
  
  void _showLanguageDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.localeName == 'ar' ? 'اختر اللغة' : 'Choose Language',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Text('🇸🇦', style: TextStyle(fontSize: 24)),
              title: const Text('العربية'),
              trailing: ref.watch(localeProvider).languageCode == 'ar'
                  ? Icon(Icons.check, color: theme.colorScheme.primary)
                  : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('ar'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: const Text('English'),
              trailing: ref.watch(localeProvider).languageCode == 'en'
                  ? Icon(Icons.check, color: theme.colorScheme.primary)
                  : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  void _showLogoutDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
  
  void _showAboutDialog(BuildContext context, ThemeData theme) {
    showAboutDialog(
      context: context,
      applicationName: 'CareCompanion',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.medication, size: 48, color: theme.colorScheme.primary),
      ),
      children: [
        const Text('A medication reminder app for families.'),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;
  
  const _SectionHeader({required this.title, required this.theme});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final ThemeData theme;
  final VoidCallback onTap;
  final bool isDestructive;
  
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.theme,
    required this.onTap,
    this.isDestructive = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? theme.colorScheme.error : null;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? theme.colorScheme.onSurface),
        title: Text(
          title,
          style: TextStyle(color: color),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              )
            : null,
        trailing: Icon(Icons.chevron_right, color: theme.colorScheme.outline),
        onTap: onTap,
      ),
    );
  }
}
