import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:carecompanion/l10n/generated/app_localizations.dart';
import '../../providers/profile_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/profile.dart';

class ProfilesScreen extends ConsumerWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = l10n.localeName == 'ar';
    final profilesAsync = ref.watch(profilesProvider);
    final selectedId = ref.watch(selectedProfileIdProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        title: Text(isAr ? 'الملفات الشخصية' : 'Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(AppRoutes.createProfile),
          ),
        ],
      ),
      body: profilesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profiles) {
          if (profiles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: AppColors.neutral400),
                  const SizedBox(height: 16),
                  Text(isAr ? 'لا توجد ملفات' : 'No profiles', style: TextStyle(color: AppColors.neutral500)),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.push(AppRoutes.createProfile),
                    icon: const Icon(Icons.add),
                    label: Text(isAr ? 'إنشاء ملف' : 'Create Profile'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: profiles.length,
            itemBuilder: (ctx, i) {
              final p = profiles[i];
              final isSelected = p.id == selectedId;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    ref.read(selectedProfileIdProvider.notifier).state = p.id;
                  },
                  onLongPress: () => _showProfileOptions(context, ref, p, isAr),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.cardLight : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.primary700 : AppColors.neutral300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: isSelected ? AppColors.primary700 : AppColors.cardLight,
                          radius: 28,
                          child: Text(
                            p.initials,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.primary800,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.displayName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColors.primary800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary700.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      p.relationship.getLabel(isAr ? 'ar' : 'en'),
                                      style: const TextStyle(fontSize: 12, color: AppColors.primary700),
                                    ),
                                  ),
                                  if (p.age != null) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      '${p.age} ${isAr ? 'سنة' : 'y'}',
                                      style: TextStyle(fontSize: 12, color: AppColors.neutral500),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.primary700,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 16),
                          ),
                        IconButton(
                          icon: Icon(Icons.more_vert, color: AppColors.neutral500),
                          onPressed: () => _showProfileOptions(context, ref, p, isAr),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showProfileOptions(BuildContext context, WidgetRef ref, Profile profile, bool isAr) {
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
              decoration: BoxDecoration(color: AppColors.neutral300, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              backgroundColor: AppColors.cardLight,
              radius: 32,
              child: Text(profile.initials, style: const TextStyle(color: AppColors.primary800, fontWeight: FontWeight.bold, fontSize: 24)),
            ),
            const SizedBox(height: 12),
            Text(profile.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary800)),
            Text(profile.relationship.getLabel(isAr ? 'ar' : 'en'), style: TextStyle(color: AppColors.neutral500)),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.cardLight, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.edit, color: AppColors.primary700),
              ),
              title: Text(isAr ? 'تعديل' : 'Edit', style: const TextStyle(color: AppColors.primary800)),
              onTap: () {
                Navigator.pop(ctx);
                // TODO: Navigate to edit screen
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.delete, color: AppColors.error),
              ),
              title: Text(isAr ? 'حذف' : 'Delete', style: const TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context, ref, profile, isAr);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Profile profile, bool isAr) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isAr ? 'حذف الملف' : 'Delete Profile', style: const TextStyle(color: AppColors.primary800)),
        content: Text(
          isAr ? 'هل أنت متأكد من حذف "${profile.displayName}"؟ سيتم حذف جميع الأدوية والسجلات.' 
              : 'Are you sure you want to delete "${profile.displayName}"? All medications and records will be deleted.',
          style: TextStyle(color: AppColors.neutral600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isAr ? 'إلغاء' : 'Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(profileNotifierProvider.notifier).deleteProfile(profile.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isAr ? 'تم الحذف' : 'Deleted'), backgroundColor: AppColors.success),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(isAr ? 'حذف' : 'Delete'),
          ),
        ],
      ),
    );
  }
}
