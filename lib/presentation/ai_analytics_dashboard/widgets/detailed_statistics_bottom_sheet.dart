import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DetailedStatisticsBottomSheet extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> statistics;
  final VoidCallback? onExport;

  const DetailedStatisticsBottomSheet({
    super.key,
    required this.title,
    required this.statistics,
    this.onExport,
  });

  @override
  State<DetailedStatisticsBottomSheet> createState() =>
      _DetailedStatisticsBottomSheetState();
}

class _DetailedStatisticsBottomSheetState
    extends State<DetailedStatisticsBottomSheet> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: widget.onExport,
                      icon: CustomIconWidget(
                        iconName: 'file_download',
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: theme.colorScheme.onPrimary,
              unselectedLabelColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.7),
              indicator: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(11),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'समय पैटर्न'),
                Tab(text: 'संख्या विश्लेषण'),
                Tab(text: 'संभावना'),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTimePatternTab(theme),
                _buildNumberAnalysisTab(theme),
                _buildProbabilityTab(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePatternTab(ThemeData theme) {
    final timePatterns = [
      {
        'time': '09:00-12:00',
        'accuracy': '78%',
        'predictions': '45',
        'success': '35'
      },
      {
        'time': '12:00-15:00',
        'accuracy': '82%',
        'predictions': '52',
        'success': '43'
      },
      {
        'time': '15:00-18:00',
        'accuracy': '75%',
        'predictions': '38',
        'success': '28'
      },
      {
        'time': '18:00-21:00',
        'accuracy': '85%',
        'predictions': '67',
        'success': '57'
      },
      {
        'time': '21:00-24:00',
        'accuracy': '73%',
        'predictions': '29',
        'success': '21'
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: timePatterns.length,
      itemBuilder: (context, index) {
        final pattern = timePatterns[index];
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pattern['time'] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      pattern['accuracy'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      theme,
                      'कुल भविष्यवाणी',
                      pattern['predictions'] as String,
                      'trending_up',
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _buildStatItem(
                      theme,
                      'सफल भविष्यवाणी',
                      pattern['success'] as String,
                      'check_circle',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNumberAnalysisTab(ThemeData theme) {
    final numberAnalysis = [
      {
        'number': '0',
        'frequency': '12%',
        'lastSeen': '2 घंटे पहले',
        'trend': 'up'
      },
      {
        'number': '1',
        'frequency': '15%',
        'lastSeen': '45 मिनट पहले',
        'trend': 'up'
      },
      {
        'number': '2',
        'frequency': '8%',
        'lastSeen': '3 घंटे पहले',
        'trend': 'down'
      },
      {
        'number': '3',
        'frequency': '18%',
        'lastSeen': '1 घंटा पहले',
        'trend': 'up'
      },
      {
        'number': '4',
        'frequency': '11%',
        'lastSeen': '4 घंटे पहले',
        'trend': 'stable'
      },
      {
        'number': '5',
        'frequency': '14%',
        'lastSeen': '30 मिनट पहले',
        'trend': 'up'
      },
      {
        'number': '6',
        'frequency': '9%',
        'lastSeen': '2.5 घंटे पहले',
        'trend': 'down'
      },
      {
        'number': '7',
        'frequency': '13%',
        'lastSeen': '1.5 घंटे पहले',
        'trend': 'stable'
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: numberAnalysis.length,
      itemBuilder: (context, index) {
        final analysis = numberAnalysis[index];
        final trend = analysis['trend'] as String;
        Color trendColor = theme.colorScheme.outline;
        IconData trendIcon = Icons.trending_flat;

        if (trend == 'up') {
          trendColor = theme.colorScheme.tertiary;
          trendIcon = Icons.trending_up;
        } else if (trend == 'down') {
          trendColor = theme.colorScheme.error;
          trendIcon = Icons.trending_down;
        }

        return Container(
          margin: EdgeInsets.only(bottom: 1.5.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    analysis['number'] as String,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'आवृत्ति: ${analysis['frequency']}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Icon(
                          trendIcon,
                          color: trendColor,
                          size: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'अंतिम बार देखा: ${analysis['lastSeen']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProbabilityTab(ThemeData theme) {
    final probabilities = [
      {
        'category': 'बड़ा (5-9)',
        'probability': '52%',
        'confidence': 'उच्च',
        'nextHour': '48%'
      },
      {
        'category': 'छोटा (0-4)',
        'probability': '48%',
        'confidence': 'मध्यम',
        'nextHour': '52%'
      },
      {
        'category': 'जोड़ संख्या',
        'probability': '45%',
        'confidence': 'मध्यम',
        'nextHour': '47%'
      },
      {
        'category': 'विषम संख्या',
        'probability': '55%',
        'confidence': 'उच्च',
        'nextHour': '53%'
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: probabilities.length,
      itemBuilder: (context, index) {
        final prob = probabilities[index];
        final confidence = prob['confidence'] as String;
        Color confidenceColor = theme.colorScheme.secondary;

        if (confidence == 'उच्च') {
          confidenceColor = theme.colorScheme.tertiary;
        } else if (confidence == 'कम') {
          confidenceColor = theme.colorScheme.error;
        }

        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    prob['category'] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: confidenceColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      confidence,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: confidenceColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      theme,
                      'वर्तमान संभावना',
                      prob['probability'] as String,
                      'analytics',
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _buildStatItem(
                      theme,
                      'अगले घंटे',
                      prob['nextHour'] as String,
                      'schedule',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
      ThemeData theme, String label, String value, String iconName) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: theme.colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 10.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
