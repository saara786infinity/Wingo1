import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LiveResultsWidget extends StatefulWidget {
  const LiveResultsWidget({super.key});

  @override
  State<LiveResultsWidget> createState() => _LiveResultsWidgetState();
}

class _LiveResultsWidgetState extends State<LiveResultsWidget>
    with TickerProviderStateMixin {
  Timer? _updateTimer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _liveResults = [
    {
      "id": "20250828001",
      "time": "09:30:00",
      "result": "बड़ा",
      "number": 8,
      "color": Colors.green,
      "isNew": true,
    },
    {
      "id": "20250828002",
      "time": "09:29:00",
      "result": "छोटा",
      "number": 3,
      "color": Colors.red,
      "isNew": false,
    },
    {
      "id": "20250828003",
      "time": "09:28:00",
      "result": "छोटा",
      "number": 2,
      "color": Colors.red,
      "isNew": false,
    },
    {
      "id": "20250828004",
      "time": "09:27:00",
      "result": "बड़ा",
      "number": 9,
      "color": Colors.green,
      "isNew": false,
    },
    {
      "id": "20250828005",
      "time": "09:26:00",
      "result": "छोटा",
      "number": 1,
      "color": Colors.red,
      "isNew": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _startLiveUpdates();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startLiveUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _simulateNewResult();
    });
  }

  void _simulateNewResult() {
    final now = DateTime.now();
    final newResult = {
      "id":
          "2025${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}",
      "time":
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
      "result": now.second % 2 == 0 ? "बड़ा" : "छोटा",
      "number": now.second % 10,
      "color": now.second % 2 == 0 ? Colors.green : Colors.red,
      "isNew": true,
    };

    setState(() {
      // Mark all existing results as not new
      for (var result in _liveResults) {
        result["isNew"] = false;
      }
      // Add new result at the beginning
      _liveResults.insert(0, newResult);
      // Keep only last 10 results
      if (_liveResults.length > 10) {
        _liveResults.removeRange(10, _liveResults.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          padding: EdgeInsets.all(1.5.w),
                          decoration: BoxDecoration(
                            color:
                                theme.colorScheme.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'live_tv',
                            color: theme.colorScheme.error,
                            size: 18,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'लाइव परिणाम',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        'हर 30 सेकंड में अपडेट',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/live-results-feed'),
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
                        'पूरा फीड',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'open_in_new',
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
            height: 25.h,
            child: ListView.separated(
              itemCount: _liveResults.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final result = _liveResults[index];
                return _buildResultItem(context, theme, result, index == 0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(
    BuildContext context,
    ThemeData theme,
    Map<String, dynamic> result,
    bool isLatest,
  ) {
    final isNew = result["isNew"] as bool;
    final resultColor = result["color"] as Color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: isNew
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.secondary.withValues(alpha: 0.1),
                  theme.colorScheme.secondary.withValues(alpha: 0.05),
                ],
              )
            : null,
        color: isNew ? null : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNew
              ? theme.colorScheme.secondary.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: isNew ? 2 : 1,
        ),
        boxShadow: isNew
            ? [
                BoxShadow(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: resultColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: (result["result"] as String) == "बड़ा"
                  ? 'trending_up'
                  : 'trending_down',
              color: resultColor,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      result["id"] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                    if (isNew)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'नया',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSecondary,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      result["result"] as String,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: resultColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        (result["number"] as int).toString(),
                        style: AppTheme.dataTextStyle(
                          isLight: theme.brightness == Brightness.light,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ).copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                result["time"] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 10.sp,
                ),
              ),
              if (isLatest) ...[
                SizedBox(height: 0.5.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'ताज़ा',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.tertiary,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}