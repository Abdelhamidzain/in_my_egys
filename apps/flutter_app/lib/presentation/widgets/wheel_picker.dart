import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../core/theme/app_theme.dart';

/// Age wheel picker (vertical)
class AgeWheelPicker extends StatefulWidget {
  final String title;
  final String subtitle;
  final int initialAge;
  final int minAge;
  final int maxAge;
  final ValueChanged<int> onChanged;
  final bool isAr;

  const AgeWheelPicker({
    super.key,
    required this.title,
    required this.subtitle,
    this.initialAge = 30,
    this.minAge = 1,
    this.maxAge = 120,
    required this.onChanged,
    required this.isAr,
  });

  @override
  State<AgeWheelPicker> createState() => _AgeWheelPickerState();
}

class _AgeWheelPickerState extends State<AgeWheelPicker> {
  late FixedExtentScrollController _scrollController;
  late int _selectedAge;

  @override
  void initState() {
    super.initState();
    _selectedAge = widget.initialAge.clamp(widget.minAge, widget.maxAge);
    _scrollController = FixedExtentScrollController(initialItem: _selectedAge - widget.minAge);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll(double delta) {
    final currentItem = _scrollController.selectedItem;
    final newItem = (currentItem + (delta > 0 ? 1 : -1)).clamp(0, widget.maxAge - widget.minAge);
    _scrollController.animateToItem(newItem, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.maxAge - widget.minAge + 1;
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD4EDBC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Column(
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary800), textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text(widget.subtitle, style: TextStyle(fontSize: 14, color: AppColors.primary800.withOpacity(0.6)), textAlign: TextAlign.center),
              ],
            ),
          ),
          SizedBox(
            height: 280,
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) _onScroll(event.scrollDelta.dy);
              },
              child: ListWheelScrollView.useDelegate(
                controller: _scrollController,
                itemExtent: 56,
                perspective: 0.003,
                diameterRatio: 1.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  final age = widget.minAge + index;
                  setState(() => _selectedAge = age);
                  widget.onChanged(age);
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: itemCount,
                  builder: (context, index) {
                    final age = widget.minAge + index;
                    final isSelected = age == _selectedAge;
                    return _VerticalWheelItem(value: age, unit: widget.isAr ? 'سنة' : 'years', isSelected: isSelected, isAr: widget.isAr);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Weight wheel picker - Horizontal ruler (FIXED - same for all languages)
class WeightWheelPicker extends StatefulWidget {
  final String title;
  final String subtitle;
  final double initialValue;
  final double minValue;
  final double maxValue;
  final ValueChanged<double> onChanged;
  final bool isAr;

  const WeightWheelPicker({
    super.key,
    required this.title,
    required this.subtitle,
    this.initialValue = 70,
    this.minValue = 20,
    this.maxValue = 200,
    required this.onChanged,
    required this.isAr,
  });

  @override
  State<WeightWheelPicker> createState() => _WeightWheelPickerState();
}

class _WeightWheelPickerState extends State<WeightWheelPicker> {
  late ScrollController _scrollController;
  late int _selectedValue;
  final double _itemWidth = 10.0;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue.round().clamp(widget.minValue.round(), widget.maxValue.round());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateValueFromScroll() {
    final offset = _scrollController.offset;
    final newValue = (offset / _itemWidth + widget.minValue).round().clamp(widget.minValue.round(), widget.maxValue.round());
    if (newValue != _selectedValue) {
      setState(() => _selectedValue = newValue);
      widget.onChanged(newValue.toDouble());
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = (widget.maxValue - widget.minValue).round();
    final totalWidth = totalItems * _itemWidth;
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD4EDBC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Column(
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary800), textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text(widget.subtitle, style: TextStyle(fontSize: 14, color: AppColors.primary800.withOpacity(0.6)), textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // Value display with KG badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$_selectedValue',
                style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: AppColors.primary800),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('kg', style: TextStyle(color: Color(0xFFB8E986), fontWeight: FontWeight.bold, fontSize: 14)),
                    Icon(Icons.keyboard_arrow_down, color: Color(0xFFB8E986), size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Ruler section
          SizedBox(
            height: 80,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final centerX = constraints.maxWidth / 2;
                final initialOffset = (_selectedValue - widget.minValue.round()) * _itemWidth;
                
                // Initialize controller here with correct offset
                _scrollController = ScrollController(initialScrollOffset: initialOffset);
                _scrollController.addListener(_updateValueFromScroll);
                
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Scrollable ruler - Directionality LTR to ignore RTL
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          final newOffset = _scrollController.offset - details.delta.dx;
                          _scrollController.jumpTo(newOffset.clamp(0.0, totalWidth));
                        },
                        child: Listener(
                          onPointerSignal: (event) {
                            if (event is PointerScrollEvent) {
                              final newOffset = _scrollController.offset + event.scrollDelta.dy;
                              _scrollController.jumpTo(newOffset.clamp(0.0, totalWidth));
                            }
                          },
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            child: Container(
                              width: totalWidth + constraints.maxWidth,
                              height: 80,
                              padding: EdgeInsets.only(left: centerX, right: centerX),
                              child: CustomPaint(
                                size: Size(totalWidth, 80),
                                painter: _WeightRulerPainter(
                                  minValue: widget.minValue.round(),
                                  maxValue: widget.maxValue.round(),
                                  itemWidth: _itemWidth,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Center indicator line
                    Positioned(
                      left: centerX - 1.5,
                      top: 0,
                      child: Container(
                        width: 3,
                        height: 45,
                        decoration: BoxDecoration(
                          color: AppColors.primary800,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Triangle indicator - pointing UP
          CustomPaint(
            size: const Size(24, 14),
            painter: _TrianglePainter(color: AppColors.primary800, pointUp: true),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Height wheel picker (vertical)
class HeightWheelPicker extends StatefulWidget {
  final String title;
  final String subtitle;
  final double initialValue;
  final double minValue;
  final double maxValue;
  final ValueChanged<double> onChanged;
  final bool isAr;

  const HeightWheelPicker({
    super.key,
    required this.title,
    required this.subtitle,
    this.initialValue = 170,
    this.minValue = 100,
    this.maxValue = 220,
    required this.onChanged,
    required this.isAr,
  });

  @override
  State<HeightWheelPicker> createState() => _HeightWheelPickerState();
}

class _HeightWheelPickerState extends State<HeightWheelPicker> {
  late FixedExtentScrollController _scrollController;
  late int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue.round().clamp(widget.minValue.round(), widget.maxValue.round());
    _scrollController = FixedExtentScrollController(initialItem: _selectedValue - widget.minValue.round());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll(double delta) {
    final currentItem = _scrollController.selectedItem;
    final maxItem = widget.maxValue.round() - widget.minValue.round();
    final newItem = (currentItem + (delta > 0 ? 1 : -1)).clamp(0, maxItem);
    _scrollController.animateToItem(newItem, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.maxValue.round() - widget.minValue.round() + 1;
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD4EDBC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Column(
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary800), textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text(widget.subtitle, style: TextStyle(fontSize: 14, color: AppColors.primary800.withOpacity(0.6)), textAlign: TextAlign.center),
              ],
            ),
          ),
          SizedBox(
            height: 280,
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) _onScroll(event.scrollDelta.dy);
              },
              child: ListWheelScrollView.useDelegate(
                controller: _scrollController,
                itemExtent: 56,
                perspective: 0.003,
                diameterRatio: 1.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  final value = widget.minValue.round() + index;
                  setState(() => _selectedValue = value);
                  widget.onChanged(value.toDouble());
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: itemCount,
                  builder: (context, index) {
                    final value = widget.minValue.round() + index;
                    return _VerticalWheelItem(value: value, unit: 'cm', isSelected: value == _selectedValue, isAr: widget.isAr);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// Vertical wheel item
class _VerticalWheelItem extends StatelessWidget {
  final int value;
  final String unit;
  final bool isSelected;
  final bool isAr;

  const _VerticalWheelItem({required this.value, required this.unit, required this.isSelected, required this.isAr});

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(color: const Color(0xFFB8E986), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: isAr ? 0 : 16, right: isAr ? 16 : 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary800, borderRadius: BorderRadius.circular(12)),
                child: Text(unit, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFB8E986))),
              ),
            ),
            Expanded(child: Center(child: Text('$value', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary800)))),
            Padding(
              padding: EdgeInsets.only(left: isAr ? 16 : 0, right: isAr ? 0 : 16),
              child: Icon(Icons.play_arrow, color: AppColors.primary800, size: 28),
            ),
          ],
        ),
      );
    }
    return Center(child: Text('$value', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.primary800.withOpacity(0.4))));
  }
}

// Weight ruler painter
class _WeightRulerPainter extends CustomPainter {
  final int minValue;
  final int maxValue;
  final double itemWidth;

  _WeightRulerPainter({required this.minValue, required this.maxValue, required this.itemWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill..color = AppColors.primary800;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int v = minValue; v <= maxValue; v++) {
      final x = (v - minValue) * itemWidth;
      final isMajor = v % 5 == 0;
      final tickHeight = isMajor ? 30.0 : 18.0;
      final tickWidth = isMajor ? 2.0 : 1.5;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - tickWidth / 2, 0, tickWidth, tickHeight),
          const Radius.circular(1),
        ),
        paint,
      );

      if (isMajor) {
        textPainter.text = TextSpan(
          text: '$v',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary800),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height - 20));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Triangle painter
class _TrianglePainter extends CustomPainter {
  final Color color;
  final bool pointUp;
  _TrianglePainter({required this.color, this.pointUp = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();
    
    if (pointUp) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Backward compatibility
typedef BirthdateWheelPicker = AgeWheelPicker;

/// Blood Type Picker - matching design system
class BloodTypePicker extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? selectedType;
  final ValueChanged<String?> onChanged;
  final bool isAr;

  const BloodTypePicker({
    super.key,
    required this.title,
    required this.subtitle,
    this.selectedType,
    required this.onChanged,
    required this.isAr,
  });

  static const List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD4EDBC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Column(
              children: [
                Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary800), textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text(subtitle, style: TextStyle(fontSize: 14, color: AppColors.primary800.withOpacity(0.6)), textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: bloodTypes.length,
              itemBuilder: (context, index) {
                final type = bloodTypes[index];
                final isSelected = selectedType == type;
                return GestureDetector(
                  onTap: () => onChanged(isSelected ? null : type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFB8E986) : Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSelected ? AppColors.primary800 : Colors.transparent, width: 2),
                    ),
                    child: Center(
                      child: Text(type, style: TextStyle(fontSize: isSelected ? 20 : 18, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: AppColors.primary800)),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Medical Info Input
class MedicalInfoInput extends StatefulWidget {
  final String title;
  final String subtitle;
  final String hintAllergies;
  final String hintConditions;
  final List<String> allergies;
  final List<String> conditions;
  final ValueChanged<List<String>> onAllergiesChanged;
  final ValueChanged<List<String>> onConditionsChanged;
  final bool isAr;

  const MedicalInfoInput({
    super.key,
    required this.title,
    required this.subtitle,
    required this.hintAllergies,
    required this.hintConditions,
    required this.allergies,
    required this.conditions,
    required this.onAllergiesChanged,
    required this.onConditionsChanged,
    required this.isAr,
  });

  @override
  State<MedicalInfoInput> createState() => _MedicalInfoInputState();
}

class _MedicalInfoInputState extends State<MedicalInfoInput> {
  final _allergyController = TextEditingController();
  final _conditionController = TextEditingController();

  @override
  void dispose() {
    _allergyController.dispose();
    _conditionController.dispose();
    super.dispose();
  }

  void _addAllergy() {
    final text = _allergyController.text.trim();
    if (text.isNotEmpty && !widget.allergies.contains(text)) {
      widget.onAllergiesChanged([...widget.allergies, text]);
      _allergyController.clear();
    }
  }

  void _addCondition() {
    final text = _conditionController.text.trim();
    if (text.isNotEmpty && !widget.conditions.contains(text)) {
      widget.onConditionsChanged([...widget.conditions, text]);
      _conditionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFD4EDBC), borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(widget.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary800))),
            const SizedBox(height: 6),
            Center(child: Text(widget.subtitle, style: TextStyle(fontSize: 14, color: AppColors.primary800.withOpacity(0.6)))),
            const SizedBox(height: 20),
            Text(widget.isAr ? 'الحساسية' : 'Allergies', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary800)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: TextField(
                controller: _allergyController,
                decoration: InputDecoration(hintText: widget.hintAllergies, hintStyle: TextStyle(color: AppColors.primary800.withOpacity(0.4)), filled: true, fillColor: Colors.white.withOpacity(0.6), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                onSubmitted: (_) => _addAllergy(),
              )),
              const SizedBox(width: 8),
              IconButton(onPressed: _addAllergy, icon: const Icon(Icons.add_circle, color: AppColors.primary800, size: 32)),
            ]),
            if (widget.allergies.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: widget.allergies.map((a) => Chip(label: Text(a, style: const TextStyle(color: AppColors.primary800)), backgroundColor: const Color(0xFFB8E986), deleteIcon: const Icon(Icons.close, size: 18), onDeleted: () => widget.onAllergiesChanged(widget.allergies.where((e) => e != a).toList()))).toList()),
            ],
            const SizedBox(height: 20),
            Text(widget.isAr ? 'الحالات المرضية' : 'Medical Conditions', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary800)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: TextField(
                controller: _conditionController,
                decoration: InputDecoration(hintText: widget.hintConditions, hintStyle: TextStyle(color: AppColors.primary800.withOpacity(0.4)), filled: true, fillColor: Colors.white.withOpacity(0.6), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                onSubmitted: (_) => _addCondition(),
              )),
              const SizedBox(width: 8),
              IconButton(onPressed: _addCondition, icon: const Icon(Icons.add_circle, color: AppColors.primary800, size: 32)),
            ]),
            if (widget.conditions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: widget.conditions.map((c) => Chip(label: Text(c, style: const TextStyle(color: AppColors.primary800)), backgroundColor: const Color(0xFFB8E986), deleteIcon: const Icon(Icons.close, size: 18), onDeleted: () => widget.onConditionsChanged(widget.conditions.where((e) => e != c).toList()))).toList()),
            ],
          ],
        ),
      ),
    );
  }
}
