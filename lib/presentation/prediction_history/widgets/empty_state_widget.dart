import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onStartPredicting;

  const EmptyStateWidget({
    super.key,
    this.onStartPredicting,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(context, theme, isLight),
            SizedBox(height: 4.h),
            _buildTitle(context, theme),
            SizedBox(height: 2.h),
            _buildDescription(context, theme, isLight),
            SizedBox(height: 4.h),
            _buildStartButton(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(
      BuildContext context, ThemeData theme, bool isLight) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomIconWidget(
            iconName: 'history',
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            size: 60,
          ),
          Positioned(
            bottom: 8.w,
            right: 8.w,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    return Text(
      'कोई भविष्यवाणी इतिहास नहीं',
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(
      BuildContext context, ThemeData theme, bool isLight) {
    return Text(
      'आपकी भविष्यवाणियों का इतिहास यहाँ दिखाई देगा। अपनी पहली भविष्यवाणी करने के लिए शुरू करें।',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: AppTheme.getTextSecondary(isLight),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStartButton(BuildContext context, ThemeData theme) {
    return ElevatedButton.icon(
      onPressed: onStartPredicting,
      icon: CustomIconWidget(
        iconName: 'play_arrow',
        color: theme.colorScheme.onPrimary,
        size: 20,
      ),
      label: Text(
        'शुरू करें',
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        shadowColor: theme.colorScheme.primary.withValues(alpha: 0.3),
      ),
    );
  }
}
