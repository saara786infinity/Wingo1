import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PredictionCardWidget extends StatelessWidget {
  final Map<String, dynamic> prediction;
  final VoidCallback? onTap;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;
  final VoidCallback? onViewDetails;
  final bool isSelected;
  final bool isMultiSelectMode;
  final ValueChanged<bool>? onSelectionChanged;

  const PredictionCardWidget({
    super.key,
    required this.prediction,
    this.onTap,
    this.onShare,
    this.onDelete,
    this.onViewDetails,
    this.isSelected = false,
    this.isMultiSelectMode = false,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    final isWin = (prediction["result"] as String).toLowerCase() == "win";
    final statusColor =
        isWin ? AppTheme.getSuccessColor(isLight) : theme.colorScheme.error;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Dismissible(
        key: Key(prediction["id"].toString()),
        direction: DismissDirection.endToStart,
        background: _buildSwipeBackground(context, theme, isLight),
        confirmDismiss: (direction) async {
          HapticFeedback.lightImpact();
          _showActionBottomSheet(context);
          return false;
        },
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            if (isMultiSelectMode) {
              onSelectionChanged?.call(!isSelected);
            } else {
              onTap?.call();
            }
          },
          onLongPress: () {
            HapticFeedback.mediumImpact();
            onSelectionChanged?.call(!isSelected);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(color: theme.colorScheme.primary, width: 2)
                  : null,
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
                  _buildCardHeader(context, theme, isLight, statusColor),
                  SizedBox(height: 2.h),
                  _buildPredictionDetails(context, theme, isLight),
                  SizedBox(height: 2.h),
                  _buildResultSection(context, theme, isLight, statusColor),
                  SizedBox(height: 1.h),
                  _buildConfidenceScore(context, theme, isLight),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(
      BuildContext context, ThemeData theme, bool isLight) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'more_horiz',
                  color: theme.colorScheme.error,
                  size: 24,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'विकल्प',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(
      BuildContext context, ThemeData theme, bool isLight, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName:
                          (prediction["result"] as String).toLowerCase() ==
                                  "win"
                              ? 'trending_up'
                              : 'trending_down',
                      color: statusColor,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      prediction["result"] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              if (isMultiSelectMode)
                Container(
                  padding: EdgeInsets.all(0.5.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: isSelected
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: theme.colorScheme.onPrimary,
                          size: 16,
                        )
                      : SizedBox(width: 16, height: 16),
                ),
            ],
          ),
        ),
        Text(
          prediction["timestamp"] as String,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppTheme.getTextSecondary(isLight),
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionDetails(
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
          Text(
            'भविष्यवाणी विवरण',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  context,
                  theme,
                  'रंग',
                  prediction["predictedColor"] as String,
                  _getColorForPrediction(
                      prediction["predictedColor"] as String),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildDetailItem(
                  context,
                  theme,
                  'संख्या',
                  prediction["predictedNumber"].toString(),
                  theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  context,
                  theme,
                  'प्रकार',
                  prediction["type"] as String,
                  AppTheme.getTextSecondary(isLight),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildDetailItem(
                  context,
                  theme,
                  'राशि',
                  prediction["amount"] as String,
                  AppTheme.getWarningColor(isLight),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, ThemeData theme, String label,
      String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color:
                AppTheme.getTextSecondary(theme.brightness == Brightness.light),
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildResultSection(
      BuildContext context, ThemeData theme, bool isLight, Color statusColor) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'वास्तविक परिणाम',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  prediction["winAmount"] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  context,
                  theme,
                  'वास्तविक रंग',
                  prediction["actualColor"] as String,
                  _getColorForPrediction(prediction["actualColor"] as String),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildDetailItem(
                  context,
                  theme,
                  'वास्तविक संख्या',
                  prediction["actualNumber"].toString(),
                  theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceScore(
      BuildContext context, ThemeData theme, bool isLight) {
    final confidence = prediction["confidence"] as double;
    final confidenceColor = confidence >= 0.8
        ? AppTheme.getSuccessColor(isLight)
        : confidence >= 0.6
            ? AppTheme.getWarningColor(isLight)
            : theme.colorScheme.error;

    return Row(
      children: [
        CustomIconWidget(
          iconName: 'psychology',
          color: confidenceColor,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Text(
          'AI विश्वास स्कोर: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppTheme.getTextSecondary(isLight),
          ),
        ),
        Text(
          '${(confidence * 100).toInt()}%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: confidenceColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: LinearProgressIndicator(
            value: confidence,
            backgroundColor: theme.dividerColor.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(confidenceColor),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Color _getColorForPrediction(String color) {
    switch (color.toLowerCase()) {
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

  void _showActionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'visibility',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                title: const Text('विवरण देखें'),
                onTap: () {
                  Navigator.pop(context);
                  onViewDetails?.call();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'share',
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
                title: const Text('साझा करें'),
                onTap: () {
                  Navigator.pop(context);
                  onShare?.call();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: Theme.of(context).colorScheme.error,
                  size: 24,
                ),
                title: const Text('हटाएं'),
                onTap: () {
                  Navigator.pop(context);
                  onDelete?.call();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
