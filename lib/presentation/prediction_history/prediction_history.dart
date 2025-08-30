import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/prediction_card_widget.dart';
import './widgets/prediction_detail_modal.dart';
import './widgets/search_bar_widget.dart';
import './widgets/skeleton_card_widget.dart';

class PredictionHistory extends StatefulWidget {
  const PredictionHistory({super.key});

  @override
  State<PredictionHistory> createState() => _PredictionHistoryState();
}

class _PredictionHistoryState extends State<PredictionHistory>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _predictions = [];
  List<Map<String, dynamic>> _filteredPredictions = [];
  List<Map<String, dynamic>> _activeFilters = [];
  Set<int> _selectedPredictions = {};

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isMultiSelectMode = false;
  bool _isRefreshing = false;
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadMockData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadMockData() {
    final List<Map<String, dynamic>> mockPredictions = [
      {
        "id": 1,
        "timestamp": "28/08/2025 09:30",
        "predictedColor": "लाल",
        "predictedNumber": 7,
        "actualColor": "लाल",
        "actualNumber": 7,
        "type": "रंग",
        "amount": "₹500",
        "result": "Win",
        "winAmount": "+₹950",
        "confidence": 0.85,
        "patternMatch": "उच्च",
        "riskLevel": "मध्यम",
        "marketConditions": {
          "volume": "उच्च",
          "trend": "तेजी",
          "volatility": "मध्यम"
        },
        "patterns": [
          {"name": "रेड स्ट्रीक पैटर्न", "match": "87", "strength": "मजबूत"},
          {"name": "टाइम-बेस्ड ट्रेंड", "match": "72", "strength": "मध्यम"}
        ],
        "learningInsights": [
          "यह पैटर्न पिछले 5 दिनों में 3 बार सफल रहा है",
          "सुबह के समय लाल रंग की संभावना 15% अधिक होती है",
          "AI मॉडल ने इस समय सीमा में 82% सटीकता दिखाई है"
        ]
      },
      {
        "id": 2,
        "timestamp": "28/08/2025 09:25",
        "predictedColor": "हरा",
        "predictedNumber": 3,
        "actualColor": "बैंगनी",
        "actualNumber": 0,
        "type": "संख्या",
        "amount": "₹300",
        "result": "Loss",
        "winAmount": "-₹300",
        "confidence": 0.62,
        "patternMatch": "मध्यम",
        "riskLevel": "उच्च",
        "marketConditions": {
          "volume": "मध्यम",
          "trend": "मंदी",
          "volatility": "उच्च"
        },
        "patterns": [
          {"name": "ग्रीन रिवर्सल", "match": "64", "strength": "कमजोर"},
          {"name": "नंबर सीक्वेंस", "match": "58", "strength": "कमजोर"}
        ],
        "learningInsights": [
          "बैंगनी रंग का अप्रत्याशित आना एक दुर्लभ घटना थी",
          "उच्च अस्थिरता के दौरान भविष्यवाणी कम सटीक होती है",
          "AI मॉडल इस पैटर्न से सीख रहा है"
        ]
      },
      {
        "id": 3,
        "timestamp": "28/08/2025 09:20",
        "predictedColor": "बैंगनी",
        "predictedNumber": 5,
        "actualColor": "बैंगनी",
        "actualNumber": 5,
        "type": "बड़ा",
        "amount": "₹750",
        "result": "Win",
        "winAmount": "+₹1425",
        "confidence": 0.91,
        "patternMatch": "उच्च",
        "riskLevel": "कम",
        "marketConditions": {
          "volume": "उच्च",
          "trend": "तेजी",
          "volatility": "कम"
        },
        "patterns": [
          {"name": "वायलेट डोमिनेंस", "match": "93", "strength": "मजबूत"},
          {"name": "बिग नंबर ट्रेंड", "match": "89", "strength": "मजबूत"}
        ],
        "learningInsights": [
          "परफेक्ट मैच - AI की सबसे सटीक भविष्यवाणी",
          "यह पैटर्न 94% सफलता दर के साथ चल रहा है",
          "बैंगनी रंग में निवेश की रणनीति सफल साबित हुई"
        ]
      },
      {
        "id": 4,
        "timestamp": "28/08/2025 09:15",
        "predictedColor": "लाल",
        "predictedNumber": 9,
        "actualColor": "हरा",
        "actualNumber": 1,
        "type": "छोटा",
        "amount": "₹200",
        "result": "Loss",
        "winAmount": "-₹200",
        "confidence": 0.45,
        "patternMatch": "कम",
        "riskLevel": "उच्च",
        "marketConditions": {
          "volume": "कम",
          "trend": "तटस्थ",
          "volatility": "उच्च"
        },
        "patterns": [
          {"name": "रेड फेड पैटर्न", "match": "42", "strength": "कमजोर"},
          {"name": "स्मॉल नंबर शिफ्ट", "match": "38", "strength": "कमजोर"}
        ],
        "learningInsights": [
          "कम विश्वास स्कोर के साथ की गई भविष्यवाणी असफल रही",
          "बाजार में अचानक बदलाव के कारण पैटर्न टूट गया",
          "AI मॉडल को इस तरह के बदलाव के लिए और डेटा चाहिए"
        ]
      },
      {
        "id": 5,
        "timestamp": "28/08/2025 09:10",
        "predictedColor": "हरा",
        "predictedNumber": 2,
        "actualColor": "हरा",
        "actualNumber": 4,
        "type": "रंग",
        "amount": "₹400",
        "result": "Win",
        "winAmount": "+₹760",
        "confidence": 0.78,
        "patternMatch": "उच्च",
        "riskLevel": "मध्यम",
        "marketConditions": {
          "volume": "मध्यम",
          "trend": "तेजी",
          "volatility": "मध्यम"
        },
        "patterns": [
          {"name": "ग्रीन वेव", "match": "81", "strength": "मजबूत"},
          {"name": "कलर कंसिस्टेंसी", "match": "76", "strength": "मध्यम"}
        ],
        "learningInsights": [
          "रंग की भविष्यवाणी सही थी लेकिन संख्या गलत",
          "हरे रंग का ट्रेंड जारी रहा जैसा कि अनुमान था",
          "संख्या की भविष्यवाणी में सुधार की आवश्यकता है"
        ]
      }
    ];

    setState(() {
      _predictions = mockPredictions;
      _filteredPredictions = mockPredictions;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoadingMore = false);
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);
    HapticFeedback.lightImpact();

    await Future.delayed(const Duration(seconds: 2));

    _loadMockData();

    setState(() => _isRefreshing = false);
  }

  void _filterPredictions() {
    List<Map<String, dynamic>> filtered = _predictions;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((prediction) {
        final searchLower = _searchQuery.toLowerCase();
        return (prediction["predictedColor"] as String)
                .toLowerCase()
                .contains(searchLower) ||
            (prediction["actualColor"] as String)
                .toLowerCase()
                .contains(searchLower) ||
            (prediction["type"] as String)
                .toLowerCase()
                .contains(searchLower) ||
            (prediction["result"] as String)
                .toLowerCase()
                .contains(searchLower);
      }).toList();
    }

    for (final filter in _activeFilters) {
      final filterType = filter["type"] as String;
      final filterValue = filter["value"] as String;

      filtered = filtered.where((prediction) {
        switch (filterType) {
          case 'result':
            return (prediction["result"] as String).toLowerCase() ==
                filterValue.toLowerCase();
          case 'type':
            return (prediction["type"] as String).toLowerCase() ==
                filterValue.toLowerCase();
          case 'color':
            return (prediction["predictedColor"] as String).toLowerCase() ==
                filterValue.toLowerCase();
          default:
            return true;
        }
      }).toList();
    }

    setState(() => _filteredPredictions = filtered);
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    final theme = Theme.of(context);

    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'फिल्टर',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _activeFilters.clear());
                    _filterPredictions();
                    Navigator.pop(context);
                  },
                  child: const Text('साफ़ करें'),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection('परिणाम', 'result', ['Win', 'Loss']),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                      'प्रकार', 'type', ['रंग', 'संख्या', 'बड़ा', 'छोटा']),
                  SizedBox(height: 3.h),
                  _buildFilterSection('रंग', 'color', ['लाल', 'हरा', 'बैंगनी']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
      String title, String filterType, List<String> options) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = _activeFilters.any((filter) =>
                filter["type"] == filterType && filter["value"] == option);

            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  if (isSelected) {
                    _activeFilters.removeWhere((filter) =>
                        filter["type"] == filterType &&
                        filter["value"] == option);
                  } else {
                    _activeFilters.add({
                      "type": filterType,
                      "value": option,
                      "count": _getFilterCount(filterType, option),
                    });
                  }
                });
                _filterPredictions();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.dividerColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  option,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  int _getFilterCount(String filterType, String filterValue) {
    return _predictions.where((prediction) {
      switch (filterType) {
        case 'result':
          return (prediction["result"] as String).toLowerCase() ==
              filterValue.toLowerCase();
        case 'type':
          return (prediction["type"] as String).toLowerCase() ==
              filterValue.toLowerCase();
        case 'color':
          return (prediction["predictedColor"] as String).toLowerCase() ==
              filterValue.toLowerCase();
        default:
          return false;
      }
    }).length;
  }

  void _toggleMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedPredictions.clear();
      }
    });
  }

  void _showBulkActionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'file_download',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                title: Text('निर्यात करें (${_selectedPredictions.length})'),
                onTap: () {
                  Navigator.pop(context);
                  _exportSelectedPredictions();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'analytics',
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
                title: Text('पैटर्न विश्लेषण (${_selectedPredictions.length})'),
                onTap: () {
                  Navigator.pop(context);
                  _analyzeSelectedPatterns();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: Theme.of(context).colorScheme.error,
                  size: 24,
                ),
                title: Text('हटाएं (${_selectedPredictions.length})'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteSelectedPredictions();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _exportSelectedPredictions() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('${_selectedPredictions.length} भविष्यवाणियां निर्यात की गईं'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
    _toggleMultiSelectMode();
  }

  void _analyzeSelectedPatterns() {
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, '/pattern-analysis');
    _toggleMultiSelectMode();
  }

  void _deleteSelectedPredictions() {
    HapticFeedback.mediumImpact();
    setState(() {
      _predictions.removeWhere(
          (prediction) => _selectedPredictions.contains(prediction["id"]));
      _filterPredictions();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedPredictions.length} भविष्यवाणियां हटाई गईं'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
    _toggleMultiSelectMode();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _isMultiSelectMode
              ? '${_selectedPredictions.length} चयनित'
              : 'भविष्यवाणी इतिहास',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: _isMultiSelectMode
            ? IconButton(
                onPressed: _toggleMultiSelectMode,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'arrow_back_ios',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
        actions: [
          if (_isMultiSelectMode && _selectedPredictions.isNotEmpty)
            IconButton(
              onPressed: _showBulkActionsBottomSheet,
              icon: CustomIconWidget(
                iconName: 'more_vert',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
            )
          else if (!_isMultiSelectMode && _filteredPredictions.isNotEmpty)
            IconButton(
              onPressed: _toggleMultiSelectMode,
              icon: CustomIconWidget(
                iconName: 'checklist',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SearchBarWidget(
              initialValue: _searchQuery,
              onChanged: (query) {
                setState(() => _searchQuery = query);
                _filterPredictions();
              },
              onFilterTap: _showFilterBottomSheet,
              hasActiveFilters: _activeFilters.isNotEmpty,
            ),
            FilterChipsWidget(
              activeFilters: _activeFilters,
              onFilterRemoved: (filter) {
                setState(() => _activeFilters.remove(filter));
                _filterPredictions();
              },
              onClearAll: () {
                setState(() => _activeFilters.clear());
                _filterPredictions();
              },
            ),
            Expanded(
              child: _filteredPredictions.isEmpty
                  ? EmptyStateWidget(
                      onStartPredicting: () {
                        Navigator.pushNamed(context, '/prediction-dashboard');
                      },
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshData,
                      color: theme.colorScheme.primary,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _filteredPredictions.length +
                            (_isLoadingMore ? 3 : 0),
                        itemBuilder: (context, index) {
                          if (index >= _filteredPredictions.length) {
                            return const SkeletonCardWidget();
                          }

                          final prediction = _filteredPredictions[index];
                          final isSelected =
                              _selectedPredictions.contains(prediction["id"]);

                          return PredictionCardWidget(
                            prediction: prediction,
                            isSelected: isSelected,
                            isMultiSelectMode: _isMultiSelectMode,
                            onTap: () {
                              if (!_isMultiSelectMode) {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (context) => PredictionDetailModal(
                                    prediction: prediction,
                                  ),
                                );
                              }
                            },
                            onSelectionChanged: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedPredictions
                                      .add(prediction["id"] as int);
                                } else {
                                  _selectedPredictions.remove(prediction["id"]);
                                }
                              });
                            },
                            onShare: () {
                              HapticFeedback.lightImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('भविष्यवाणी साझा की गई')),
                              );
                            },
                            onDelete: () {
                              HapticFeedback.mediumImpact();
                              setState(() {
                                _predictions.removeWhere(
                                    (p) => p["id"] == prediction["id"]);
                                _filterPredictions();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('भविष्यवाणी हटाई गई')),
                              );
                            },
                            onViewDetails: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) => PredictionDetailModal(
                                  prediction: prediction,
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
    );
  }
}
