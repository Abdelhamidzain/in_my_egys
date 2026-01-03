import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:carecompanion/l10n/generated/app_localizations.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/wheel_picker.dart';
import '../../../domain/entities/profile.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';

/// This screen is for adding family members (always "for someone else")
class CreateProfileScreen extends ConsumerStatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  ConsumerState<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends ConsumerState<CreateProfileScreen> {
  int _currentStep = 0; // 0: Relationship, 1: Basic, 2: Health, 3: Summary
  Map<Relationship, int> _relationshipCounts = {};
  Relationship _selectedRelationship = Relationship.mother;
  Gender? _selectedGender;
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _dateOfBirth;
  String _selectedTimezone = 'Asia/Riyadh';
  String? _selectedBloodType;
  double? _weight;
  double? _height;
  bool _isLoading = false;

  final List<String> _timezones = [
    'Asia/Riyadh', 'Asia/Dubai', 'Asia/Kuwait',
    'Africa/Cairo', 'Europe/London', 'America/New_York',
  ];

  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  final Map<Relationship, int> _relationshipLimits = {
    Relationship.mother: 1,
    Relationship.father: 1,
    Relationship.husband: 1,
    Relationship.wife: 4,
    Relationship.grandmother: 2,
    Relationship.grandfather: 2,
  };

  @override
  void initState() {
    super.initState();
    _selectedGender = _selectedRelationship.defaultGender;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRelationshipCounts());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  DateTime? _getSelfBirthDate() {
    final profiles = ref.read(profilesProvider).valueOrNull ?? [];
    final selfProfile = profiles.where((p) => p.relationship == Relationship.self_).firstOrNull;
    return selfProfile?.dateOfBirth;
  }

  int _getMinimumAgeGap(Relationship rel) {
    switch (rel) {
      case Relationship.mother:
      case Relationship.father:
        return 12;
      case Relationship.grandmother:
      case Relationship.grandfather:
        return 24;
      default:
        return 0;
    }
  }

  void _loadRelationshipCounts() {
    final profiles = ref.read(profilesProvider).valueOrNull ?? [];
    final counts = <Relationship, int>{};
    for (final profile in profiles) {
      counts[profile.relationship] = (counts[profile.relationship] ?? 0) + 1;
    }
    setState(() {
      _relationshipCounts = counts;
      _selectedRelationship = _getFirstAvailableRelationship();
      _selectedGender = _selectedRelationship.defaultGender;
    });
  }

  bool _isRelationshipAvailable(Relationship rel) {
    if (rel == Relationship.self_) return false;
    final limit = _relationshipLimits[rel];
    if (limit == null) return true;
    return (_relationshipCounts[rel] ?? 0) < limit;
  }

  Relationship _getFirstAvailableRelationship() {
    for (final rel in Relationship.forOthers) {
      if (_isRelationshipAvailable(rel)) return rel;
    }
    return Relationship.other;
  }

