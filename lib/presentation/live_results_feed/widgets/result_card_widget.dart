import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ResultCardWidget extends StatelessWidget {
  final Map<String, dynamic> result;
  final VoidCallback? onTap;
  final VoidCallback? onViewPattern;
  final VoidCallback? onShare;
  final VoidCallback? onAddToFavorites;

  const ResultCardWidget({
    super.key,
    required this.result,
    this.onTap,
    this.onViewPattern,
    this.onShare,
    this.onAddToFavorites,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    final String drawId = (result['drawId'] as String?) ?? '';
    final DateTime timestamp =
        result['timestamp'] as DateTime? ?? DateTime.now();
    final String winningColor = (result['winningColor'] as String?) ?? '';
    final int winningNumber = (result['winningNumber'] as int?) ?? 0;
    final String userPrediction = (result['userPrediction'] as String?) ?? '';
    final bool isWin = (result['isWin'] as bool?) ?? false;
    final bool hasPrediction = userPrediction.isNotEmpty;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        _showQuickActions(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: _getCardBackgroundColor(theme, isLight, isWin, hasPrediction),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getBorderColor(theme, isLight, isWin, hasPrediction),
            width: 1.5,
          ),
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
              _buildHeader(theme, isLight, drawId, timestamp),
              SizedBox(height: 2.h),
              _buildResultContent(theme, isLight, winningColor, winningNumber),
              if (hasPrediction) ...[
                SizedBox(height: 2.h),
                _buildPredictionComparison(
                    theme, isLight, userPrediction, isWin),
              ],
              SizedBox(height: 1.h),
              _buildResultStatus(theme, isLight, isWin, hasPrediction),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      ThemeData theme, bool isLight, String drawId, DateTime timestamp) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ड्रॉ ID: $drawId',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                _formatTimestamp(timestamp),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'circle',
                size: 8,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 1.w),
              Text(
                'लाइव',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultContent(
      ThemeData theme, bool isLight, String winningColor, int winningNumber) {
    final bool isBig = winningColor.toLowerCase() == 'big';
    final Color colorIndicator = isBig
        ? (isLight ? const Color(0xFF059669) : const Color(0xFF34D399))
        : (isLight ? const Color(0xFFDC2626) : const Color(0xFFF87171));

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'विजेता रंग',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: colorIndicator,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      isBig ? 'बड़ा' : 'छोटा',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorIndicator,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 8.h,
            color: theme.dividerColor.withValues(alpha: 0.3),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'विजेता नंबर',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      winningNumber.toString(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionComparison(
      ThemeData theme, bool isLight, String userPrediction, bool isWin) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isWin
            ? (isLight ? const Color(0xFF059669) : const Color(0xFF34D399))
                .withValues(alpha: 0.1)
            : (isLight ? const Color(0xFFDC2626) : const Color(0xFFF87171))
                .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWin
              ? (isLight ? const Color(0xFF059669) : const Color(0xFF34D399))
              : (isLight ? const Color(0xFFDC2626) : const Color(0xFFF87171)),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isWin ? 'check_circle' : 'cancel',
            size: 20,
            color: isWin
                ? (isLight ? const Color(0xFF059669) : const Color(0xFF34D399))
                : (isLight ? const Color(0xFFDC2626) : const Color(0xFFF87171)),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'आपकी भविष्यवाणी: $userPrediction',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  isWin ? 'बधाई हो! आप जीत गए' : 'बेहतर किस्मत अगली बार',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isWin
                        ? (isLight
                            ? const Color(0xFF059669)
                            : const Color(0xFF34D399))
                        : (isLight
                            ? const Color(0xFFDC2626)
                            : const Color(0xFFF87171)),
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

  Widget _buildResultStatus(
      ThemeData theme, bool isLight, bool isWin, bool hasPrediction) {
    if (!hasPrediction) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'info_outline',
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            SizedBox(width: 1.w),
            Text(
              'कोई भविष्यवाणी नहीं',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: isWin
                  ? (isLight
                          ? const Color(0xFF059669)
                          : const Color(0xFF34D399))
                      .withValues(alpha: 0.2)
                  : (isLight
                          ? const Color(0xFFDC2626)
                          : const Color(0xFFF87171))
                      .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isWin ? '✓ जीत' : '✗ हार',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isWin
                    ? (isLight
                        ? const Color(0xFF059669)
                        : const Color(0xFF34D399))
                    : (isLight
                        ? const Color(0xFFDC2626)
                        : const Color(0xFFF87171)),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(width: 2.w),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            _showQuickActions(null);
          },
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'more_horiz',
              size: 16,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Color _getCardBackgroundColor(
      ThemeData theme, bool isLight, bool isWin, bool hasPrediction) {
    if (!hasPrediction) {
      return theme.colorScheme.surface;
    }

    if (isWin) {
      return (isLight ? const Color(0xFF059669) : const Color(0xFF34D399))
          .withValues(alpha: 0.05);
    } else {
      return (isLight ? const Color(0xFFDC2626) : const Color(0xFFF87171))
          .withValues(alpha: 0.05);
    }
  }

  Color _getBorderColor(
      ThemeData theme, bool isLight, bool isWin, bool hasPrediction) {
    if (!hasPrediction) {
      return theme.dividerColor.withValues(alpha: 0.3);
    }

    if (isWin) {
      return (isLight ? const Color(0xFF059669) : const Color(0xFF34D399))
          .withValues(alpha: 0.3);
    } else {
      return (isLight ? const Color(0xFFDC2626) : const Color(0xFFF87171))
          .withValues(alpha: 0.3);
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'अभी';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} मिनट पहले';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} घंटे पहले';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _showQuickActions(BuildContext? context) {
    if (context == null) return;

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
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              _buildQuickActionTile(
                context,
                'पैटर्न देखें',
                'trending_up',
                onViewPattern,
              ),
              _buildQuickActionTile(
                context,
                'परिणाम साझा करें',
                'share',
                onShare,
              ),
              _buildQuickActionTile(
                context,
                'पसंदीदा में जोड़ें',
                'favorite_border',
                onAddToFavorites,
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
    BuildContext context,
    String title,
    String iconName,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        size: 24,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      onTap: () {
        Navigator.pop(context);
        HapticFeedback.lightImpact();
        onTap?.call();
      },
    );
  }
}