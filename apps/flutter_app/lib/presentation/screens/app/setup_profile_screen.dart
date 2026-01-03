import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:carecompanion/l10n/generated/app_localizations.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/wheel_picker.dart';
import '../../../domain/entities/profile.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';

/// This screen is shown ONLY after signup - for creating the user's own profile
class SetupProfileScreen extends ConsumerStatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  ConsumerState<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends ConsumerState<SetupProfileScreen> {
  int _currentStep = 0; // 0: Basic, 1: Health, 2: Summary
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

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onNext() {
    final isAr = AppLocalizations.of(context)!.localeName == 'ar';
    if (_currentStep == 0 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isAr ? 'أدخل اسمك' : 'Enter your name'),
        backgroundColor: AppColors.error,
      ));
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
        dateOfBirth: _dateOfBirth,
        gender: _selectedGender,
        timezoneHome: _selectedTimezone,
      );
      
      if (id != null && (_weight != null || _height != null || _selectedBloodType != null || _notesController.text.isNotEmpty)) {
        await ref.read(profileNotifierProvider.notifier).updateProfile(
          profileId: id,
          weightKg: _weight,
          heightCm: _height,
          bloodType: _selectedBloodType,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        );
      }
      
      if (id != null) ref.read(selectedProfileIdProvider.notifier).state = id;
      
      if (mounted) {
        context.go(AppRoutes.today);
        final isAr = AppLocalizations.of(context)!.localeName == 'ar';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(isAr ? 'مرحباً بك! تم إنشاء ملفك الشخصي' : 'Welcome! Your profile has been created'),
          backgroundColor: AppColors.success,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ));
      }
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
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.celebration, size: 48, color: AppColors.secondary400),
                  const SizedBox(height: 12),
                  Text(
                    isAr ? 'مرحباً بك في عيوني!' : 'Welcome to In My Eyes!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isAr ? 'لنبدأ بإنشاء ملفك الشخصي' : 'Let\'s start by creating your profile',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) => Container(
                      width: i == _currentStep ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: i <= _currentStep ? AppColors.secondary400 : Colors.white30,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                ],
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
                        child: Text(isAr ? 'السابق' : 'Back'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: _currentStep == 0 ? 1 : 1,
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
        Text(isAr ? 'معلوماتك الأساسية' : 'Your Basic Info',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary800)),
        const SizedBox(height: 8),
        Text(isAr ? 'هذه المعلومات تساعدنا في تخصيص تجربتك' : 'This helps us personalize your experience',
            style: TextStyle(color: AppColors.neutral500)),
        const SizedBox(height: 24),
        
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: isAr ? 'اسمك *' : 'Your Name *',
            prefixIcon: Icon(Icons.person_outline, color: AppColors.neutral400),
          ),
        ),
        const SizedBox(height: 20),
        
        Text(isAr ? 'الجنس' : 'Gender', style: theme.textTheme.titleSmall?.copyWith(color: AppColors.neutral500)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _GenderCard(
            icon: Icons.male, 
            label: isAr ? 'ذكر' : 'Male', 
            selected: _selectedGender == Gender.male, 
            onTap: () => setState(() => _selectedGender = Gender.male),
          )),
          const SizedBox(width: 12),
          Expanded(child: _GenderCard(
            icon: Icons.female, 
            label: isAr ? 'أنثى' : 'Female', 
            selected: _selectedGender == Gender.female, 
            onTap: () => setState(() => _selectedGender = Gender.female),
          )),
        ]),
        const SizedBox(height: 24),
        
        BirthdateWheelPicker(
          title: isAr ? 'تاريخ الميلاد' : 'Date of Birth',
          subtitle: isAr ? 'عمرك يساعدنا في تقديم نصائح مناسبة' : 'Your age helps us recommend safe advice',
          initialDate: _dateOfBirth,
          minAge: 1,
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
        Text(isAr ? 'معلوماتك الصحية' : 'Your Health Info',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary800)),
        const SizedBox(height: 8),
        Text(isAr ? 'اختياري - يمكنك تحديثها لاحقاً' : 'Optional - you can update later',
            style: TextStyle(color: AppColors.neutral500)),
        const SizedBox(height: 24),
        
        WeightWheelPicker(
          title: isAr ? 'الوزن' : 'Weight',
          subtitle: isAr ? 'كم وزنك الحالي؟' : 'What is your current weight?',
          initialValue: _weight ?? 70,
          minValue: 20,
          maxValue: 200,
          onChanged: (v) => setState(() => _weight = v),
          isAr: isAr,
        ),
        const SizedBox(height: 24),
        
        HeightWheelPicker(
          title: isAr ? 'الطول' : 'Height',
          subtitle: isAr ? 'كم طولك؟' : 'How tall are you?',
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
        Text(isAr ? 'جاهز للانطلاق!' : 'Ready to Go!',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary800)),
        const SizedBox(height: 8),
        Text(isAr ? 'راجع بياناتك قبل البدء' : 'Review your info before starting',
            style: TextStyle(color: AppColors.neutral500)),
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
              radius: 36,
              child: Text(
                _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                _nameController.text.isNotEmpty ? _nameController.text : '---',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary800),
              ),
              const SizedBox(height: 4),
              if (_dateOfBirth != null)
                Text(
                  '${DateTime.now().year - _dateOfBirth!.year} ${isAr ? 'سنة' : 'years old'}',
                  style: TextStyle(color: AppColors.primary700),
                ),
            ])),
          ]),
        ),
        
        const SizedBox(height: 24),
        
        Text(isAr ? 'المنطقة الزمنية' : 'Timezone', style: theme.textTheme.titleSmall?.copyWith(color: AppColors.neutral500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.neutral300),
          ),
          child: DropdownButtonHideUnderline(child: DropdownButton<String>(
            value: _selectedTimezone, isExpanded: true, dropdownColor: Colors.white,
            items: _timezones.map((tz) => DropdownMenuItem(
              value: tz,
              child: Text(_tzLabel(tz, isAr), style: TextStyle(color: AppColors.primary800)),
            )).toList(),
            onChanged: (v) { if (v != null) setState(() => _selectedTimezone = v); },
          )),
        ),
        
        const SizedBox(height: 32),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
          ),
          child: Row(children: [
            Icon(Icons.lightbulb_outline, color: AppColors.info),
            const SizedBox(width: 12),
            Expanded(child: Text(
              isAr ? 'بعد ذلك يمكنك إضافة أفراد عائلتك وإدارة أدويتهم' : 'Next, you can add family members and manage their medications',
              style: TextStyle(color: AppColors.info, fontSize: 13),
            )),
          ]),
        ),
      ],
    );
  }

  String _tzLabel(String tz, bool isAr) {
    final labels = {
      'Asia/Riyadh': isAr ? 'الرياض' : 'Riyadh',
      'Asia/Dubai': isAr ? 'دبي' : 'Dubai',
      'Asia/Kuwait': isAr ? 'الكويت' : 'Kuwait',
      'Africa/Cairo': isAr ? 'القاهرة' : 'Cairo',
      'Europe/London': isAr ? 'لندن' : 'London',
      'America/New_York': isAr ? 'نيويورك' : 'New York',
    };
    return labels[tz] ?? tz;
  }
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
