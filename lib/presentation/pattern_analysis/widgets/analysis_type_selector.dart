import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AnalysisTypeSelector extends StatefulWidget {
  final List<String> analysisTypes;
  final int selectedIndex;
  final ValueChanged<int>? onSelectionChanged;
  final bool enableHapticFeedback;

  const AnalysisTypeSelector({
    super.key,
    required this.analysisTypes,
    this.selectedIndex = 0,
    this.onSelectionChanged,
    this.enableHapticFeedback = true,
  });

  @override
  State<AnalysisTypeSelector> createState() => _AnalysisTypeSelectorState();
}

class _AnalysisTypeSelectorState extends State<AnalysisTypeSelector>
    with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: widget.analysisTypes.asMap().entries.map((entry) {
          final index = entry.key;
          final type = entry.value;
          final isSelected = index == widget.selectedIndex;

          return Expanded(
            child: _buildAnalysisTypeTab(
              context,
              theme,
              type,
              isSelected,
              () => _handleSelection(index),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnalysisTypeTab(
    BuildContext context,
    ThemeData theme,
    String type,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? _scaleAnimation.value : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? selectedColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: selectedColor, width: 2.0)
                    : null,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: _getIconForType(type),
                      color: isSelected ? selectedColor : unselectedColor,
                      size: 18,
                    ),
                    SizedBox(width: 1.w),
                    Flexible(
                      child: Text(
                        type,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? selectedColor : unselectedColor,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'संख्या पैटर्न':
      case 'number patterns':
        return 'format_list_numbered';
      case 'रंग ट्रेंड':
      case 'color trends':
        return 'palette';
      case 'समय आधारित':
      case 'time-based analysis':
        return 'schedule';
      default:
        return 'analytics';
    }
  }

  void _handleSelection(int index) {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged!(index);
    }

    // Trigger animation for visual feedback
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }
}
