
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/analysis_type_selector.dart';
import './widgets/pattern_card_widget.dart';
import './widgets/pattern_detail_modal.dart';
import './widgets/pattern_heatmap_widget.dart';
import './widgets/trend_chart_widget.dart';
import 'widgets/analysis_type_selector.dart';
import 'widgets/pattern_card_widget.dart';
import 'widgets/pattern_detail_modal.dart';
import 'widgets/pattern_heatmap_widget.dart';
import 'widgets/trend_chart_widget.dart';

class PatternAnalysis extends StatefulWidget {
  const PatternAnalysis({super.key});

  @override
  State<PatternAnalysis> createState() => _PatternAnalysisState();
}

class _PatternAnalysisState extends State<PatternAnalysis>
    with TickerProviderStateMixin {
  int _selectedAnalysisType = 0;
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isComparisonMode = false;
  final Set<int> _selectedPatterns = {};

  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  final List<String> _analysisTypes = [
    'संख्या पैटर्न',
    'रंग ट्रेंड',
    'समय आधारित',
  ];

  // Mock data for patterns
  final List<Map<String, dynamic>> _mockPatterns = [
{ 'id': 1,
'type': 'संख्या अनुक्रम',
'description': 'सम संख्याओं के बाद विषम संख्याओं का पैटर्न देखा गया है',
'detailedDescription': 'पिछले 15 दिनों के डेटा में यह पैटर्न 78% सटीकता के साथ दिखाई दे रहा है। यह मुख्यतः दोपहर 2-4 बजे के बीच अधिक प्रभावी है।',
'confidence': 0.85,
'frequency': 42,
'successRate': 0.78,
'trend': 'increasing',
'successProbability': 0.82,
'suggestions': [ 'दोपहर 2-4 बजे के बीच इस पैटर्न का उपयोग करें',
'पहले छोटी राशि से परीक्षण करें',
'लगातार 3 सम संख्याओं के बाद विषम पर दांव लगाएं',
'यदि पैटर्न टूटे तो तुरंत रुकें',
],
'validation': { 'totalTests': 156,
'successfulPredictions': 122,
'averageAccuracy': 0.782,
'lastUpdated': '2025-08-28',
},
},
{ 'id': 2,
'type': 'रंग चक्र',
'description': 'लाल और हरे रंग के बीच एक निश्चित चक्रीय पैटर्न मिला है',
'detailedDescription': 'AI विश्लेषण से पता चला है कि लाल रंग के 2-3 बार आने के बाद हरा रंग आने की संभावना 73% तक बढ़ जाती है।',
'confidence': 0.73,
'frequency': 38,
'successRate': 0.69,
'trend': 'stable',
'successProbability': 0.71,
'suggestions': [ 'लगातार 2 लाल के बाद हरे पर दांव लगाएं',
'शाम के समय यह पैटर्न अधिक सटीक है',
'मध्यम राशि के साथ शुरुआत करें',
'पैटर्न की पुष्टि के लिए 5 राउंड देखें',
],
'validation': { 'totalTests': 134,
'successfulPredictions': 92,
'averageAccuracy': 0.687,
'lastUpdated': '2025-08-28',
},
},
{ 'id': 3,
'type': 'समय आधारित',
'description': 'सुबह 10-12 बजे के बीच छोटी संख्याओं का प्रभुत्व देखा गया',
'detailedDescription': 'समय-आधारित विश्लेषण में पाया गया कि सुबह के समय 0-4 की संख्याएं 65% अधिक आती हैं।',
'confidence': 0.68,
'frequency': 29,
'successRate': 0.62,
'trend': 'decreasing',
'successProbability': 0.64,
'suggestions': [ 'सुबह 10-12 बजे छोटी संख्याओं पर फोकस करें',
'दोपहर बाद बड़ी संख्याओं की संभावना बढ़ती है',
'सप्ताहांत में यह पैटर्न कम प्रभावी है',
'मौसम के अनुसार पैटर्न में बदलाव हो सकता है',
],
'validation': { 'totalTests': 98,
'successfulPredictions': 61,
'averageAccuracy': 0.622,
'lastUpdated': '2025-08-28',
},
},
{ 'id': 4,
'type': 'AI पैटर्न',
'description': 'मशीन लर्निंग द्वारा खोजा गया एक जटिल संयोजन पैटर्न',
'detailedDescription': 'यह एक उन्नत AI पैटर्न है जो कई कारकों को मिलाकर भविष्यवाणी करता है। इसमें समय, पिछले परिणाम और संख्या वितरण शामिल है।',
'confidence': 0.91,
'frequency': 18,
'successRate': 0.89,
'trend': 'increasing',
'successProbability': 0.87,
'suggestions': [ 'यह पैटर्न केवल अनुभवी खिलाड़ियों के लिए है',
'उच्च राशि के साथ सावधानी से उपयोग करें',
'AI सिग्नल की पुष्टि का इंतजार करें',
'दैनिक केवल 3-5 बार ही उपयोग करें',
],
'validation': { 'totalTests': 67,
'successfulPredictions': 60,
'averageAccuracy': 0.896,
'lastUpdated': '2025-08-28',
},
},
];

 
 // Mock data for heatmap
final List<Map<String, dynamic>> _mockHeatmapData = List.generate(100, (index) {
  return {
    'position': index,
    'intensity': (index % 7) / 6.0 + (index % 3) / 10.0,
  };
});

// Mock data for charts
final List<Map<String, dynamic>> _mockChartData = List.generate(24, (index) {
  return {
    'time': index,
    'value': 30.0 + sin(index * 2.5) * 25 + cos(index * 0.8) * 15,

  };
});

@override
void initState() {
  super.initState();
  _fadeAnimationController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  _fadeAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: _fadeAnimationController,
    curve: Curves.easeInOut,
  ));

  _fadeAnimationController.forward();
  _loadPatternData();
}