  void _onNext() {
    final isAr = AppLocalizations.of(context)!.localeName == 'ar';
    if (_currentStep == 1 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isAr ? 'أدخل الاسم' : 'Enter name'),
        backgroundColor: AppColors.error,
      ));
      return;
    }
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _create();
    }
  }

  Future<void> _create() async {
    setState(() => _isLoading = true);
    try {
      final id = await ref.read(profileNotifierProvider.notifier).createProfile(
        displayName: _nameController.text.trim(),
        relationship: _selectedRelationship.value,
        type: ProfileType.managed,
        dateOfBirth: _dateOfBirth,
        gender: _selectedGender,
        timezoneHome: _selectedTimezone,
      );
      if (id != null && (_weight != null || _height != null || _selectedBloodType != null || _notesController.text.isNotEmpty)) {
        await ref.read(profileNotifierProvider.notifier).updateProfile(
          profileId: id, weightKg: _weight, heightCm: _height,
          bloodType: _selectedBloodType,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        );
      }
      if (mounted) {
        context.go(AppRoutes.today);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.profileCreated),
          backgroundColor: AppColors.success,
        ));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isAr = l10n.localeName == 'ar';

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        title: Text(isAr ? 'إضافة فرد من العائلة' : 'Add Family Member'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: AppColors.neutral100,
              child: Row(
                children: List.generate(4, (i) => Expanded(
                  child: Container(
                    height: 6,
                    margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
                    decoration: BoxDecoration(
                      color: i <= _currentStep ? AppColors.secondary400 : AppColors.neutral300,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                )),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildStep(isAr, theme),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2))],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _currentStep--),
                        child: Text(isAr ? 'السابق' : 'Previous'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isLoading ? null : _onNext,
                      child: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(_currentStep == 3 ? (isAr ? 'إضافة' : 'Add') : (isAr ? 'التالي' : 'Next')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(bool isAr, ThemeData theme) {
    switch (_currentStep) {
      case 0: return _stepRelationship(isAr, theme);
      case 1: return _stepBasicInfo(isAr, theme);
      case 2: return _stepHealthInfo(isAr, theme);
      case 3: return _stepSummary(isAr, theme);
      default: return const SizedBox();
    }
  }

  Widget _stepRelationship(bool isAr, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isAr ? 'من تريد إضافته؟' : 'Who do you want to add?',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary800)),
        const SizedBox(height: 8),
        Text(isAr ? 'اختر علاقتك بهذا الشخص' : 'Choose your relationship with this person',
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.neutral500)),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: Relationship.forOthers.map((rel) {
            final selected = _selectedRelationship == rel;
            final available = _isRelationshipAvailable(rel);
            final count = _relationshipCounts[rel] ?? 0;
            return Opacity(
              opacity: available ? 1.0 : 0.5,
              child: ChoiceChip(
                label: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(rel.getLabel(isAr ? 'ar' : 'en')),
                  if (rel == Relationship.wife && count > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(color: available ? AppColors.primary700 : AppColors.error, borderRadius: BorderRadius.circular(8)),
                      child: Text('$count/4', style: const TextStyle(fontSize: 10, color: Colors.white)),
                    ),
                  ] else if (!available) ...[const SizedBox(width: 4), const Icon(Icons.check, size: 14, color: AppColors.success)],
                ]),
                selected: selected,
                onSelected: available ? (s) { if (s) setState(() { _selectedRelationship = rel; _selectedGender = rel.defaultGender; }); } : null,
                selectedColor: AppColors.cardLight,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(color: AppColors.primary800, fontWeight: selected ? FontWeight.w600 : FontWeight.normal),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: selected ? AppColors.primary700 : AppColors.neutral300)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _stepBasicInfo(bool isAr, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isAr ? 'المعلومات الأساسية' : 'Basic Info', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary800)),
        const SizedBox(height: 8),
        Text(isAr ? 'أدخل بيانات ${_selectedRelationship.getLabel('ar')}' : 'Enter ${_selectedRelationship.getLabel('en')}\'s information',
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.neutral500)),
        const SizedBox(height: 24),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: isAr ? 'الاسم *' : 'Name *', prefixIcon: Icon(Icons.person_outline, color: AppColors.neutral400)),
        ),
        const SizedBox(height: 16),
        if (_selectedRelationship.defaultGender == null) ...[
          Text(isAr ? 'الجنس' : 'Gender', style: theme.textTheme.titleSmall?.copyWith(color: AppColors.neutral500)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _GenderCard(icon: Icons.male, label: isAr ? 'ذكر' : 'Male', selected: _selectedGender == Gender.male, onTap: () => setState(() => _selectedGender = Gender.male))),
            const SizedBox(width: 12),
            Expanded(child: _GenderCard(icon: Icons.female, label: isAr ? 'أنثى' : 'Female', selected: _selectedGender == Gender.female, onTap: () => setState(() => _selectedGender = Gender.female))),
          ]),
          const SizedBox(height: 24),
        ],
        BirthdateWheelPicker(
          title: isAr ? 'تاريخ الميلاد' : 'Date of Birth',
          subtitle: isAr ? 'كم عمر ${_selectedRelationship.getLabel('ar')}؟' : 'How old is ${_selectedRelationship.getLabel('en')}?',
          initialDate: _dateOfBirth,
          minAge: _getMinimumAgeGap(_selectedRelationship),
          maxAge: 120,
          onChanged: (date) => setState(() => _dateOfBirth = date),
          isAr: isAr,
        ),
      ],
    );
  }

  Widget _stepHealthInfo(bool isAr, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isAr ? 'المعلومات الصحية' : 'Health Info', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary800)),
        Text(isAr ? 'اختياري - يمكنك تحديثها لاحقاً' : 'Optional - you can update later', style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.neutral500)),
        const SizedBox(height: 24),
        WeightWheelPicker(
          title: isAr ? 'الوزن' : 'Weight',
          subtitle: isAr ? 'كم وزن ${_selectedRelationship.getLabel('ar')}؟' : 'How much does ${_selectedRelationship.getLabel('en')} weigh?',
          initialValue: _weight ?? 70,
          minValue: 20,
          maxValue: 200,
          onChanged: (v) => setState(() => _weight = v),
          isAr: isAr,
        ),
        const SizedBox(height: 24),
        HeightWheelPicker(
          title: isAr ? 'الطول' : 'Height',
          subtitle: isAr ? 'كم طول ${_selectedRelationship.getLabel('ar')}؟' : 'How tall is ${_selectedRelationship.getLabel('en')}?',
          initialValue: _height ?? 170,
          minValue: 100,
          maxValue: 220,
          onChanged: (v) => setState(() => _height = v),
          isAr: isAr,
        ),
        const SizedBox(height: 24),
        Text(isAr ? 'فصيلة الدم' : 'Blood Type', style: theme.textTheme.titleSmall?.copyWith(color: AppColors.neutral500)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: _bloodTypes.map((t) {
          final selected = _selectedBloodType == t;
          return ChoiceChip(
            label: Text(t), selected: selected,
            onSelected: (s) => setState(() => _selectedBloodType = s ? t : null),
            selectedColor: AppColors.cardLight, backgroundColor: Colors.white,
            labelStyle: TextStyle(color: AppColors.primary800, fontWeight: selected ? FontWeight.w600 : FontWeight.normal),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: selected ? AppColors.primary700 : AppColors.neutral300)),
          );
        }).toList()),
      ],
    );
  }

  Widget _stepSummary(bool isAr, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isAr ? 'مراجعة البيانات' : 'Review', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary800)),
        const SizedBox(height: 8),
        Text(isAr ? 'تأكد من البيانات قبل الإضافة' : 'Confirm before adding', style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.neutral500)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.cardLight, AppColors.cardLightAlt], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(children: [
            CircleAvatar(
              backgroundColor: AppColors.primary700,
              radius: 32,
              child: Text(_nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28)),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_nameController.text.isNotEmpty ? _nameController.text : '---', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary800)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary700, borderRadius: BorderRadius.circular(12)),
                child: Text(_selectedRelationship.getLabel(isAr ? 'ar' : 'en'), style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
              if (_dateOfBirth != null) ...[
                const SizedBox(height: 8),
                Text('${DateTime.now().year - _dateOfBirth!.year} ${isAr ? 'سنة' : 'years old'}', style: TextStyle(color: AppColors.primary700)),
              ],
            ])),
          ]),
        ),
        const SizedBox(height: 24),
        Text(isAr ? 'المنطقة الزمنية' : 'Timezone', style: theme.textTheme.titleSmall?.copyWith(color: AppColors.neutral500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.neutral300)),
          child: DropdownButtonHideUnderline(child: DropdownButton<String>(
            value: _selectedTimezone, isExpanded: true, dropdownColor: Colors.white,
            items: _timezones.map((tz) => DropdownMenuItem(value: tz, child: Text(_tzLabel(tz, isAr), style: TextStyle(color: AppColors.primary800)))).toList(),
            onChanged: (v) { if (v != null) setState(() => _selectedTimezone = v); },
          )),
        ),
      ],
    );
  }

  String _tzLabel(String tz, bool isAr) => {'Asia/Riyadh': isAr ? 'الرياض' : 'Riyadh', 'Asia/Dubai': isAr ? 'دبي' : 'Dubai', 'Asia/Kuwait': isAr ? 'الكويت' : 'Kuwait', 'Africa/Cairo': isAr ? 'القاهرة' : 'Cairo', 'Europe/London': isAr ? 'لندن' : 'London', 'America/New_York': isAr ? 'نيويورك' : 'New York'}[tz] ?? tz;
}

class _GenderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenderCard({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: selected ? AppColors.cardLight : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: selected ? AppColors.primary700 : AppColors.neutral300, width: selected ? 2 : 1),
      ),
      child: Column(children: [
        Icon(icon, color: selected ? AppColors.primary700 : AppColors.neutral400, size: 32),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: AppColors.primary800, fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
      ]),
    ),
  );
}
