import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carecompanion/l10n/generated/app_localizations.dart';
import '../../providers/medication_provider.dart';
import '../../providers/profile_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/medication.dart';

class MedicationsScreen extends ConsumerWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentProfile = ref.watch(currentProfileProvider);
    final medicationsAsync = ref.watch(medicationsProvider);
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.medications,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: currentProfile != null 
                        ? () => _showAddMedicationDialog(context, ref, l10n, theme, currentProfile.id)
                        : null,
                    icon: const Icon(Icons.add, size: 20),
                    label: Text(l10n.addMedication),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Content
              Expanded(
                child: currentProfile == null
                    ? _NoProfileState(l10n: l10n, theme: theme)
                    : medicationsAsync.when(
                        data: (medications) => medications.isEmpty
                            ? _EmptyState(
                                l10n: l10n, 
                                theme: theme,
                                onAdd: () => _showAddMedicationDialog(context, ref, l10n, theme, currentProfile.id),
                              )
                            : ListView.builder(
                                itemCount: medications.length,
                                itemBuilder: (context, index) {
                                  final med = medications[index];
                                  return _MedicationCard(
                                    medication: med,
                                    l10n: l10n,
                                    theme: theme,
                                  );
                                },
                              ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 48, color: AppColors.error),
                              const SizedBox(height: 16),
                              Text(l10n.errorLoadingMedications),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddMedicationDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n, ThemeData theme, String profileId) {
    final nameController = TextEditingController();
    final instructionsController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutral600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              l10n.addMedication,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Name input
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.medicationName,
                hintText: l10n.localeName == 'ar' ? 'مثال: باراسيتامول' : 'e.g. Paracetamol',
                prefixIcon: const Icon(Icons.medication_outlined),
              ),
            ),
            const SizedBox(height: 16),
            
            // Instructions input
            TextField(
              controller: instructionsController,
              decoration: InputDecoration(
                labelText: (l10n.localeName == 'ar' ? 'التعليمات (اختياري)' : 'Instructions (optional)'),
                hintText: l10n.localeName == 'ar' ? 'مثال: قرص واحد بعد الأكل' : 'e.g. Take with food',
                prefixIcon: const Icon(Icons.notes_outlined),
              ),
            ),
            const SizedBox(height: 24),
            
            // Add button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(
                        content: Text(l10n.errorRequired),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return;
                  }
                  
                  Navigator.pop(ctx);
                  
                  // Show loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          SizedBox(
                            width: 20, 
                            height: 20, 
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          ),
                          SizedBox(width: 16),
                          Text(l10n.localeName == 'ar' ? 'جاري الإضافة...' : 'Adding...'),
                        ],
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  
                  try {
                    await ref.read(medicationNotifierProvider.notifier).createMedication(
                      profileId: profileId,
                      name: name,
                      instructionsText: instructionsController.text.trim().isNotEmpty 
                          ? instructionsController.text.trim() 
                          : null,
                    );
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.localeName == 'ar' ? 'تمت إضافة الدواء' : 'Medication added'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  }
                },
                child: Text(l10n.addMedication),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoProfileState extends StatelessWidget {
  final AppLocalizations l10n;
  final ThemeData theme;
  
  const _NoProfileState({required this.l10n, required this.theme});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off_outlined, size: 64, color: AppColors.neutral500),
          const SizedBox(height: 16),
          Text(l10n.noProfileSelected, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            l10n.noProfilesDescription,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.neutral400),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  final ThemeData theme;
  final VoidCallback onAdd;
  
  const _EmptyState({required this.l10n, required this.theme, required this.onAdd});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.primary700,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.medication_outlined, size: 56, color: AppColors.secondary400),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noMedicationsYet,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.addFirstMedication,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.neutral400),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(l10n.addMedication),
          ),
        ],
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final Medication medication;
  final AppLocalizations l10n;
  final ThemeData theme;
  
  const _MedicationCard({
    required this.medication,
    required this.l10n,
    required this.theme,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.neutral800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary700,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.medication, color: AppColors.secondary400),
        ),
        title: Text(
          medication.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.neutral100,
          ),
        ),
        subtitle: medication.instructionsText != null
            ? Text(
                medication.instructionsText!,
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.neutral400),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: medication.isActive ? AppColors.success.withValues(alpha: 0.2) : AppColors.neutral700,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            medication.isActive 
                ? (l10n.localeName == 'ar' ? 'نشط' : 'Active')
                : (l10n.localeName == 'ar' ? 'متوقف' : 'Paused'),
            style: TextStyle(
              color: medication.isActive ? AppColors.success : AppColors.neutral400,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

