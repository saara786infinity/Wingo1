import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PredictionDetailModal extends StatelessWidget {
  final Map<String, dynamic> prediction;

  const PredictionDetailModal({
    super.key,
    required this.prediction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildHeader(context, theme),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewSection(context, theme, isLight),
                  SizedBox(height: 3.h),
                  _buildPredictionAnalysis(context, theme, isLight),
                  SizedBox(height: 3.h),
                  _buildMarketConditions(context, theme, isLight),
                  SizedBox(height: 3.h),
                  _buildPatternMatches(context, theme, isLight),
                  SizedBox(height: 3.h),
                  _buildLearningInsights(context, theme, isLight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'भविष्यवाणी विवरण',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurface,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection(
      BuildContext context, ThemeData theme, bool isLight) {
    final isWin = (prediction["result"] as String).toLowerCase() == "win";
    final statusColor =
        isWin ? AppTheme.getSuccessColor(isLight) : theme.colorScheme.error;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: isWin ? 'trending_up' : 'trending_down',
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediction["result"] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        prediction["timestamp"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.getTextSecondary(isLight),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  prediction["winAmount"] as String,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  context,
                  theme,
                  'भविष्यवाणी',
                  '${prediction["predictedColor"]} - ${prediction["predictedNumber"]}',
                  theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildOverviewItem(
                  context,
                  theme,
                  'वास्तविक',
                  '${prediction["actualColor"]} - ${prediction["actualNumber"]}',
                  statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(BuildContext context, ThemeData theme, String label,
      String value, Color color) {
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
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionAnalysis(
      BuildContext context, ThemeData theme, bool isLight) {
    return _buildSection(
      context,
      theme,
      'AI विश्लेषण',
      Icons.psychology,
      theme.colorScheme.primary,
      [
        _buildAnalysisItem(
          context,
          theme,
          isLight,
          'विश्वास स्कोर',
          '${((prediction["confidence"] as double) * 100).toInt()}%',
          _getConfidenceColor(prediction["confidence"] as double, isLight),
        ),
        _buildAnalysisItem(
          context,
          theme,
          isLight,
          'पैटर्न मैच',
          prediction["patternMatch"] as String,
          AppTheme.getWarningColor(isLight),
        ),
        _buildAnalysisItem(
          context,
          theme,
          isLight,
          'जोखिम स्तर',
          prediction["riskLevel"] as String,
          _getRiskColor(prediction["riskLevel"] as String, isLight),
        ),
      ],
    );
  }

  Widget _buildMarketConditions(
      BuildContext context, ThemeData theme, bool isLight) {
    final conditions = prediction["marketConditions"] as Map<String, dynamic>;

    return _buildSection(
      context,
      theme,
      'बाज़ार की स्थिति',
      Icons.trending_up,
      AppTheme.getSuccessColor(isLight),
      [
        _buildAnalysisItem(
          context,
          theme,
          isLight,
          'वॉल्यूम',
          conditions["volume"] as String,
          theme.colorScheme.primary,
        ),
        _buildAnalysisItem(
          context,
          theme,
          isLight,
          'ट्रेंड',
          conditions["trend"] as String,
          _getTrendColor(conditions["trend"] as String, isLight),
        ),
        _buildAnalysisItem(
          context,
          theme,
          isLight,
          'अस्थिरता',
          conditions["volatility"] as String,
          AppTheme.getWarningColor(isLight),
        ),
      ],
    );
  }

  Widget _buildPatternMatches(
      BuildContext context, ThemeData theme, bool isLight) {
    final patterns =
        (prediction["patterns"] as List).cast<Map<String, dynamic>>();

    return _buildSection(
      context,
      theme,
      'पैटर्न मैच',
      Icons.pattern,
      theme.colorScheme.secondary,
      patterns
          .map((pattern) => Container(
                margin: EdgeInsets.only(bottom: 1.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(1.5.w),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'timeline',
                        color: theme.colorScheme.secondary,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pattern["name"] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'मैच: ${pattern["match"]}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.getTextSecondary(isLight),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      pattern["strength"] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _getStrengthColor(
                            pattern["strength"] as String, isLight),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildLearningInsights(
      BuildContext context, ThemeData theme, bool isLight) {
    final insights = (prediction["learningInsights"] as List).cast<String>();

    return _buildSection(
      context,
      theme,
      'सीखने की अंतर्दृष्टि',
      Icons.lightbulb,
      AppTheme.getWarningColor(isLight),
      insights
          .map((insight) => Container(
                margin: EdgeInsets.only(bottom: 1.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.getWarningColor(isLight).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.getWarningColor(isLight)
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 0.5.h),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppTheme.getWarningColor(isLight),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        insight,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.getTextPrimary(isLight),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSection(
    BuildContext context,
    ThemeData theme,
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: _getIconName(icon),
                  color: color,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildAnalysisItem(
    BuildContext context,
    ThemeData theme,
    bool isLight,
    String label,
    String value,
    Color valueColor,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.getTextSecondary(isLight),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence, bool isLight) {
    if (confidence >= 0.8) return AppTheme.getSuccessColor(isLight);
    if (confidence >= 0.6) return AppTheme.getWarningColor(isLight);
    return Colors.red;
  }

  Color _getRiskColor(String risk, bool isLight) {
    switch (risk.toLowerCase()) {
      case 'low':
      case 'कम':
        return AppTheme.getSuccessColor(isLight);
      case 'medium':
      case 'मध्यम':
        return AppTheme.getWarningColor(isLight);
      case 'high':
      case 'उच्च':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getTrendColor(String trend, bool isLight) {
    switch (trend.toLowerCase()) {
      case 'bullish':
      case 'तेजी':
        return AppTheme.getSuccessColor(isLight);
      case 'bearish':
      case 'मंदी':
        return Colors.red;
      case 'neutral':
      case 'तटस्थ':
        return AppTheme.getWarningColor(isLight);
      default:
        return Colors.grey;
    }
  }

  Color _getStrengthColor(String strength, bool isLight) {
    switch (strength.toLowerCase()) {
      case 'strong':
      case 'मजबूत':
        return AppTheme.getSuccessColor(isLight);
      case 'moderate':
      case 'मध्यम':
        return AppTheme.getWarningColor(isLight);
      case 'weak':
      case 'कमजोर':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getIconName(IconData icon) {
    if (icon == Icons.psychology) return 'psychology';
    if (icon == Icons.trending_up) return 'trending_up';
    if (icon == Icons.pattern) return 'pattern';
    if (icon == Icons.lightbulb) return 'lightbulb';
    if (icon == Icons.timeline) return 'timeline';
    return 'info';
  }
}
