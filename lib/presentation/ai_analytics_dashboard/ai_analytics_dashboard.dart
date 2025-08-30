import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/ai_progress_widget.dart';
import './widgets/chart_widget.dart';
import './widgets/detailed_stats_bottom_sheet.dart';
import './widgets/metrics_card_widget.dart';

class AiAnalyticsDashboard extends StatefulWidget {
  const AiAnalyticsDashboard({super.key});

  @override
  State<AiAnalyticsDashboard> createState() => _AiAnalyticsDashboardState();
}

class _AiAnalyticsDashboardState extends State<AiAnalyticsDashboard>
    with TickerProviderStateMixin {
  late TabController _periodTabController;
  int _selectedPeriod = 0; // 0: Daily, 1: Weekly, 2: Monthly
  bool _isRefreshing = false;

  // Mock data for analytics
  final List<Map<String, dynamic>> _metricsData = [
    {
      "title": "भविष्यवाणी सटीकता",
      "value": "87.5%",
      "subtitle": "पिछले 24 घंटे में",
      "icon": Icons.analytics,
      "color": Colors.green,
    },
    {
      "title": "जीत की लकीर",
      "value": "12",
      "subtitle": "लगातार सफल",
      "icon": Icons.trending_up,
      "color": Colors.blue,
    },
    {
      "title": "AI विश्वास स्तर",
      "value": "94.2%",
      "subtitle": "मॉडल आत्मविश्वास",
      "icon": Icons.psychology,
      "color": Colors.purple,
    },
    {
      "title": "पैटर्न मैच",
      "value": "156",
      "subtitle": "पहचाने गए पैटर्न",
      "icon": Icons.pattern,
      "color": Colors.orange,
    },
  ];

  final List<Map<String, dynamic>> _chartData = [
    {"label": "सोम", "value": 85.0, "color": Colors.blue},
    {"label": "मंगल", "value": 92.0, "color": Colors.green},
    {"label": "बुध", "value": 78.0, "color": Colors.orange},
    {"label": "गुरु", "value": 88.0, "color": Colors.purple},
    {"label": "शुक्र", "value": 95.0, "color": Colors.red},
    {"label": "शनि", "value": 82.0, "color": Colors.teal},
    {"label": "रवि", "value": 90.0, "color": Colors.indigo},
  ];

  final List<Map<String, dynamic>> _pieChartData = [
    {"label": "बड़ा", "value": 45.0, "color": Colors.green},
    {"label": "छोटा", "value": 35.0, "color": Colors.blue},
    {"label": "संख्या", "value": 20.0, "color": Colors.orange},
  ];

  final Map<String, dynamic> _detailedStats = {
    "timePatterns": [
      {
        "time": "सुबह 9-12",
        "accuracy": "92.3%",
        "predictions": "45",
        "trend": "बढ़ रहा",
      },
      {
        "time": "दोपहर 12-3",
        "accuracy": "87.1%",
        "predictions": "38",
        "trend": "स्थिर",
      },
      {
        "time": "शाम 3-6",
        "accuracy": "89.5%",
        "predictions": "42",
        "trend": "बढ़ रहा",
      },
      {
        "time": "रात 6-9",
        "accuracy": "85.2%",
        "predictions": "35",
        "trend": "घट रहा",
      },
    ],
    "numberFrequency": [
      {"number": "0", "frequency": "12 बार", "percentage": "8.5%"},
      {"number": "1", "frequency": "18 बार", "percentage": "12.7%"},
      {"number": "2", "frequency": "15 बार", "percentage": "10.6%"},
      {"number": "3", "frequency": "22 बार", "percentage": "15.5%"},
      {"number": "4", "frequency": "14 बार", "percentage": "9.9%"},
      {"number": "5", "frequency": "19 बार", "percentage": "13.4%"},
      {"number": "6", "frequency": "16 बार", "percentage": "11.3%"},
      {"number": "7", "frequency": "21 बार", "percentage": "14.8%"},
      {"number": "8", "frequency": "13 बार", "percentage": "9.2%"},
      {"number": "9", "frequency": "20 बार", "percentage": "14.1%"},
    ],
    "winningProbability": [
      {
        "category": "बड़ा (5-9)",
        "probability": "67.8%",
        "confidence": "उच्च",
        "color": Colors.green,
      },
      {
        "category": "छोटा (0-4)",
        "probability": "58.3%",
        "confidence": "मध्यम",
        "color": Colors.blue,
      },
      {
        "category": "जोड़ संख्या",
        "probability": "52.1%",
        "confidence": "मध्यम",
        "color": Colors.orange,
      },
      {
        "category": "विषम संख्या",
        "probability": "47.9%",
        "confidence": "कम",
        "color": Colors.red,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _periodTabController = TabController(length: 3, vsync: this);
    _periodTabController.addListener(_onPeriodChanged);
  }

  @override
  void dispose() {
    _periodTabController.removeListener(_onPeriodChanged);
    _periodTabController.dispose();
    super.dispose();
  }

  void _onPeriodChanged() {
    if (_periodTabController.indexIsChanging) {
      setState(() {
        _selectedPeriod = _periodTabController.index;
      });
      HapticFeedback.lightImpact();
      _refreshData();
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isRefreshing = false;
    });

    HapticFeedback.lightImpact();
  }

  void _showDetailedStats() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailedStatsBottomSheet(
        statsData: _detailedStats,
        onExport: _exportData,
      ),
    );
  }

  void _exportData() {
    HapticFeedback.lightImpact();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('डेटा निर्यात किया गया'),
        action: SnackBarAction(
          label: 'देखें',
          onPressed: () {},
        ),
      ),
    );
  }

  void _showMetricContextMenu(String metricTitle) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('अलर्ट सेट करें'),
              onTap: () {
                Navigator.pop(context);
                _setAlert(metricTitle);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'compare',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('अवधि तुलना'),
              onTap: () {
                Navigator.pop(context);
                _comparePeriod(metricTitle);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('जानकारी साझा करें'),
              onTap: () {
                Navigator.pop(context);
                _shareInsight(metricTitle);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _setAlert(String metricTitle) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$metricTitle के लिए अलर्ट सेट किया गया')),
    );
  }

  void _comparePeriod(String metricTitle) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$metricTitle की अवधि तुलना खोली गई')),
    );
  }

  void _shareInsight(String metricTitle) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$metricTitle की जानकारी साझा की गई')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'AI एनालिटिक्स डैशबोर्ड',
        variant: CustomAppBarVariant.gaming,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: CustomScrollView(
            slivers: [
              // Period Selection Tab Bar
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
                  child: TabBar(
                    controller: _periodTabController,
                    labelColor: theme.colorScheme.primary,
                    unselectedLabelColor: AppTheme.getTextSecondary(isLight),
                    indicator: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    indicatorPadding: const EdgeInsets.all(4),
                    dividerColor: Colors.transparent,
                    labelStyle: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    tabs: const [
                      Tab(text: 'दैनिक'),
                      Tab(text: 'साप्ताहिक'),
                      Tab(text: 'मासिक'),
                    ],
                  ),
                ),
              ),

              // Metrics Cards
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'मुख्य मेट्रिक्स',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.getTextPrimary(isLight),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Wrap(
                        spacing: 3.w,
                        runSpacing: 2.h,
                        children: _metricsData.map((metric) {
                          return MetricsCardWidget(
                            title: metric['title'] as String,
                            value: metric['value'] as String,
                            subtitle: metric['subtitle'] as String,
                            icon: metric['icon'] as IconData,
                            iconColor: metric['color'] as Color?,
                            onTap: () => _showDetailedStats(),
                            onLongPress: () => _showMetricContextMenu(
                              metric['title'] as String,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // Charts Section
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'प्रदर्शन चार्ट',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.getTextPrimary(isLight),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      ChartWidget(
                        chartType: ChartType.line,
                        title: 'साप्ताहिक सटीकता ट्रेंड',
                        data: _chartData,
                        onTap: _showDetailedStats,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Expanded(
                            child: ChartWidget(
                              chartType: ChartType.bar,
                              title: 'दैनिक प्रदर्शन',
                              data: _chartData.take(4).toList(),
                              onTap: _showDetailedStats,
                              height: 25.h,
                              showLegend: false,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: ChartWidget(
                              chartType: ChartType.pie,
                              title: 'भविष्यवाणी वितरण',
                              data: _pieChartData,
                              onTap: _showDetailedStats,
                              height: 25.h,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // AI Progress Section
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI मॉडल प्रगति',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.getTextPrimary(isLight),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      AiProgressWidget(
                        progress: 0.87,
                        title: 'दैनिक मॉडल सुधार',
                        subtitle: 'आज 3.2% की वृद्धि',
                        motivationalMessage:
                            'बेहतरीन! आपका AI मॉडल लगातार सीख रहा है और बेहतर हो रहा है।',
                        onTap: _showDetailedStats,
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(
        variant: CustomBottomBarVariant.gaming,
        currentIndex: 1,
      ),
    );
  }
}
