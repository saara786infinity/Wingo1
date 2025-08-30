import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final bool hasActiveFilters;

  const SearchBarWidget({
    super.key,
    this.initialValue,
    this.onChanged,
    this.onFilterTap,
    this.hasActiveFilters = false,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
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
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isFocused
                      ? theme.colorScheme.primary
                      : theme.dividerColor.withValues(alpha: 0.3),
                  width: _isFocused ? 2 : 1,
                ),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: theme.shadowColor.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: TextField(
                controller: _controller,
                onChanged: widget.onChanged,
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _isFocused = true);
                },
                onTapOutside: (_) {
                  setState(() => _isFocused = false);
                  FocusScope.of(context).unfocus();
                },
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.getTextPrimary(isLight),
                ),
                decoration: InputDecoration(
                  hintText: 'भविष्यवाणी खोजें...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.getTextSecondary(isLight),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: _isFocused
                          ? theme.colorScheme.primary
                          : AppTheme.getTextSecondary(isLight),
                      size: 20,
                    ),
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            _controller.clear();
                            widget.onChanged?.call('');
                          },
                          child: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'close',
                              color: AppTheme.getTextSecondary(isLight),
                              size: 18,
                            ),
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          ScaleTransition(
            scale: _scaleAnimation,
            child: GestureDetector(
              onTapDown: (_) => _animationController.forward(),
              onTapUp: (_) => _animationController.reverse(),
              onTapCancel: () => _animationController.reverse(),
              onTap: () {
                HapticFeedback.mediumImpact();
                widget.onFilterTap?.call();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: widget.hasActiveFilters
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.hasActiveFilters
                        ? theme.colorScheme.primary
                        : theme.dividerColor.withValues(alpha: 0.3),
                    width: widget.hasActiveFilters ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.hasActiveFilters
                          ? theme.colorScheme.primary.withValues(alpha: 0.2)
                          : theme.shadowColor.withValues(alpha: 0.05),
                      blurRadius: widget.hasActiveFilters ? 8 : 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    CustomIconWidget(
                      iconName: 'tune',
                      color: widget.hasActiveFilters
                          ? theme.colorScheme.onPrimary
                          : AppTheme.getTextSecondary(isLight),
                      size: 20,
                    ),
                    if (widget.hasActiveFilters)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
