import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PatternHeatMapWidget extends StatelessWidget {
  final List<Map<String, dynamic>> heatMapData;
  final String title;

  const PatternHeatMapWidget({
    super.key,
    required this.heatMapData,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'grid_view',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "लाइव",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildHeatMapGrid(context),
          SizedBox(height: 2.h),
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildHeatMapGrid(BuildContext context) {
    final theme = Theme.of(context);

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
        itemCount: heatMapData.length,
        itemBuilder: (context, index) {
          final data = heatMapData[index];
          final intensity = (data["intensity"] as double).clamp(0.0, 1.0);

          return Container(
            decoration: BoxDecoration(
              color: _getHeatMapColor(intensity),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
                width: 0.5,
              ),
            ),
            child: Center(
              child: Text(
                data["value"].toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: intensity > 0.5
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: 8.sp,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          "कम",
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Row(
            children: List.generate(5, (index) {
              final intensity = (index + 1) / 5;
              return Expanded(
                child: Container(
                  height: 1.h,
                  margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                  decoration: BoxDecoration(
                    color: _getHeatMapColor(intensity),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          "अधिक",
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Color _getHeatMapColor(double intensity) {
    if (intensity <= 0.2) {
      return const Color(0xFFE5E7EB);
    } else if (intensity <= 0.4) {
      return const Color(0xFFFEF3C7);
    } else if (intensity <= 0.6) {
      return const Color(0xFFFBBF24);
    } else if (intensity <= 0.8) {
      return const Color(0xFFF59E0B);
    } else {
      return const Color(0xFFD97706);
    }
  }
}
