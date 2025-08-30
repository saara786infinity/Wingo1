import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PredictionHistoryWidget extends StatelessWidget {
  const PredictionHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> recentPredictions = [
      {
        "id": "20250828001",
        "time": "09:30",
        "colorPrediction": "बड़ा",
        "numberPrediction": 7,
        "actualColor": "बड़ा",
        "actualNumber": 8,
        "colorResult": "win",
        "numberResult": "loss",
        "timestamp": DateTime.now().subtract(const Duration(minutes: 2)),
      },
      {
        "id": "20250828002",
        "time": "09:29",
        "colorPrediction": "छोटा",
        "numberPrediction": 3,
        "actualColor": "छोटा",
        "actualNumber": 3,
        "colorResult": "win",
        "numberResult": "win",
        "timestamp": DateTime.now().subtract(const Duration(minutes: 3)),
      },
      {
        "id": "20250828003",
        "time": "09:28",
        "colorPrediction": "बड़ा",
        "numberPrediction": 9,
        "actualColor": "छोटा",
        "actualNumber": 2,
        "colorResult": "loss",
        "numberResult": "loss",
        "timestamp": DateTime.now().subtract(const Duration(minutes: 4)),
      },
      {
        "id": "20250828004",
        "time": "09:27",
        "colorPrediction": "छोटा",
        "numberPrediction": 1,
        "actualColor": "छोटा",
        "actualNumber": 4,
        "colorResult": "win",
        "numberResult": "loss",
        "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'history',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'हाल के परिणाम',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, '/prediction-history'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'सभी देखें',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'arrow_forward_ios',
                        color: theme.colorScheme.primary,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 20.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recentPredictions.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final prediction = recentPredictions[index];
                return _buildPredictionCard(context, theme, prediction);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCard(
    BuildContext context,
    ThemeData theme,
    Map<String, dynamic> prediction,
  ) {
    final colorWin = (prediction["colorResult"] as String) == "win";
    final numberWin = (prediction["numberResult"] as String) == "win";
    final overallWin = colorWin && numberWin;

    return Container(
      width: 65.w,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: overallWin
              ? [
                  theme.colorScheme.tertiary.withValues(alpha: 0.1),
                  theme.colorScheme.tertiary.withValues(alpha: 0.05),
                ]
              : [
                  theme.colorScheme.error.withValues(alpha: 0.1),
                  theme.colorScheme.error.withValues(alpha: 0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: overallWin
              ? theme.colorScheme.tertiary.withValues(alpha: 0.3)
              : theme.colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: overallWin
                      ? theme.colorScheme.tertiary.withValues(alpha: 0.2)
                      : theme.colorScheme.error.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  prediction["id"] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: overallWin
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.error,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                prediction["time"] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'रंग',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Text(
                          prediction["colorPrediction"] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        CustomIconWidget(
                          iconName: colorWin ? 'check_circle' : 'cancel',
                          color: colorWin
                              ? theme.colorScheme.tertiary
                              : theme.colorScheme.error,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 4.h,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'संख्या',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Text(
                          (prediction["numberPrediction"] as int).toString(),
                          style: AppTheme.dataTextStyle(
                            isLight: theme.brightness == Brightness.light,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        CustomIconWidget(
                          iconName: numberWin ? 'check_circle' : 'cancel',
                          color: numberWin
                              ? theme.colorScheme.tertiary
                              : theme.colorScheme.error,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: overallWin
                  ? theme.colorScheme.tertiary.withValues(alpha: 0.1)
                  : theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName:
                      overallWin ? 'emoji_events' : 'sentiment_dissatisfied',
                  color: overallWin
                      ? theme.colorScheme.tertiary
                      : theme.colorScheme.error,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  overallWin ? 'जीत' : 'हार',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: overallWin
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}