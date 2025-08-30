import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/ai_prediction_card_widget.dart';
import './widgets/color_prediction_widget.dart';
import './widgets/game_timer_widget.dart';
import './widgets/live_results_widget.dart';
import './widgets/number_prediction_widget.dart';
import './widgets/prediction_history_widget.dart';

class PredictionDashboard extends StatefulWidget {
  const PredictionDashboard({super.key});

  @override
  State<PredictionDashboard> createState() => _PredictionDashboardState();
}

class _PredictionDashboardState extends State<PredictionDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  String? _selectedColor;
  int? _selectedNumber;
  bool _isConnected = true;
  bool _isLoading = false;

  // Mock AI predictions
  final List<Map<String, dynamic>> _aiPredictions = [
    {
      "type": "रंग पूर्वानुमान",
      "prediction": "बड़ा",
      "confidence": 78.5,
      "color": Colors.green,
    },
    {
      "type": "संख्या पूर्वानुमान",
      "prediction": "7",
      "confidence": 65.2,
      "color": Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));

    _checkConnectivity();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _checkConnectivity() {
    // Simulate connectivity check
    setState(() {
      _isConnected = true;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('डेटा अपडेट हो गया'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _onColorSelected(String color) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedColor = color;
    });
  }

  void _onNumberSelected(int number) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedNumber = number;
    });
  }

  void _onTimerComplete() {
    HapticFeedback.heavyImpact();
    _showPredictionSubmittedDialog();
  }

  void _showPredictionSubmittedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Theme.of(context).colorScheme.tertiary,
              size: 24,
            ),
            SizedBox(width: 3.w),
            const Text('पूर्वानुमान जमा'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('आपका पूर्वानुमान सफलतापूर्वक जमा हो गया है।'),
            SizedBox(height: 2.h),
            if (_selectedColor != null) Text('रंग: $_selectedColor'),
            if (_selectedNumber != null) Text('संख्या: $_selectedNumber'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _selectedColor = null;
                _selectedNumber = null;
              });
            },
            child: const Text('ठीक है'),
          ),
        ],
      ),
    );
  }

  void _showPredictionHistoryModal() {
    _fabAnimationController.forward().then((_) {
      _fabAnimationController.reverse();
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'विस्तृत इतिहास',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: PredictionHistoryWidget(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'ColorPredict Pro',
        variant: CustomAppBarVariant.gaming,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshData,
          color: theme.colorScheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // Connection Status Banner
                  if (!_isConnected)
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      margin: EdgeInsets.only(bottom: 2.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.error.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'wifi_off',
                            color: theme.colorScheme.error,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'इंटरनेट कनेक्शन नहीं है। कैश्ड डेटा दिखाया जा रहा है।',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Game Timer
                  GameTimerWidget(
                    onTimerComplete: _onTimerComplete,
                  ),

                  SizedBox(height: 3.h),

                  // AI Predictions Section
                  Text(
                    'AI पूर्वानुमान',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  Row(
                    children: [
                      Expanded(
                        child: AiPredictionCardWidget(
                          predictionType: _aiPredictions[0]["type"] as String,
                          prediction: _aiPredictions[0]["prediction"] as String,
                          confidence: _aiPredictions[0]["confidence"] as double,
                          cardColor: _aiPredictions[0]["color"] as Color,
                          onTap: () => Navigator.pushNamed(
                              context, '/ai-analytics-dashboard'),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: AiPredictionCardWidget(
                          predictionType: _aiPredictions[1]["type"] as String,
                          prediction: _aiPredictions[1]["prediction"] as String,
                          confidence: _aiPredictions[1]["confidence"] as double,
                          cardColor: _aiPredictions[1]["color"] as Color,
                          onTap: () => Navigator.pushNamed(
                              context, '/ai-analytics-dashboard'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Prediction Zones
                  Text(
                    'अपना पूर्वानुमान लगाएं',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Color Prediction
                  ColorPredictionWidget(
                    onColorSelected: _onColorSelected,
                  ),

                  SizedBox(height: 3.h),

                  // Number Prediction
                  NumberPredictionWidget(
                    onNumberSelected: _onNumberSelected,
                  ),

                  SizedBox(height: 4.h),

                  // Recent Predictions History
                  const PredictionHistoryWidget(),

                  SizedBox(height: 4.h),

                  // Live Results Feed
                  const LiveResultsWidget(),

                  SizedBox(height: 10.h), // Extra space for FAB
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabScaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabScaleAnimation.value,
            child: FloatingActionButton.extended(
              onPressed: _showPredictionHistoryModal,
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
              icon: CustomIconWidget(
                iconName: 'analytics',
                color: theme.colorScheme.onSecondary,
                size: 20,
              ),
              label: Text(
                'विश्लेषण',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: const CustomBottomBar(
        variant: CustomBottomBarVariant.gaming,
        currentIndex: 0,
      ),
    );
  }
}
