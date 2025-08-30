import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ResultAnalysisBottomSheet extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultAnalysisBottomSheet({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                  _buildResultSummary(theme, isLight),
                  SizedBox(height: 3.h),
                  _buildNumberFrequencyChart(theme, isLight),
                  SizedBox(height: 3.h),
                  _buildColorDistributionChart(theme, isLight),
                  SizedBox(height: 3.h),
                  _buildAIPredictionAccuracy(theme, isLight),
                  SizedBox(height: 3.h),
                  _buildPatternAnalysis(theme, isLight),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'परिणाम विश्लेषण',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'ड्रॉ ID: ${result['drawId'] ?? ''}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              size: 24,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSummary(ThemeData theme, bool isLight) {
    final String winningColor = (result['winningColor'] as String?) ?? '';
    final int winningNumber = (result['winningNumber'] as int?) ?? 0;
    final bool isBig = winningColor.toLowerCase() == 'big';

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'इस ड्रॉ का परिणाम',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  theme,
                  'विजेता रंग',
                  isBig ? 'बड़ा' : 'छोटा',
                  isBig
                      ? (isLight
                          ? const Color(0xFF059669)
                          : const Color(0xFF34D399))
                      : (isLight
                          ? const Color(0xFFDC2626)
                          : const Color(0xFFF87171)),
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  theme,
                  'विजेता नंबर',
                  winningNumber.toString(),
                  theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      ThemeData theme, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 1),
          ),
          child: Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildNumberFrequencyChart(ThemeData theme, bool isLight) {
    // Mock data for number frequency
    final List<Map<String, dynamic>> frequencyData = [
      {'number': 0, 'frequency': 12},
      {'number': 1, 'frequency': 8},
      {'number': 2, 'frequency': 15},
      {'number': 3, 'frequency': 6},
      {'number': 4, 'frequency': 10},
      {'number': 5, 'frequency': 14},
      {'number': 6, 'frequency': 9},
      {'number': 7, 'frequency': 11},
      {'number': 8, 'frequency': 7},
      {'number': 9, 'frequency': 13},
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'नंबर आवृत्ति विश्लेषण',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'पिछले 100 ड्रॉ में प्रत्येक नंबर की आवृत्ति',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 30.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 20,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: theme.textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: theme.textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: frequencyData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: (data['frequency'] as int).toDouble(),
                        color: theme.colorScheme.primary,
                        width: 6.w,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorDistributionChart(ThemeData theme, bool isLight) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'रंग वितरण रुझान',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'पिछले 50 ड्रॉ में बड़ा/छोटा का वितरण',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 25.h,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 8.w,
                      sections: [
                        PieChartSectionData(
                          color: isLight
                              ? const Color(0xFF059669)
                              : const Color(0xFF34D399),
                          value: 52,
                          title: '52%',
                          radius: 12.w,
                          titleStyle: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        PieChartSectionData(
                          color: isLight
                              ? const Color(0xFFDC2626)
                              : const Color(0xFFF87171),
                          value: 48,
                          title: '48%',
                          radius: 12.w,
                          titleStyle: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegendItem(
                    theme,
                    'बड़ा',
                    '26 बार',
                    isLight ? const Color(0xFF059669) : const Color(0xFF34D399),
                  ),
                  SizedBox(height: 2.h),
                  _buildLegendItem(
                    theme,
                    'छोटा',
                    '24 बार',
                    isLight ? const Color(0xFFDC2626) : const Color(0xFFF87171),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
      ThemeData theme, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 2.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAIPredictionAccuracy(ThemeData theme, bool isLight) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'psychology',
                size: 24,
                color: theme.colorScheme.secondary,
              ),
              SizedBox(width: 2.w),
              Text(
                'AI भविष्यवाणी सटीकता',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildAccuracyMetric(
                  theme,
                  'आज की सटीकता',
                  '78.5%',
                  isLight ? const Color(0xFF059669) : const Color(0xFF34D399),
                ),
              ),
              Expanded(
                child: _buildAccuracyMetric(
                  theme,
                  'साप्ताहिक सटीकता',
                  '72.3%',
                  theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'इस ड्रॉ के लिए AI की भविष्यवाणी:',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'रंग: छोटा (विश्वसनीयता: 65%)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  'नंबर रेंज: 0-4 (विश्वसनीयता: 58%)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyMetric(
      ThemeData theme, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPatternAnalysis(ThemeData theme, bool isLight) {
    final List<Map<String, dynamic>> patterns = [
      {
        'pattern': 'लगातार 3 बार छोटा',
        'probability': '12%',
        'lastOccurrence': '2 दिन पहले',
        'trend': 'increasing',
      },
      {
        'pattern': 'सम संख्या की लकीर',
        'probability': '8%',
        'lastOccurrence': '5 घंटे पहले',
        'trend': 'stable',
      },
      {
        'pattern': 'बड़ा-छोटा-बड़ा पैटर्न',
        'probability': '15%',
        'lastOccurrence': '1 दिन पहले',
        'trend': 'decreasing',
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'pattern',
                size: 24,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Text(
                'पैटर्न विश्लेषण',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ...patterns
              .map((pattern) => _buildPatternItem(theme, isLight, pattern)),
        ],
      ),
    );
  }

  Widget _buildPatternItem(
      ThemeData theme, bool isLight, Map<String, dynamic> pattern) {
    final String trend = pattern['trend'] as String;
    Color trendColor;
    IconData trendIcon;

    switch (trend) {
      case 'increasing':
        trendColor =
            isLight ? const Color(0xFF059669) : const Color(0xFF34D399);
        trendIcon = Icons.trending_up;
        break;
      case 'decreasing':
        trendColor =
            isLight ? const Color(0xFFDC2626) : const Color(0xFFF87171);
        trendIcon = Icons.trending_down;
        break;
      default:
        trendColor =
            isLight ? const Color(0xFFF59E0B) : const Color(0xFFFBBF24);
        trendIcon = Icons.trending_flat;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.2),
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
                  pattern['pattern'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'संभावना: ${pattern['probability']} | ${pattern['lastOccurrence']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            trendIcon,
            color: trendColor,
            size: 20,
          ),
        ],
      ),
    );
  }
}
