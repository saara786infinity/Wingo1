import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class PatternHeatmapWidget extends StatelessWidget {
  final List<Map<String, dynamic>> heatmapData;
  final String title;
  final VoidCallback? onTap;

  const PatternHeatmapWidget({
    super.key,
    required this.heatmapData,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return GestureDetector(
      onTap: onTap,
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
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'grid_view',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  CustomIconWidget(
                    iconName: 'touch_app',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    size: 16,
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              _buildHeatmapGrid(theme, isLight),
              SizedBox(height: 2.h),
              _buildLegend(theme, isLight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeatmapGrid(ThemeData theme, bool isLight) {
    return Container(
      height: 25.h,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1,
        ),
        itemCount: 100,
        itemBuilder: (context, index) {
          final intensity = heatmapData.isNotEmpty && index < heatmapData.length
              ? (heatmapData[index]['intensity'] as double? ?? 0.0)
              : (index % 10) / 10.0; // Mock data for demonstration

          return Container(
            decoration: BoxDecoration(
              color: _getHeatmapColor(intensity, isLight),
              borderRadius: BorderRadius.circular(2),
            ),
            child: intensity > 0.7
                ? Center(
                    child: Text(
                      '${(index % 10)}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildLegend(ThemeData theme, bool isLight) {
    return Row(
      children: [
        Text(
          'कम',
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Row(
            children: List.generate(5, (index) {
              final intensity = (index + 1) / 5.0;
              return Expanded(
                child: Container(
                  height: 1.h,
                  margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                  decoration: BoxDecoration(
                    color: _getHeatmapColor(intensity, isLight),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          'अधिक',
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Color _getHeatmapColor(double intensity, bool isLight) {
    final baseColor = isLight ? AppTheme.primaryLight : AppTheme.primaryDark;

    if (intensity == 0.0) {
      return isLight ? Colors.grey.shade100 : Colors.grey.shade800;
    }

    return Color.lerp(
      baseColor.withValues(alpha: 0.1),
      baseColor,
      intensity,
    )!;
  }
}
