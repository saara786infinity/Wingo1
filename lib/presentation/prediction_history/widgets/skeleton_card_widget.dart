import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SkeletonCardWidget extends StatefulWidget {
  const SkeletonCardWidget({super.key});

  @override
  State<SkeletonCardWidget> createState() => _SkeletonCardWidgetState();
}

class _SkeletonCardWidgetState extends State<SkeletonCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
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
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSkeletonHeader(context, theme, isLight),
                  SizedBox(height: 2.h),
                  _buildSkeletonDetails(context, theme, isLight),
                  SizedBox(height: 2.h),
                  _buildSkeletonResult(context, theme, isLight),
                  SizedBox(height: 1.h),
                  _buildSkeletonConfidence(context, theme, isLight),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonHeader(
      BuildContext context, ThemeData theme, bool isLight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSkeletonBox(
          width: 20.w,
          height: 4.h,
          borderRadius: 8,
          theme: theme,
          isLight: isLight,
        ),
        _buildSkeletonBox(
          width: 25.w,
          height: 3.h,
          borderRadius: 6,
          theme: theme,
          isLight: isLight,
        ),
      ],
    );
  }

  Widget _buildSkeletonDetails(
      BuildContext context, ThemeData theme, bool isLight) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkeletonBox(
            width: 30.w,
            height: 2.5.h,
            borderRadius: 4,
            theme: theme,
            isLight: isLight,
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkeletonBox(
                      width: 15.w,
                      height: 2.h,
                      borderRadius: 4,
                      theme: theme,
                      isLight: isLight,
                    ),
                    SizedBox(height: 0.5.h),
                    _buildSkeletonBox(
                      width: 20.w,
                      height: 2.5.h,
                      borderRadius: 4,
                      theme: theme,
                      isLight: isLight,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkeletonBox(
                      width: 15.w,
                      height: 2.h,
                      borderRadius: 4,
                      theme: theme,
                      isLight: isLight,
                    ),
                    SizedBox(height: 0.5.h),
                    _buildSkeletonBox(
                      width: 18.w,
                      height: 2.5.h,
                      borderRadius: 4,
                      theme: theme,
                      isLight: isLight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonResult(
      BuildContext context, ThemeData theme, bool isLight) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSkeletonBox(
                width: 25.w,
                height: 2.5.h,
                borderRadius: 4,
                theme: theme,
                isLight: isLight,
              ),
              _buildSkeletonBox(
                width: 15.w,
                height: 3.h,
                borderRadius: 6,
                theme: theme,
                isLight: isLight,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkeletonBox(
                      width: 20.w,
                      height: 2.h,
                      borderRadius: 4,
                      theme: theme,
                      isLight: isLight,
                    ),
                    SizedBox(height: 0.5.h),
                    _buildSkeletonBox(
                      width: 18.w,
                      height: 2.5.h,
                      borderRadius: 4,
                      theme: theme,
                      isLight: isLight,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkeletonBox(
                      width: 22.w,
                      height: 2.h,
                      borderRadius: 4,
                      theme: theme,
                      isLight: isLight,
                    ),
                    SizedBox(height: 0.5.h),
                    _buildSkeletonBox(
                      width: 16.w,
                      height: 2.5.h,
                      borderRadius: 4,
                      theme: theme,
                      isLight: isLight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonConfidence(
      BuildContext context, ThemeData theme, bool isLight) {
    return Row(
      children: [
        _buildSkeletonBox(
          width: 4.w,
          height: 4.w,
          borderRadius: 2,
          theme: theme,
          isLight: isLight,
        ),
        SizedBox(width: 2.w),
        _buildSkeletonBox(
          width: 25.w,
          height: 2.h,
          borderRadius: 4,
          theme: theme,
          isLight: isLight,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildSkeletonBox(
            width: double.infinity,
            height: 1.h,
            borderRadius: 2,
            theme: theme,
            isLight: isLight,
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonBox({
    required double width,
    required double height,
    required double borderRadius,
    required ThemeData theme,
    required bool isLight,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: (isLight ? Colors.grey[300] : Colors.grey[700])
            ?.withValues(alpha: _animation.value),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
