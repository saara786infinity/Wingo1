import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ColorPredictionWidget extends StatefulWidget {
  final Function(String)? onColorSelected;

  const ColorPredictionWidget({
    super.key,
    this.onColorSelected,
  });

  @override
  State<ColorPredictionWidget> createState() => _ColorPredictionWidgetState();
}

class _ColorPredictionWidgetState extends State<ColorPredictionWidget>
    with TickerProviderStateMixin {
  String? _selectedColor;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectColor(String color) {
    HapticFeedback.lightImpact();
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    setState(() {
      _selectedColor = color;
    });

    widget.onColorSelected?.call(color);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'palette',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'रंग चुनें',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildColorButton(
                  context,
                  'बड़ा',
                  'BIG',
                  theme.colorScheme.tertiary,
                  CustomIconWidget(
                    iconName: 'trending_up',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildColorButton(
                  context,
                  'छोटा',
                  'SMALL',
                  theme.colorScheme.error,
                  CustomIconWidget(
                    iconName: 'trending_down',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          if (_selectedColor != null) ...[
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: _selectedColor == 'BIG'
                    ? theme.colorScheme.tertiary.withValues(alpha: 0.1)
                    : theme.colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedColor == 'BIG'
                      ? theme.colorScheme.tertiary.withValues(alpha: 0.3)
                      : theme.colorScheme.error.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: _selectedColor == 'BIG'
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.error,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'आपका चयन: ${_selectedColor == 'BIG' ? 'बड़ा' : 'छोटा'}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: _selectedColor == 'BIG'
                          ? theme.colorScheme.tertiary
                          : theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildColorButton(
    BuildContext context,
    String label,
    String value,
    Color color,
    Widget icon,
  ) {
    final theme = Theme.of(context);
    final isSelected = _selectedColor == value;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected ? _scaleAnimation.value : 1.0,
          child: GestureDetector(
            onTap: () => _selectColor(value),
            child: Container(
              height: 15.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? Border.all(
                        color: theme.colorScheme.onSurface,
                        width: 3,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: isSelected ? 12 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  SizedBox(height: 1.h),
                  Text(
                    label,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                    ),
                  ),
                  if (isSelected) ...[
                    SizedBox(height: 0.5.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'चयनित',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
