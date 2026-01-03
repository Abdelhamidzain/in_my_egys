import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:carecompanion/l10n/generated/app_localizations.dart';
import '../../providers/profile_provider.dart';
import '../../providers/medication_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/profile.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  bool _hasCheckedProfiles = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = l10n.localeName == 'ar';
    final profilesAsync = ref.watch(profilesProvider);
    final selectedId = ref.watch(selectedProfileIdProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: SafeArea(
        child: profilesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (profiles) {
            // Redirect to setup if no profiles (only once)
            if (profiles.isEmpty && !_hasCheckedProfiles) {
              _hasCheckedProfiles = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) context.go(AppRoutes.setupProfile);
              });
              return const Center(child: CircularProgressIndicator());
            }
            
            if (profiles.isEmpty) {
              return _EmptyState(isAr: isAr);
            }

            final currentProfile = profiles.firstWhere(
              (p) => p.id == selectedId,
              orElse: () => profiles.first,
            );

            // Set selected profile if not set
            if (selectedId == null && profiles.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(selectedProfileIdProvider.notifier).state = profiles.first.id;
              });
            }

            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _getGreeting(isAr),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary800,
                        ),
                      ),
                      Text(
                        _getDateString(isAr),
                        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.neutral500),
                      ),
                    ],
                  ),
                ),

                // Profile selector
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () => _showProfileSwitcher(context, ref, profiles, currentProfile, isAr),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.neutral300),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.cardLight,
                            radius: 24,
                            child: Text(
                              currentProfile.initials,
                              style: const TextStyle(
                                color: AppColors.primary800,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentProfile.displayName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary800,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  currentProfile.relationship.getLabel(isAr ? 'ar' : 'en'),
                                  style: TextStyle(color: AppColors.neutral500, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          if (profiles.length > 1)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.cardLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${profiles.length}',
                                style: const TextStyle(
                                  color: AppColors.primary800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          Icon(Icons.keyboard_arrow_down, color: AppColors.neutral500),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Content
                Expanded(
                  child: _TodayContent(profile: currentProfile, isAr: isAr),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getGreeting(bool isAr) {
    final hour = DateTime.now().hour;
    if (hour < 12) return isAr ? 'صباح الخير' : 'Good Morning';
    if (hour < 17) return isAr ? 'مساء الخير' : 'Good Afternoon';
    return isAr ? 'مساء الخير' : 'Good Evening';
  }

  String _getDateString(bool isAr) {
    final now = DateTime.now();
    final weekdays = isAr
        ? ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت']
        : ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final months = isAr
        ? ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر']
        : ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${weekdays[now.weekday % 7]}، ${now.day} ${months[now.month - 1]}';
  }

  void _showProfileSwitcher(BuildContext context, WidgetRef ref, List<Profile> profiles, Profile current, bool isAr) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.neutral300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isAr ? 'اختر الملف' : 'Choose Profile',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary800),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.push(AppRoutes.createProfile);
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(isAr ? 'إضافة' : 'Add'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...profiles.map((p) {
              final isSelected = p.id == current.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () {
                    ref.read(selectedProfileIdProvider.notifier).state = p.id;
                    Navigator.pop(ctx);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.cardLight : AppColors.neutral100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.primary700 : AppColors.neutral300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        // Avatar (right in Arabic)
                        CircleAvatar(
                          backgroundColor: isSelected ? AppColors.primary700 : AppColors.cardLight,
                          radius: 24,
                          child: Text(
                            p.initials,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.primary800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Name & relationship
                        Expanded(
                          child: Column(
                            crossAxisAlignment: isAr ? CrossAxisAlignment.start : CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.displayName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary800,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                p.relationship.getLabel(isAr ? 'ar' : 'en'),
                                style: TextStyle(color: AppColors.neutral500, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        // Checkbox (left in Arabic)
                        if (isSelected)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.primary700,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 16),
                          )
                        else
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.neutral400),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _TodayContent extends ConsumerWidget {
  final Profile profile;
  final bool isAr;

  const _TodayContent({required this.profile, required this.isAr});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medsAsync = ref.watch(medicationsProvider);

    return medsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (meds) {
        if (meds.isEmpty) {
          return _NoMedsState(isAr: isAr);
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: meds.length,
          itemBuilder: (ctx, i) {
            final med = meds[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neutral300),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.medication, color: AppColors.primary700),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(med.name, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary800)),
                        Text('${med.dosageAmount} ${med.dosageUnit}', style: TextStyle(color: AppColors.neutral500, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _NoMedsState extends StatelessWidget {
  final bool isAr;
  const _NoMedsState({required this.isAr});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.cardLight.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle_outline, size: 64, color: AppColors.primary700),
          ),
          const SizedBox(height: 24),
          Text(
            isAr ? 'لا توجد جرعات اليوم' : 'No doses today',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary800),
          ),
          const SizedBox(height: 8),
          Text(
            isAr ? 'أضف أدوية لبدء تتبع جرعاتك' : 'Add medications to start tracking',
            style: TextStyle(color: AppColors.neutral500),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.medications),
            icon: const Icon(Icons.add),
            label: Text(isAr ? 'إضافة دواء' : 'Add Medication'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isAr;
  const _EmptyState({required this.isAr});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add_outlined, size: 64, color: AppColors.neutral400),
          const SizedBox(height: 16),
          Text(isAr ? 'أنشئ ملفك الشخصي للبدء' : 'Create your profile to get started',
              style: TextStyle(color: AppColors.neutral500)),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.go(AppRoutes.setupProfile),
            child: Text(isAr ? 'إنشاء ملف' : 'Create Profile'),
          ),
        ],
      ),
    );
  }
}





