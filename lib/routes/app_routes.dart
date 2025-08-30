import 'package:flutter/material.dart';
import '../presentation/settings/settings.dart';
import '../presentation/prediction_history/prediction_history.dart';
import '../presentation/prediction_dashboard/prediction_dashboard.dart';
import '../presentation/live_results_feed/live_results_feed.dart';
import '../presentation/pattern_analysis/pattern_analysis.dart';
import '../presentation/ai_analytics_dashboard/ai_analytics_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String settings = '/settings';
  static const String predictionHistory = '/prediction-history';
  static const String predictionDashboard = '/prediction-dashboard';
  static const String liveResultsFeed = '/live-results-feed';
  static const String patternAnalysis = '/pattern-analysis';
  static const String aiAnalyticsDashboard = '/ai-analytics-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const Settings(),
    settings: (context) => const Settings(),
    predictionHistory: (context) => const PredictionHistory(),
    predictionDashboard: (context) => const PredictionDashboard(),
    liveResultsFeed: (context) => const LiveResultsFeed(),
    patternAnalysis: (context) => const PatternAnalysis(),
    aiAnalyticsDashboard: (context) => const AiAnalyticsDashboard(),
    // TODO: Add your other routes here
  };
}
