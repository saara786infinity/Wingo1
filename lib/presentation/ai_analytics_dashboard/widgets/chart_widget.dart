import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum ChartType { line, bar, pie }

class ChartWidget extends StatefulWidget {
  final ChartType chartType;
  final String title;
  final List<Map<String, dynamic>> data;
  final VoidCallback? onTap;
  final bool showLegend;
  final double? height;

  const ChartWidget({
    super.key,
    required this.chartType,
    required this.title,
    required this.data,
    this.onTap,
    this.showLegend = true,
    this.height,
  });

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: widget.height ?? 32.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.getTextPrimary(isLight),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'zoom_in',
                  color: AppTheme.getTextSecondary(isLight),
                  size: 20,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: _buildChart(theme, isLight),
            ),
            if (widget.showLegend) ...[
              SizedBox(height: 2.h),
              _buildLegend(theme, isLight),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChart(ThemeData theme, bool isLight) {
    switch (widget.chartType) {
      case ChartType.line:
        return _buildLineChart(theme, isLight);
      case ChartType.bar:
        return _buildBarChart(theme, isLight);
      case ChartType.pie:
        return _buildPieChart(theme, isLight);
    }
  }

  Widget _buildLineChart(ThemeData theme, bool isLight) {
    final spots = widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return FlSpot(
        index.toDouble(),
        (item['value'] as num).toDouble(),
      );
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: theme.dividerColor.withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < widget.data.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      widget.data[index]['label'] as String? ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.getTextSecondary(isLight),
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  '${value.toInt()}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.getTextSecondary(isLight),
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (widget.data.length - 1).toDouble(),
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.3),
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: theme.colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: theme.cardColor,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.1),
                  theme.colorScheme.primary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(ThemeData theme, bool isLight) {
    final barGroups = widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (item['value'] as num).toDouble(),
            color: item['color'] as Color? ?? theme.colorScheme.primary,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: theme.colorScheme.surface,
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.round()}%',
                theme.textTheme.bodySmall!.copyWith(
                  color: AppTheme.getTextPrimary(isLight),
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < widget.data.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      widget.data[index]['label'] as String? ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.getTextSecondary(isLight),
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 25,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  '${value.toInt()}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.getTextSecondary(isLight),
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: theme.dividerColor.withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPieChart(ThemeData theme, bool isLight) {
    final sections = widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 16.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: item['color'] as Color? ?? theme.colorScheme.primary,
        value: (item['value'] as num).toDouble(),
        title: '${(item['value'] as num).toInt()}%',
        radius: radius,
        titleStyle: theme.textTheme.bodySmall?.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: sections,
      ),
    );
  }

  Widget _buildLegend(ThemeData theme, bool isLight) {
    return Wrap(
      spacing: 4.w,
      runSpacing: 1.h,
      children: widget.data.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item['color'] as Color? ?? theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              item['label'] as String? ?? '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.getTextSecondary(isLight),
                fontSize: 11,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}