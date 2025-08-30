import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DetailedStatsBottomSheet extends StatefulWidget {
  final Map<String, dynamic> statsData;
  final VoidCallback? onExport;

  const DetailedStatsBottomSheet({
    super.key,
    required this.statsData,
    this.onExport,
  });

  @override
  State<DetailedStatsBottomSheet> createState() =>
      _DetailedStatsBottomSheetState();
}

class _DetailedStatsBottomSheetState extends State<DetailedStatsBottomSheet>
    with TickerProviderStateMixin {
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
    final isLight = theme.brightness == Brightness.light;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(theme, isLight),
          _buildTabBar(theme, isLight),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTimePatterns(theme, isLight),
                _buildNumberFrequency(theme, isLight),
                _buildWinningProbability(theme, isLight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isLight) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
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
                'विस्तृत आंकड़े',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.getTextPrimary(isLight),
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
                    tooltip: 'निर्यात करें',
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.getTextSecondary(isLight),
                      size: 24,
                    ),
                    tooltip: 'बंद करें',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme, bool isLight) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: AppTheme.getTextSecondary(isLight),
        indicator: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        tabs: const [
          Tab(text: 'समय पैटर्न'),
          Tab(text: 'संख्या आवृत्ति'),
          Tab(text: 'जीत संभावना'),
        ],
      ),
    );
  }

  Widget _buildTimePatterns(ThemeData theme, bool isLight) {
    final timePatterns =
        (widget.statsData['timePatterns'] as List<Map<String, dynamic>>?) ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'समय आधारित पैटर्न विश्लेषण',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.getTextPrimary(isLight),
            ),
          ),
          SizedBox(height: 2.h),
          ...timePatterns.map((pattern) => _buildPatternCard(
                theme,
                isLight,
                pattern['time'] as String? ?? '',
                pattern['accuracy'] as String? ?? '',
                pattern['predictions'] as String? ?? '',
                pattern['trend'] as String? ?? '',
              )),
        ],
      ),
    );
  }

  Widget _buildNumberFrequency(ThemeData theme, bool isLight) {
    final numberFrequency =
        (widget.statsData['numberFrequency'] as List<Map<String, dynamic>>?) ??
            [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'संख्या आवृत्ति विश्लेषण',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.getTextPrimary(isLight),
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 2.5,
            ),
            itemCount: numberFrequency.length,
            itemBuilder: (context, index) {
              final item = numberFrequency[index];
              return _buildFrequencyCard(
                theme,
                isLight,
                item['number'] as String? ?? '',
                item['frequency'] as String? ?? '',
                item['percentage'] as String? ?? '',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWinningProbability(ThemeData theme, bool isLight) {
    final winningProb = (widget.statsData['winningProbability']
            as List<Map<String, dynamic>>?) ??
        [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'जीत संभावना वितरण',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.getTextPrimary(isLight),
            ),
          ),
          SizedBox(height: 2.h),
          ...winningProb.map((prob) => _buildProbabilityCard(
                theme,
                isLight,
                prob['category'] as String? ?? '',
                prob['probability'] as String? ?? '',
                prob['confidence'] as String? ?? '',
                prob['color'] as Color? ?? theme.colorScheme.primary,
              )),
        ],
      ),
    );
  }

  Widget _buildPatternCard(
    ThemeData theme,
    bool isLight,
    String time,
    String accuracy,
    String predictions,
    String trend,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
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
                time,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.getTextPrimary(isLight),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  trend,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'सटीकता',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.getTextSecondary(isLight),
                    ),
                  ),
                  Text(
                    accuracy,
                    style: AppTheme.dataTextStyle(
                      isLight: isLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'भविष्यवाणियां',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.getTextSecondary(isLight),
                    ),
                  ),
                  Text(
                    predictions,
                    style: AppTheme.dataTextStyle(
                      isLight: isLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyCard(
    ThemeData theme,
    bool isLight,
    String number,
    String frequency,
    String percentage,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: AppTheme.dataTextStyle(
              isLight: isLight,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            frequency,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.getTextSecondary(isLight),
            ),
          ),
          Text(
            percentage,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProbabilityCard(
    ThemeData theme,
    bool isLight,
    String category,
    String probability,
    String confidence,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 8.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.getTextPrimary(isLight),
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'संभावना',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.getTextSecondary(isLight),
                          ),
                        ),
                        Text(
                          probability,
                          style: AppTheme.dataTextStyle(
                            isLight: isLight,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'विश्वास',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.getTextSecondary(isLight),
                          ),
                        ),
                        Text(
                          confidence,
                          style: AppTheme.dataTextStyle(
                            isLight: isLight,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
