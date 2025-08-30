import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activeFilters;
  final ValueChanged<Map<String, dynamic>>? onFilterRemoved;
  final VoidCallback? onClearAll;

  const FilterChipsWidget({
    super.key,
    required this.activeFilters,
    this.onFilterRemoved,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: activeFilters.length,
              separatorBuilder: (context, index) => SizedBox(width: 2.w),
              itemBuilder: (context, index) {
                final filter = activeFilters[index];
                return _buildFilterChip(context, theme, isLight, filter);
              },
            ),
          ),
          if (activeFilters.length > 1) ...[
            SizedBox(width: 2.w),
            _buildClearAllButton(context, theme, isLight),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, ThemeData theme, bool isLight,
      Map<String, dynamic> filter) {
    final filterType = filter["type"] as String;
    final filterValue = filter["value"] as String;
    final count = filter["count"] as int? ?? 0;

    Color chipColor;
    IconData chipIcon;

    switch (filterType) {
      case 'date':
        chipColor = theme.colorScheme.primary;
        chipIcon = Icons.date_range;
        break;
      case 'result':
        chipColor = filterValue.toLowerCase() == 'win'
            ? AppTheme.getSuccessColor(isLight)
            : theme.colorScheme.error;
        chipIcon = filterValue.toLowerCase() == 'win'
            ? Icons.trending_up
            : Icons.trending_down;
        break;
      case 'type':
        chipColor = AppTheme.getWarningColor(isLight);
        chipIcon = Icons.category;
        break;
      case 'color':
        chipColor = _getColorForFilter(filterValue);
        chipIcon = Icons.palette;
        break;
      default:
        chipColor = theme.colorScheme.secondary;
        chipIcon = Icons.filter_alt;
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onFilterRemoved?.call(filter);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: chipColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: chipColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: _getIconName(chipIcon),
              color: chipColor,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              _getFilterDisplayText(filterType, filterValue),
              style: theme.textTheme.bodySmall?.copyWith(
                color: chipColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (count > 0) ...[
              SizedBox(width: 1.w),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.2.h),
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: 'close',
              color: chipColor,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearAllButton(
      BuildContext context, ThemeData theme, bool isLight) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onClearAll?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'clear_all',
              color: theme.colorScheme.error,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              'सभी साफ़ करें',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFilterDisplayText(String filterType, String filterValue) {
    switch (filterType) {
      case 'date':
        return filterValue;
      case 'result':
        return filterValue.toLowerCase() == 'win' ? 'जीत' : 'हार';
      case 'type':
        switch (filterValue.toLowerCase()) {
          case 'color':
            return 'रंग';
          case 'number':
            return 'संख्या';
          case 'big':
            return 'बड़ा';
          case 'small':
            return 'छोटा';
          default:
            return filterValue;
        }
      case 'color':
        switch (filterValue.toLowerCase()) {
          case 'red':
            return 'लाल';
          case 'green':
            return 'हरा';
          case 'violet':
            return 'बैंगनी';
          default:
            return filterValue;
        }
      default:
        return filterValue;
    }
  }

  Color _getColorForFilter(String colorValue) {
    switch (colorValue.toLowerCase()) {
      case 'red':
      case 'लाल':
        return Colors.red;
      case 'green':
      case 'हरा':
        return Colors.green;
      case 'violet':
      case 'बैंगनी':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getIconName(IconData icon) {
    if (icon == Icons.date_range) return 'date_range';
    if (icon == Icons.trending_up) return 'trending_up';
    if (icon == Icons.trending_down) return 'trending_down';
    if (icon == Icons.category) return 'category';
    if (icon == Icons.palette) return 'palette';
    if (icon == Icons.filter_alt) return 'filter_alt';
    if (icon == Icons.close) return 'close';
    if (icon == Icons.clear_all) return 'clear_all';
    return 'filter_alt';
  }
}
