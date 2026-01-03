import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../core/theme/app_theme.dart';

class WeightHeightPicker extends StatelessWidget {
  final double? initialValue;
  final String unit;
  final String label;
  final double minValue;
  final double maxValue;
  final ValueChanged<double> onChanged;
  final bool isAr;

  const WeightHeightPicker({
    super.key,
    this.initialValue,
    required this.unit,
    required this.label,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.isAr,
  });

  @override
  Widget build(BuildContext context) {
    if (unit == 'kg') {
      return _HorizontalRulerPicker(
        initialValue: initialValue ?? 70,
        minValue: minValue,
        maxValue: maxValue,
        unit: unit,
        onChanged: onChanged,
      );
    } else {
      return _VerticalRulerPicker(
        initialValue: initialValue ?? 170,
        minValue: minValue,
        maxValue: maxValue,
        unit: unit,
        onChanged: onChanged,
      );
    }
  }
}

// ==================== HORIZONTAL (WEIGHT) ====================
class _HorizontalRulerPicker extends StatefulWidget {
  final double initialValue;
  final double minValue;
  final double maxValue;
  final String unit;
  final ValueChanged<double> onChanged;

  const _HorizontalRulerPicker({
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    required this.onChanged,
  });

  @override
  State<_HorizontalRulerPicker> createState() => _HorizontalRulerPickerState();
}

