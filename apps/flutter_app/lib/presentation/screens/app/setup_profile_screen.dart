import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:carecompanion/l10n/generated/app_localizations.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/wheel_picker.dart';
import '../../../domain/entities/profile.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';

class SetupProfileScreen extends ConsumerStatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  ConsumerState<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends ConsumerState<SetupProfileScreen> {
  int _currentStep = 0;
  Gender? _selectedGender;
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  int _age = 30;
  String _selectedTimezone = 'Asia/Riyadh';
  String? _selectedBloodType;
  double? _weight;
  double? _height;
  List<String> _allergies = [];
  List<String> _medicalConditions = [];
  bool _isLoading = false;

  final List<String> _timezones = ['Asia/Riyadh', 'Asia/Dubai', 'Asia/Kuwait', 'Africa/Cairo', 'Europe/London', 'America/New_York'];

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onNext() {
    final isAr = AppLocalizations.of(context)!.localeName == 'ar';
    if (_currentStep == 0 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isAr ? 'أدخل اسمك' : 'Enter your name'), backgroundColor: AppColors.error));
      return;
    }
    if (_currentStep < 2) {
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
        relationship: Relationship.self_.value,
        type: ProfileType.self_,
        dateOfBirth: DateTime(DateTime.now().year - _age, 1, 1),
        gender: _selectedGender,
        timezoneHome: _selectedTimezone,
      );

      if (id != null) {
        await ref.read(profileNotifierProvider.notifier).updateProfile(
          profileId: id,
          weightKg: _weight,
          heightCm: _height,
          bloodType: _selectedBloodType,
          allergies: _allergies.isNotEmpty ? _allergies : null,
          medicalConditions: _medicalConditions.isNotEmpty ? _medicalConditions : null,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        );
        ref.read(selectedProfileIdProvider.notifier).state = id;
        
        // Refresh profiles
        ref.invalidate(profilesProvider);
      }

      if (mounted) {
        final isAr = AppLocalizations.of(context)!.localeName == 'ar';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(isAr ? 'مرحباً بك! تم إنشاء ملفك الشخصي' : 'Welcome! Your profile has been created'),
          backgroundColor: AppColors.success,
        ));
        context.go(AppRoutes.today);
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary800,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  Icon(Icons.celebration, size: 48, color: AppColors.secondary400),
                  const SizedBox(height: 12),
                  Text(isAr ? 'مرحباً بك في عيوني!' : 'Welcome to In My Eyes!', style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(isAr ? 'لنبدأ بإنشاء ملفك الشخصي' : 'Let\'s create your profile', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) => Container(
                      width: i == _currentStep ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(color: i <= _currentStep ? AppColors.secondary400 : Colors.white30, borderRadius: BorderRadius.circular(4)),
                    )),
                  ),
                ],
              ),
            ),
            Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: _buildStep(isAr, theme))),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.neutral100, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))]),
              child: Row(
                children: [
                  if (_currentStep > 0) Expanded(child: OutlinedButton(onPressed: () => setState(() => _currentStep--), child: Text(isAr ? 'السابق' : 'Back'))),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isLoading ? null : _onNext,
                      child: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(_currentStep == 2 ? (isAr ? 'ابدأ الآن' : 'Start Now') : (isAr ? 'التالي' : 'Next')),
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
      case 0: return _stepBasicInfo(isAr, theme);
      case 1: return _stepHealthInfo(isAr, theme);
      case 2: return _stepSummary(isAr, theme);
      default: return const SizedBox();
    }
  }

  Widget _stepBasicInfo(bool isAr, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isAr ? 'معلوماتك الأساسية' : 'Your Basic Info', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary800)),
        const SizedBox(height: 8),
        Text(isAr ? 'هذه المعلومات تساعدنا في تخصيص تجربتك' : 'This helps us personalize your experience', style: TextStyle(color: AppColors.neutral500)),
        const SizedBox(height: 24),
        TextField(controller: _nameController, decoration: InputDecoration(labelText: isAr ? 'اسمك *' : 'Your Name *', prefixIcon: Icon(Icons.person_outline, color: AppColors.neutral400))),
        const SizedBox(height: 20),
        Text(isAr ? 'الجنس' : 'Gender', style: theme.textTheme.titleSmall?.copyWith(color: AppColors.neutral500)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _GenderCard(icon: Icons.male, label: isAr ? 'ذكر' : 'Male', selected: _selectedGender == Gender.male, onTap: () => setState(() => _selectedGender = Gender.male))),
          const SizedBox(width: 12),
          Expanded(child: _GenderCard(icon: Icons.female, label: isAr ? 'أنثى' : 'Female', selected: _selectedGender == Gender.female, onTap: () => setState(() => _selectedGender = Gender.female))),
        ]),
        const SizedBox(height: 24),
        AgeWheelPicker(
          title: isAr ? 'العمر' : 'Age',
          subtitle: isAr ? 'عمرك يساعدنا في تقديم نصائح مناسبة' : 'Your age helps us recommend safe advice',
          initialAge: _age,
          minAge: 1,
          maxAge: 120,
          onChanged: (age) => setState(() => _age = age),
          isAr: isAr,
        ),
      ],
    );
  }

  Widget _stepHealthInfo(bool isAr, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isAr ? 'معلوماتك الصحية' : 'Your Health Info', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary800)),
        const SizedBox(height: 8),
        Text(isAr ? 'اختياري - يمكنك تحديثها لاحقاً' : 'Optional - update later', style: TextStyle(color: AppColors.neutral500)),
        const SizedBox(height: 24),
        WeightWheelPicker(
          title: isAr ? 'الوزن' : 'Weight',
          subtitle: isAr ? 'كم وزنك الحالي؟' : 'Your current weight?',
          initialValue: _weight ?? 70,
          minValue: 20, maxValue: 200,
          onChanged: (v) => setState(() => _weight = v),
          isAr: isAr,
        ),
        const SizedBox(height: 24),
        HeightWheelPicker(
          title: isAr ? 'الطول' : 'Height',
          subtitle: isAr ? 'كم طولك؟' : 'How tall are you?',
          initialValue: _height ?? 170,
          minValue: 100, maxValue: 220,
          onChanged: (v) => setState(() => _height = v),
          isAr: isAr,
        ),
        const SizedBox(height: 24),
        BloodTypePicker(
          title: isAr ? 'فصيلة الدم' : 'Blood Type',
          subtitle: isAr ? 'اختر فصيلة دمك' : 'Select your blood type',
          selectedType: _selectedBloodType,
          onChanged: (v) => setState(() => _selectedBloodType = v),
          isAr: isAr,
        ),
        const SizedBox(height: 24),
        MedicalInfoInput(
          title: isAr ? 'البيانات الطبية' : 'Medical Data',
          subtitle: isAr ? 'أضف الحساسية والحالات المرضية' : 'Add allergies and conditions',
          hintAllergies: isAr ? 'مثال: البنسلين' : 'e.g. Penicillin',
          hintConditions: isAr ? 'مثال: السكري' : 'e.g. Diabetes',
          allergies: _allergies,
          conditions: _medicalConditions,
          onAllergiesChanged: (v) => setState(() => _allergies = v),
          onConditionsChanged: (v) => setState(() => _medicalConditions = v),
          isAr: isAr,
        ),
      ],
    );
  }

  Widget _stepSummary(bool isAr, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isAr ? 'جاهز للانطلاق!' : 'Ready to Go!', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary800)),
        const SizedBox(height: 8),
        Text(isAr ? 'راجع بياناتك قبل البدء' : 'Review your info', style: TextStyle(color: AppColors.neutral500)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.cardLight, AppColors.cardLightAlt], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Row(children: [
                CircleAvatar(backgroundColor: AppColors.primary700, radius: 36, child: Text(_nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28))),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_nameController.text.isNotEmpty ? _nameController.text : '---', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary800)),
                  if (_age > 0) ...[const SizedBox(height: 4), Text('$_age ${isAr ? 'سنة' : 'years'}', style: TextStyle(color: AppColors.primary700))],
                ])),
              ]),
              if (_weight != null || _height != null || _selectedBloodType != null) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  if (_weight != null) _SummaryItem(icon: Icons.monitor_weight_outlined, label: '${_weight!.round()} kg'),
                  if (_height != null) _SummaryItem(icon: Icons.height, label: '${_height!.round()} cm'),
                  if (_selectedBloodType != null) _SummaryItem(icon: Icons.bloodtype_outlined, label: _selectedBloodType!),
                ]),
              ],
              if (_allergies.isNotEmpty || _medicalConditions.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                if (_allergies.isNotEmpty) ...[
                  Row(children: [Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20), const SizedBox(width: 8), Text(isAr ? 'الحساسية:' : 'Allergies:', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary800))]),
                  const SizedBox(height: 4),
                  Text(_allergies.join(', '), style: TextStyle(color: AppColors.neutral500)),
                ],
                if (_medicalConditions.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(children: [Icon(Icons.medical_information_outlined, color: AppColors.info, size: 20), const SizedBox(width: 8), Text(isAr ? 'الحالات المرضية:' : 'Conditions:', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary800))]),
                  const SizedBox(height: 4),
                  Text(_medicalConditions.join(', '), style: TextStyle(color: AppColors.neutral500)),
                ],
              ],
            ],
          ),
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
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.info.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.info.withOpacity(0.3))),
          child: Row(children: [
            Icon(Icons.lightbulb_outline, color: AppColors.info),
            const SizedBox(width: 12),
            Expanded(child: Text(isAr ? 'بعد ذلك يمكنك إضافة أفراد عائلتك وإدارة أدويتهم' : 'Next, you can add family members and manage their medications', style: TextStyle(color: AppColors.info, fontSize: 13))),
          ]),
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
      decoration: BoxDecoration(color: selected ? AppColors.cardLight : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: selected ? AppColors.primary700 : AppColors.neutral300, width: selected ? 2 : 1)),
      child: Column(children: [
        Icon(icon, color: selected ? AppColors.primary700 : AppColors.neutral400, size: 32),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: AppColors.primary800, fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
      ]),
    ),
  );
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SummaryItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Column(children: [
    Icon(icon, color: AppColors.primary700, size: 24),
    const SizedBox(height: 4),
    Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary800)),
  ]);
}
