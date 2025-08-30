import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GameTimerWidget extends StatefulWidget {
  final VoidCallback? onTimerComplete;

  const GameTimerWidget({
    super.key,
    this.onTimerComplete,
  });

  @override
  State<GameTimerWidget> createState() => _GameTimerWidgetState();
}

class _GameTimerWidgetState extends State<GameTimerWidget>
    with TickerProviderStateMixin {
  Timer? _timer;
  int _remainingSeconds = 60;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  String _currentDrawId = "20250828001";

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _startTimer();
    _generateDrawId();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          if (_remainingSeconds <= 10) {
            _pulseController.repeat(reverse: true);
          }
        } else {
          _remainingSeconds = 60;
          _generateDrawId();
          _pulseController.stop();
          _pulseController.reset();
          widget.onTimerComplete?.call();
        }
      });
    });
  }

  void _generateDrawId() {
    final now = DateTime.now();
    final dateStr =
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}";
    setState(() {
      _currentDrawId = "$dateStr$timeStr";
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'अगला ड्रॉ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _currentDrawId,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: theme.colorScheme.onPrimary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'लाइव',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _remainingSeconds <= 10 ? _pulseAnimation.value : 1.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: _remainingSeconds <= 10
                        ? theme.colorScheme.error.withValues(alpha: 0.2)
                        : theme.colorScheme.onPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _remainingSeconds <= 10
                          ? theme.colorScheme.error.withValues(alpha: 0.5)
                          : theme.colorScheme.onPrimary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'समय शेष',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary
                              .withValues(alpha: 0.8),
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: AppTheme.dataTextStyle(
                          isLight: !isDark,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                        ).copyWith(
                          color: _remainingSeconds <= 10
                              ? theme.colorScheme.error
                              : theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}