class _HorizontalRulerPickerState extends State<_HorizontalRulerPicker> {
  late double _value;
  final double _tickSpacing = 12.0;
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _dragOffset = (_value - widget.minValue) * _tickSpacing;
  }

  void _updateValue(double delta) {
    _dragOffset = (_dragOffset - delta).clamp(
      0,
      (widget.maxValue - widget.minValue) * _tickSpacing,
    );
    final newValue = ((_dragOffset / _tickSpacing) + widget.minValue)
        .clamp(widget.minValue, widget.maxValue)
        .roundToDouble();
    if (newValue != _value) {
      setState(() => _value = newValue);
      widget.onChanged(newValue);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFB8E986),
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final centerX = constraints.maxWidth / 2;
          
          return Column(
            children: [
              const SizedBox(height: 12),
              // Unit badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary700,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.unit.toUpperCase(),
                      style: const TextStyle(color: Color(0xFFB8E986), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: Color(0xFFB8E986), size: 16),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Value display
              Text(
                '${_value.toInt()} ${widget.unit}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary700,
                ),
              ),
              const SizedBox(height: 8),
              // Ruler
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (details) => _updateValue(details.delta.dx),
                  onPanUpdate: (details) => _updateValue(details.delta.dx),
                  child: Listener(
                    onPointerSignal: (event) {
                      if (event is PointerScrollEvent) {
                        _updateValue(event.scrollDelta.dy > 0 ? 20 : -20);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Ruler ticks
                          CustomPaint(
                            size: Size(constraints.maxWidth, 60),
                            painter: _HorizontalRulerPainter(
                              minValue: widget.minValue,
                              maxValue: widget.maxValue,
                              offset: _dragOffset,
                              centerX: centerX,
                              tickSpacing: _tickSpacing,
                            ),
                          ),
                          // Center indicator
                          Positioned(
                            bottom: 10,
                            child: Column(
                              children: [
                                Container(
                                  width: 3,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary700,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                CustomPaint(
                                  size: const Size(16, 10),
                                  painter: _TrianglePainter(color: AppColors.primary700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HorizontalRulerPainter extends CustomPainter {
  final double minValue;
  final double maxValue;
  final double offset;
  final double centerX;
  final double tickSpacing;

  _HorizontalRulerPainter({
    required this.minValue,
    required this.maxValue,
    required this.offset,
    required this.centerX,
    required this.tickSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (double v = minValue; v <= maxValue; v++) {
      final x = centerX + ((v - minValue) * tickSpacing) - offset;
      if (x < -20 || x > size.width + 20) continue;

      final isMajor = v % 5 == 0;
      paint.color = AppColors.primary700.withValues(alpha: isMajor ? 0.8 : 0.4);

      final tickHeight = isMajor ? 35.0 : 20.0;
      final tickWidth = isMajor ? 2.0 : 1.0;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - tickWidth / 2, size.height - tickHeight - 15, tickWidth, tickHeight),
          const Radius.circular(1),
        ),
        paint,
      );

      if (isMajor) {
        textPainter.text = TextSpan(
          text: '${v.toInt()}',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.primary700.withValues(alpha: 0.7),
          ),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height - 12));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HorizontalRulerPainter oldDelegate) =>
      oldDelegate.offset != offset;
}

// ==================== VERTICAL (HEIGHT) ====================
class _VerticalRulerPicker extends StatefulWidget {
  final double initialValue;
  final double minValue;
  final double maxValue;
  final String unit;
  final ValueChanged<double> onChanged;

  const _VerticalRulerPicker({
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    required this.onChanged,
  });

  @override
  State<_VerticalRulerPicker> createState() => _VerticalRulerPickerState();
}

class _VerticalRulerPickerState extends State<_VerticalRulerPicker> {
  late double _value;
  final double _tickSpacing = 8.0;
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _dragOffset = (_value - widget.minValue) * _tickSpacing;
  }

  void _updateValue(double delta) {
    _dragOffset = (_dragOffset - delta).clamp(
      0,
      (widget.maxValue - widget.minValue) * _tickSpacing,
    );
    final newValue = ((_dragOffset / _tickSpacing) + widget.minValue)
        .clamp(widget.minValue, widget.maxValue)
        .roundToDouble();
    if (newValue != _value) {
      setState(() => _value = newValue);
      widget.onChanged(newValue);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: const Color(0xFFB8E986),
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final centerY = constraints.maxHeight / 2;
          
          return Row(
            children: [
              // Left side - Value display
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary700,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.unit.toUpperCase(),
                            style: const TextStyle(color: Color(0xFFB8E986), fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          const Icon(Icons.keyboard_arrow_down, color: Color(0xFFB8E986), size: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_value.toInt()}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary700,
                      ),
                    ),
                    Text(
                      widget.unit,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.primary700.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              // Right side - Ruler
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragUpdate: (details) => _updateValue(details.delta.dy),
                onPanUpdate: (details) => _updateValue(details.delta.dy),
                child: Listener(
                  onPointerSignal: (event) {
                    if (event is PointerScrollEvent) {
                      _updateValue(event.scrollDelta.dy > 0 ? 15 : -15);
                    }
                  },
                  child: SizedBox(
                    width: 100,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        // Ruler ticks
                        CustomPaint(
                          size: Size(80, constraints.maxHeight),
                          painter: _VerticalRulerPainter(
                            minValue: widget.minValue,
                            maxValue: widget.maxValue,
                            offset: _dragOffset,
                            centerY: centerY,
                            tickSpacing: _tickSpacing,
                          ),
                        ),
                        // Center indicator
                        Positioned(
                          right: 8,
                          child: Row(
                            children: [
                              CustomPaint(
                                size: const Size(10, 16),
                                painter: _TrianglePainter(
                                  color: AppColors.primary700,
                                  direction: _TriangleDirection.right,
                                ),
                              ),
                              Container(
                                width: 35,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: AppColors.primary700,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _VerticalRulerPainter extends CustomPainter {
  final double minValue;
  final double maxValue;
  final double offset;
  final double centerY;
  final double tickSpacing;

  _VerticalRulerPainter({
    required this.minValue,
    required this.maxValue,
    required this.offset,
    required this.centerY,
    required this.tickSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (double v = minValue; v <= maxValue; v++) {
      final y = centerY + ((v - minValue) * tickSpacing) - offset;
      if (y < -10 || y > size.height + 10) continue;

      final isMajor = v % 10 == 0;
      paint.color = AppColors.primary700.withValues(alpha: isMajor ? 0.8 : 0.4);

      final tickWidth = isMajor ? 30.0 : 15.0;
      final tickHeight = isMajor ? 2.0 : 1.0;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width - tickWidth - 8, y - tickHeight / 2, tickWidth, tickHeight),
          const Radius.circular(1),
        ),
        paint,
      );

      if (isMajor) {
        textPainter.text = TextSpan(
          text: '${v.toInt()}',
          style: TextStyle(
            fontSize: 9,
            color: AppColors.primary700.withValues(alpha: 0.7),
          ),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(size.width - tickWidth - 12 - textPainter.width, y - textPainter.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _VerticalRulerPainter oldDelegate) =>
      oldDelegate.offset != offset;
}

enum _TriangleDirection { down, right }

class _TrianglePainter extends CustomPainter {
  final Color color;
  final _TriangleDirection direction;

  _TrianglePainter({required this.color, this.direction = _TriangleDirection.down});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();
    
    if (direction == _TriangleDirection.down) {
      path.moveTo(size.width / 2, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(0, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