@override
void dispose() {
  _fadeAnimationController.dispose();
  super.dispose();
}

Future<void> _loadPatternData() async {
  setState(() {
    _isLoading = true;
  });

  // Simulate API call
  await Future.delayed(const Duration(milliseconds: 800));

  setState(() {
    _isLoading = false;
  });
}

Future<void> _refreshPatterns() async {
  setState(() {
    _isRefreshing = true;
  });

  HapticFeedback.lightImpact();

  // Simulate pattern recognition update
  await Future.delayed(const Duration(seconds: 2));

  setState(() {
    _isRefreshing = false;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'पैटर्न विश्लेषण अपडेट हो गया',
        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
      ),
      backgroundColor: AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}


  void _showPatternDetail(Map<String, dynamic> pattern) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PatternDetailModal(
        pattern: pattern,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _toggleComparisonMode() {
    setState(() {
      _isComparisonMode = !_isComparisonMode;
      _selectedPatterns.clear();
    });
    
    HapticFeedback.lightImpact();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isComparisonMode ? 'तुलना मोड सक्रिय' : 'तुलना मोड निष्क्रिय',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _exportPatterns() {
    HapticFeedback.lightImpact();
    
    // Generate mock report content
    final reportContent = '''
पैटर्न विश्लेषण रिपोर्ट
दिनांक: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}

कुल पैटर्न: ${_mockPatterns.length}
औसत सटीकता: ${(_mockPatterns.map((p) => p['confidence'] as double).reduce((a, b) => a + b) / _mockPatterns.length * 100).toInt()}%

विस्तृत पैटर्न:
${_mockPatterns.map((p) => '- ${p['type']}: ${((p['confidence'] as double) * 100).toInt()}% सटीकता').join('\n')}

सुझाव:
- उच्च सटीकता वाले पैटर्न का उपयोग करें
- छोटी राशि से शुरुआत करें
- नियमित रूप से पैटर्न अपडेट करें
    ''';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'रिपोर्ट तैयार की गई - डाउनलोड शुरू हो रहा है',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'देखें',
          textColor: Colors.white,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'पैटर्न रिपोर्ट',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                content: SingleChildScrollView(
                  child: Text(
                    reportContent,
                    style: GoogleFonts.jetBrainsMono(fontSize: 12),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('बंद करें'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'पैटर्न विश्लेषण',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 2,
        shadowColor: theme.shadowColor.withValues(alpha: 0.1),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: theme.colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_isComparisonMode)
            IconButton(
              icon: CustomIconWidget(
                iconName: 'compare',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              onPressed: _toggleComparisonMode,
              tooltip: 'तुलना मोड बंद करें',
            )
          else
            IconButton(
              icon: CustomIconWidget(
                iconName: 'compare_arrows',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                size: 24,
              ),
              onPressed: _toggleComparisonMode,
              tooltip: 'तुलना मोड',
            ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'notifications_outlined',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'पैटर्न अलर्ट सेटअप जल्द ही उपलब्ध होगा',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            tooltip: 'पैटर्न अलर्ट',
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState(theme)
          : _mockPatterns.isEmpty
              ? _buildEmptyState(theme, isLight)
              : RefreshIndicator(
                  onRefresh: _refreshPatterns,
                  color: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.surface,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              SizedBox(height: 1.h),
                              AnalysisTypeSelector(
                                analysisTypes: _analysisTypes,
                                selectedIndex: _selectedAnalysisType,
                                onSelectionChanged: (index) {
                                  setState(() {
                                    _selectedAnalysisType = index;
                                  });
                                  HapticFeedback.lightImpact();
                                },
                              ),
                              SizedBox(height: 2.h),
                              _buildVisualizationSection(theme, isLight),
                              SizedBox(height: 2.h),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Row(
                              children: [
                                Text(
                                  'खोजे गए पैटर्न',
                                  style: GoogleFonts.inter(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const Spacer(),
                                if (_isComparisonMode)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${_selectedPatterns.length} चयनित',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final pattern = _mockPatterns[index];
                              final isSelected = _selectedPatterns.contains(pattern['id']);
                              
                              return Container(
                                decoration: _isComparisonMode && isSelected
                                    ? BoxDecoration(
                                        border: Border.all(
                                          color: theme.colorScheme.primary,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        color: theme.colorScheme.primary.withValues(alpha: 0.05),
                                      )
                                    : null,
                                margin: _isComparisonMode && isSelected
                                    ? EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h)
                                    : null,
                                child: PatternCardWidget(
                                  pattern: pattern,
                                  onTap: () {
                                    if (_isComparisonMode) {
                                      setState(() {
                                        if (isSelected) {
                                          _selectedPatterns.remove(pattern['id']);
                                        } else {
                                          _selectedPatterns.add(pattern['id']);
                                        }
                                      });
                                      HapticFeedback.lightImpact();
                                    } else {
                                      _showPatternDetail(pattern);
                                    }
                                  },
                                  onLongPress: () {
                                    if (!_isComparisonMode) {
                                      _toggleComparisonMode();
                                      setState(() {
                                        _selectedPatterns.add(pattern['id']);
                                      });
                                    }
                                  },
                                ),
                              );
                            },
                            childCount: _mockPatterns.length,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: 10.h),
                        ),
                      ],
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _exportPatterns,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        icon: CustomIconWidget(
          iconName: 'file_download',
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          'रिपोर्ट निर्यात',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildVisualizationSection(ThemeData theme, bool isLight) {
    switch (_selectedAnalysisType) {
      case 0: // Number Patterns
        return PatternHeatmapWidget(
          heatmapData: _mockHeatmapData,
          title: 'संख्या आवृत्ति हीट मैप',
          onTap: () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'हीट मैप में गहरे रंग अधिक आवृत्ति दर्शाते हैं',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                backgroundColor: theme.colorScheme.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
        );
      case 1: // Color Trends
        return TrendChartWidget(
          chartData: _mockChartData,
          title: 'रंग ट्रेंड विश्लेषण',
          chartType: 'bar',
          onTap: () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'चार्ट को ज़ूम करने के लिए स्पर्श करें',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                backgroundColor: theme.colorScheme.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
        );
      case 2: // Time-based Analysis
        return TrendChartWidget(
          chartData: _mockChartData,
          title: 'समय आधारित पैटर्न',
          chartType: 'line',
          onTap: () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '24 घंटे की समय सीरीज़ दिखाई गई है',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                backgroundColor: theme.colorScheme.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            strokeWidth: 3,
          ),
          SizedBox(height: 3.h),
          Text(
            'पैटर्न विश्लेषण हो रहा है...',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'AI आपके लिए बेहतरीन पैटर्न खोज रहा है',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isLight) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'analytics',
                color: theme.colorScheme.primary,
                size: 48,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'पैटर्न विश्लेषण के लिए पर्याप्त डेटा नहीं',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'AI को सार्थक पैटर्न खोजने के लिए कम से कम 50 गेम का डेटा चाहिए। कृपया कुछ गेम खेलें और फिर वापस आएं।',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            LinearProgressIndicator(
              value: 0.3, // Mock progress
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              minHeight: 1.h,
            ),
            SizedBox(height: 2.h),
            Text(
              'डेटा संग्रह: 15/50 गेम पूर्ण',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'अनुमानित समय: 2-3 दिन',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/prediction-dashboard');
              },
              icon: CustomIconWidget(
                iconName: 'play_arrow',
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                'गेम खेलना शुरू करें',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
