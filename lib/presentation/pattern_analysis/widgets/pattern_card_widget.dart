import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class PatternCardWidget extends StatelessWidget {
  final Map<String, dynamic> pattern;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PatternCardWidget({
    super.key,
    required this.pattern,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    final confidence = (pattern['confidence'] as double? ?? 0.0);
    final patternType = pattern['type'] as String? ?? '';
    final description = pattern['description'] as String? ?? '';
    final frequency = pattern['frequency'] as int? ?? 0;
    final successRate = (pattern['successRate'] as double? ?? 0.0);
    final trend = pattern['trend'] as String? ?? 'stable';

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
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
          border: Border.all(
            color:
                _getConfidenceColor(confidence, isLight).withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: _getConfidenceColor(confidence, isLight)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      patternType,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: _getConfidenceColor(confidence, isLight),
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildTrendIndicator(trend, theme),
                  SizedBox(width: 2.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getConfidenceColor(confidence, isLight)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${(confidence * 100).toInt()}%',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: _getConfidenceColor(confidence, isLight),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'आवृत्ति',
                      frequency.toString(),
                      CustomIconWidget(
                        iconName: 'bar_chart',
                        color: theme.colorScheme.primary,
                        size: 16,
                      ),
                      theme,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _buildStatItem(
                      'सफलता दर',
                      '${(successRate * 100).toInt()}%',
                      CustomIconWidget(
                        iconName: 'trending_up',
                        color: AppTheme.getSuccessColor(isLight),
                        size: 16,
                      ),
                      theme,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendIndicator(String trend, ThemeData theme) {
    IconData iconData;
    Color color;

    switch (trend.toLowerCase()) {
      case 'increasing':
        iconData = Icons.trending_up;
        color = AppTheme.getSuccessColor(theme.brightness == Brightness.light);
        break;
      case 'decreasing':
        iconData = Icons.trending_down;
        color = theme.colorScheme.error;
        break;
      default:
        iconData = Icons.trending_flat;
        color = AppTheme.getWarningColor(theme.brightness == Brightness.light);
    }

    return CustomIconWidget(
      iconName: iconData.codePoint.toString(),
      color: color,
      size: 18,
    );
  }

  Widget _buildStatItem(
      String label, String value, Widget icon, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            icon,
            SizedBox(width: 1.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Color _getConfidenceColor(double confidence, bool isLight) {
    if (confidence >= 0.8) {
      return AppTheme.getSuccessColor(isLight);
    } else if (confidence >= 0.6) {
      return AppTheme.getWarningColor(isLight);
    } else {
      return isLight ? AppTheme.errorLight : AppTheme.errorDark;
    }
  }
}
