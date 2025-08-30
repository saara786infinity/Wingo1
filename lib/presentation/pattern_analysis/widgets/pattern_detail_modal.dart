import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class PatternDetailModal extends StatelessWidget {
  final Map<String, dynamic> pattern;
  final VoidCallback? onClose;

  const PatternDetailModal({
    super.key,
    required this.pattern,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildHeader(context, theme),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPatternOverview(theme, isLight),
                  SizedBox(height: 3.h),
                  _buildImplementationSuggestions(theme, isLight),
                  SizedBox(height: 3.h),
                  _buildHistoricalValidation(theme, isLight),
                  SizedBox(height: 3.h),
                  _buildSuccessProbability(theme, isLight),
                  SizedBox(height: 4.h),
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
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'पैटर्न विवरण',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onClose ?? () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                shape: BoxShape.circle,
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
    );
  }

  Widget _buildPatternOverview(ThemeData theme, bool isLight) {
    final confidence = (pattern['confidence'] as double? ?? 0.0);
    final patternType = pattern['type'] as String? ?? '';
    final description = pattern['description'] as String? ?? '';
    final detailedDescription = pattern['detailedDescription'] as String? ??
        'यह पैटर्न ऐतिहासिक डेटा के आधार पर AI द्वारा पहचाना गया है। इसमें संख्याओं और रंगों के बीच एक मजबूत संबंध दिखाई देता है।';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'पैटर्न अवलोकन',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color:
                _getConfidenceColor(confidence, isLight).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getConfidenceColor(confidence, isLight)
                  .withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: _getConfidenceColor(confidence, isLight),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      patternType,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'विश्वसनीयता: ${(confidence * 100).toInt()}%',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: _getConfidenceColor(confidence, isLight),
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
              ),
              SizedBox(height: 1.h),
              Text(
                detailedDescription,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImplementationSuggestions(ThemeData theme, bool isLight) {
    final suggestions = (pattern['suggestions'] as List<dynamic>?) ??
        [
          'सुबह 9-11 बजे के बीच इस पैटर्न का उपयोग करें',
          'छोटी राशि से शुरुआत करें और धीरे-धीरे बढ़ाएं',
          'पिछले 3 परिणामों का विश्लेषण करने के बाद ही भविष्यवाणी करें',
          'लगातार 2 हार के बाद एक राउंड रुकें',
        ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'कार्यान्वयन सुझाव',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        ...(suggestions).asMap().entries.map((entry) {
          final index = entry.key;
          final suggestion = entry.value as String;

          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    suggestion,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildHistoricalValidation(ThemeData theme, bool isLight) {
    final validationData = (pattern['validation'] as Map<String, dynamic>?) ??
        {
          'totalTests': 150,
          'successfulPredictions': 112,
          'averageAccuracy': 0.747,
          'lastUpdated': '2025-08-28',
        };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ऐतिहासिक सत्यापन',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildValidationItem(
                'कुल परीक्षण',
                '${validationData['totalTests']}',
                CustomIconWidget(
                  iconName: 'quiz',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                theme,
              ),
              SizedBox(height: 2.h),
              _buildValidationItem(
                'सफल भविष्यवाणियां',
                '${validationData['successfulPredictions']}',
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.getSuccessColor(isLight),
                  size: 20,
                ),
                theme,
              ),
              SizedBox(height: 2.h),
              _buildValidationItem(
                'औसत सटीकता',
                '${((validationData['averageAccuracy'] as double) * 100).toInt()}%',
                CustomIconWidget(
                  iconName: 'target',
                  color: AppTheme.getWarningColor(isLight),
                  size: 20,
                ),
                theme,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildValidationItem(
      String label, String value, Widget icon, ThemeData theme) {
    return Row(
      children: [
        icon,
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessProbability(ThemeData theme, bool isLight) {
    final probability = (pattern['successProbability'] as double? ?? 0.74);
    final riskLevel = probability >= 0.8
        ? 'कम'
        : probability >= 0.6
            ? 'मध्यम'
            : 'उच्च';
    final riskColor = probability >= 0.8
        ? AppTheme.getSuccessColor(isLight)
        : probability >= 0.6
            ? AppTheme.getWarningColor(isLight)
            : theme.colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'सफलता संभावना',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                riskColor.withValues(alpha: 0.1),
                riskColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: riskColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '${(probability * 100).toInt()}%',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: riskColor,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: riskColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$riskLevel जोखिम',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              LinearProgressIndicator(
                value: probability,
                backgroundColor: riskColor.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                minHeight: 1.h,
              ),
              SizedBox(height: 1.h),
              Text(
                'यह संभावना पिछले 30 दिनों के डेटा पर आधारित है',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
