import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/live_status_indicator_widget.dart';
import './widgets/result_analysis_bottom_sheet.dart';
import './widgets/result_card_widget.dart';

class LiveResultsFeed extends StatefulWidget {
  const LiveResultsFeed({super.key});

  @override
  State<LiveResultsFeed> createState() => _LiveResultsFeedState();
}

class _LiveResultsFeedState extends State<LiveResultsFeed>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final Dio _dio = Dio();

  Timer? _updateTimer;
  Timer? _reconnectTimer;

  ConnectionStatus _connectionStatus = ConnectionStatus.connecting;
  DateTime? _lastUpdate;

  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;
  bool _isRefreshing = false;
  int _selectedResultsCount = 0;
  bool _isSelectionMode = false;

  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  // Mock data for live results
  final List<Map<String, dynamic>> _mockResults = [
    {
      'drawId': 'WG240828001',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 2)),
      'winningColor': 'Big',
      'winningNumber': 7,
      'userPrediction': 'Big',
      'isWin': true,
    },
    {
      'drawId': 'WG240828002',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 3)),
      'winningColor': 'Small',
      'winningNumber': 2,
      'userPrediction': 'Big',
      'isWin': false,
    },
    {
      'drawId': 'WG240828003',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'winningColor': 'Big',
      'winningNumber': 8,
      'userPrediction': '',
      'isWin': false,
    },
    {
      'drawId': 'WG240828004',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 7)),
      'winningColor': 'Small',
      'winningNumber': 1,
      'userPrediction': 'Small',
      'isWin': true,
    },
    {
      'drawId': 'WG240828005',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
      'winningColor': 'Big',
      'winningNumber': 9,
      'userPrediction': 'Small',
      'isWin': false,
    },
    {
      'drawId': 'WG240828006',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 12)),
      'winningColor': 'Small',
      'winningNumber': 3,
      'userPrediction': 'Small',
      'isWin': true,
    },
    {
      'drawId': 'WG240828007',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'winningColor': 'Big',
      'winningNumber': 6,
      'userPrediction': '',
      'isWin': false,
    },
    {
      'drawId': 'WG240828008',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 18)),
      'winningColor': 'Small',
      'winningNumber': 4,
      'userPrediction': 'Big',
      'isWin': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeData();
    _startPeriodicUpdates();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _reconnectTimer?.cancel();
    _scrollController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
    _fabAnimationController.forward();
  }

  void _initializeData() {
    setState(() {
      _results = List.from(_mockResults);
      _connectionStatus = ConnectionStatus.connected;
      _lastUpdate = DateTime.now();
    });
  }

  void _startPeriodicUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_connectionStatus == ConnectionStatus.connected) {
        _fetchLatestResults();
      }
    });
  }

  Future<void> _fetchLatestResults() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _connectionStatus = ConnectionStatus.connecting;
    });

    try {
      // Simulate API call to ar-lottery01.com
      await Future.delayed(const Duration(seconds: 2));

      // Mock new result
      final newResult = {
        'drawId': 'WG${DateTime.now().millisecondsSinceEpoch}',
        'timestamp': DateTime.now(),
        'winningColor': DateTime.now().millisecond % 2 == 0 ? 'Big' : 'Small',
        'winningNumber': DateTime.now().millisecond % 10,
        'userPrediction': _generateRandomPrediction(),
        'isWin': DateTime.now().millisecond % 3 == 0,
      };

      setState(() {
        _results.insert(0, newResult);
        _connectionStatus = ConnectionStatus.connected;
        _lastUpdate = DateTime.now();
        _isLoading = false;
      });

      // Trigger haptic feedback for new result
      HapticFeedback.lightImpact();

      // Auto-scroll to top to show new result
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      setState(() {
        _connectionStatus = ConnectionStatus.disconnected;
        _isLoading = false;
      });
      _startReconnectTimer();
    }
  }

  String _generateRandomPrediction() {
    final predictions = ['Big', 'Small', ''];
    return predictions[DateTime.now().millisecond % predictions.length];
  }

  void _startReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 10), () {
      if (_connectionStatus == ConnectionStatus.disconnected) {
        _fetchLatestResults();
      }
    });
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.mediumImpact();
    await _fetchLatestResults();

    setState(() {
      _isRefreshing = false;
    });
  }

  void _showResultAnalysis(Map<String, dynamic> result) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ResultAnalysisBottomSheet(result: result),
    );
  }

  void _showNotificationSettings() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildNotificationSettingsSheet(),
    );
  }

  Widget _buildNotificationSettingsSheet() {
    final theme = Theme.of(context);

    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
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
                  child: Text(
                    'परिणाम सूचना सेटिंग्स',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
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
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(4.w),
              children: [
                _buildNotificationToggle(
                  theme,
                  'नए परिणाम की सूचना',
                  'जब भी नया परिणाम आए तो सूचना भेजें',
                  true,
                ),
                _buildNotificationToggle(
                  theme,
                  'जीत की सूचना',
                  'जब आपकी भविष्यवाणी सही हो तो सूचना भेजें',
                  true,
                ),
                _buildNotificationToggle(
                  theme,
                  'पैटर्न अलर्ट',
                  'जब कोई दिलचस्प पैटर्न मिले तो सूचना भेजें',
                  false,
                ),
                _buildNotificationToggle(
                  theme,
                  'दैनिक सारांश',
                  'दिन के अंत में परिणामों का सारांश भेजें',
                  true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(
    ThemeData theme,
    String title,
    String subtitle,
    bool value,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
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
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              HapticFeedback.lightImpact();
              // Handle toggle
            },
          ),
        ],
      ),
    );
  }

  void _handleResultCardLongPress(int index) {
    HapticFeedback.mediumImpact();
    setState(() {
      _isSelectionMode = true;
      _selectedResultsCount = 1;
    });
  }

  void _exportSelectedResults() {
    HapticFeedback.lightImpact();
    // Handle bulk export
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_selectedResultsCount परिणाम एक्सपोर्ट किए गए'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    setState(() {
      _isSelectionMode = false;
      _selectedResultsCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'लाइव परिणाम फ़ीड',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        actions: [
          if (_isSelectionMode) ...[
            TextButton(
              onPressed: _exportSelectedResults,
              child: Text(
                'एक्सपोर्ट ($_selectedResultsCount)',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              icon: CustomIconWidget(
                iconName: 'settings',
                size: 24,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ],
        leading: _isSelectionMode
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isSelectionMode = false;
                    _selectedResultsCount = 0;
                  });
                },
                icon: CustomIconWidget(
                  iconName: 'close',
                  size: 24,
                  color: theme.colorScheme.onSurface,
                ),
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            LiveStatusIndicatorWidget(
              status: _connectionStatus,
              lastUpdate: _lastUpdate,
              onRetry: _fetchLatestResults,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: theme.colorScheme.primary,
                child: _results.isEmpty
                    ? _buildEmptyState(theme)
                    : ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final result = _results[index];
                          return ResultCardWidget(
                            result: result,
                            onTap: () => _showResultAnalysis(result),
                            onViewPattern: () {
                              Navigator.pushNamed(context, '/pattern-analysis');
                            },
                            onShare: () {
                              HapticFeedback.lightImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('परिणाम साझा किया गया'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            onAddToFavorites: () {
                              HapticFeedback.lightImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('पसंदीदा में जोड़ा गया'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: FloatingActionButton(
              onPressed: _showNotificationSettings,
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              child: CustomIconWidget(
                iconName: 'notifications',
                size: 24,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3, // Live Results Feed index
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        backgroundColor: theme.colorScheme.surface,
        elevation: 8.0,
        onTap: (index) {
          HapticFeedback.lightImpact();
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/prediction-dashboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/ai-analytics-dashboard');
              break;
            case 2:
              Navigator.pushNamed(context, '/prediction-history');
              break;
            case 3:
              // Current screen
              break;
            case 4:
              Navigator.pushNamed(context, '/pattern-analysis');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              size: 24,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            activeIcon: CustomIconWidget(
              iconName: 'dashboard',
              size: 24,
              color: theme.colorScheme.primary,
            ),
            label: 'डैशबोर्ड',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'analytics',
              size: 24,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            activeIcon: CustomIconWidget(
              iconName: 'analytics',
              size: 24,
              color: theme.colorScheme.primary,
            ),
            label: 'एनालिटिक्स',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'history',
              size: 24,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            activeIcon: CustomIconWidget(
              iconName: 'history',
              size: 24,
              color: theme.colorScheme.primary,
            ),
            label: 'इतिहास',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'live_tv',
              size: 24,
              color: theme.colorScheme.primary,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'live_tv',
              size: 24,
              color: theme.colorScheme.primary,
            ),
            label: 'लाइव',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'pattern',
              size: 24,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            activeIcon: CustomIconWidget(
              iconName: 'pattern',
              size: 24,
              color: theme.colorScheme.primary,
            ),
            label: 'पैटर्न',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'live_tv_off',
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          SizedBox(height: 3.h),
          Text(
            'कोई लाइव परिणाम उपलब्ध नहीं',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'कनेक्शन की जांच करें और पुनः प्रयास करें',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: _fetchLatestResults,
            child: const Text('पुनः लोड करें'),
          ),
        ],
      ),
    );
  }
}