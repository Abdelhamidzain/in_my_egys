import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:carecompanion/l10n/generated/app_localizations.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';

class AppShell extends ConsumerStatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _selectedIndex = _getSelectedIndex(context);
    
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.calendar_today_rounded,
                label: l10n.today,
                isSelected: _selectedIndex == 0,
                onTap: () => context.go(AppRoutes.today),
              ),
              _NavItem(
                icon: Icons.medication_rounded,
                label: l10n.medications,
                isSelected: _selectedIndex == 1,
                onTap: () => context.go(AppRoutes.medications),
              ),
              _NavItem(
                icon: Icons.history_rounded,
                label: l10n.log,
                isSelected: _selectedIndex == 2,
                onTap: () => context.go(AppRoutes.log),
              ),
              _NavItem(
                icon: Icons.people_rounded,
                label: l10n.profiles,
                isSelected: _selectedIndex == 3,
                onTap: () => context.go(AppRoutes.profiles),
              ),
              _NavItem(
                icon: Icons.settings_rounded,
                label: l10n.settings,
                isSelected: _selectedIndex == 4,
                onTap: () => context.go(AppRoutes.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/app/today')) return 0;
    if (location.startsWith('/app/medications')) return 1;
    if (location.startsWith('/app/log')) return 2;
    if (location.startsWith('/app/profiles')) return 3;
    if (location.startsWith('/app/settings')) return 4;
    return 0;
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary400 : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppColors.primary800 : AppColors.neutral500,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.primary800,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
