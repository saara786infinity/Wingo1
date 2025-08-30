import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_info_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/storage_usage_widget.dart';
import './widgets/user_profile_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;

  // Settings state variables
  bool _predictionAlerts = true;
  bool _resultNotifications = true;
  bool _aiInsights = false;
  double _modelSensitivity = 0.7;
  double _predictionConfidence = 0.8;
  bool _autoLearning = true;
  bool _dataSync = true;
  bool _offlineMode = false;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "name": "राहुल शर्मा",
    "email": "rahul.sharma@example.com",
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "joinDate": "15 मार्च 2024",
  };

  // Mock app data
  final Map<String, dynamic> _appData = {
    "version": "2.1.4",
    "buildNumber": "2024082801",
    "lastUpdate": "28 अगस्त 2024",
    "usedStorage": 45.7,
    "totalStorage": 100.0,
  };

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.mediumImpact();
    _refreshController.forward();

    // Simulate checking for updates
    await Future.delayed(const Duration(seconds: 2));

    _refreshController.reverse();

    if (mounted) {
      Fluttertoast.showToast(
        msg: "सेटिंग्स अपडेट हो गईं",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.primary,
        textColor: Colors.white,
      );
    }
  }

  void _showExportDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildExportBottomSheet(),
    );
  }

  void _showAIModelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI मॉडल सेटिंग्स'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'मॉडल संवेदनशीलता: ${_modelSensitivity.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Slider(
              value: _modelSensitivity,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _modelSensitivity = value;
                });
              },
            ),
            SizedBox(height: 2.h),
            Text(
              'भविष्यवाणी विश्वास: ${_predictionConfidence.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Slider(
              value: _predictionConfidence,
              min: 0.5,
              max: 1.0,
              divisions: 5,
              onChanged: (value) {
                setState(() {
                  _predictionConfidence = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('रद्द करें'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveSettings();
            },
            child: const Text('सहेजें'),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('कैश साफ़ करें'),
        content: const Text(
            'क्या आप वाकई सभी कैश डेटा साफ़ करना चाहते हैं? इससे ऐप की गति प्रभावित हो सकती है।'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('रद्द करें'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performCacheClear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('साफ़ करें'),
          ),
        ],
      ),
    );
  }

  void _performCacheClear() async {
    // Simulate cache clearing
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _appData["usedStorage"] = 12.3;
    });

    Fluttertoast.showToast(
      msg: "कैश सफलतापूर्वक साफ़ किया गया",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.getSuccessColor(
          Theme.of(context).brightness == Brightness.light),
      textColor: Colors.white,
    );
  }

  void _saveSettings() {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "सेटिंग्स सहेजी गईं",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('सेटिंग्स'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        actions: [
          IconButton(
            icon: AnimatedBuilder(
              animation: _refreshAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _refreshAnimation.value * 2 * 3.14159,
                  child: CustomIconWidget(
                    iconName: 'refresh',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                );
              },
            ),
            onPressed: _handleRefresh,
            tooltip: 'रिफ्रेश करें',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: theme.colorScheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Column(
              children: [
                // User Profile Section
                UserProfileWidget(
                  userName: _userData["name"] as String,
                  userEmail: _userData["email"] as String,
                  avatarUrl: _userData["avatar"] as String?,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Navigate to profile edit
                  },
                ),

                // Notification Preferences
                SettingsSectionWidget(
                  title: 'सूचना प्राथमिकताएं',
                  children: [
                    SettingsItemWidget(
                      title: 'भविष्यवाणी अलर्ट',
                      subtitle: 'नई भविष्यवाणियों के लिए सूचनाएं',
                      iconName: 'notifications',
                      type: SettingsItemType.toggle,
                      toggleValue: _predictionAlerts,
                      onToggleChanged: (value) {
                        setState(() {
                          _predictionAlerts = value;
                        });
                        _saveSettings();
                      },
                      showHelpIcon: true,
                    ),
                    SettingsItemWidget(
                      title: 'परिणाम सूचनाएं',
                      subtitle: 'भविष्यवाणी परिणामों की सूचनाएं',
                      iconName: 'announcement',
                      type: SettingsItemType.toggle,
                      toggleValue: _resultNotifications,
                      onToggleChanged: (value) {
                        setState(() {
                          _resultNotifications = value;
                        });
                        _saveSettings();
                      },
                      showHelpIcon: true,
                    ),
                    SettingsItemWidget(
                      title: 'AI अंतर्दृष्टि',
                      subtitle: 'AI विश्लेषण और सुझाव',
                      iconName: 'psychology',
                      type: SettingsItemType.toggle,
                      toggleValue: _aiInsights,
                      onToggleChanged: (value) {
                        setState(() {
                          _aiInsights = value;
                        });
                        _saveSettings();
                      },
                      isLast: true,
                      showHelpIcon: true,
                    ),
                  ],
                ),

                // AI Settings
                SettingsSectionWidget(
                  title: 'AI सेटिंग्स',
                  children: [
                    SettingsItemWidget(
                      title: 'मॉडल संवेदनशीलता',
                      subtitle: 'AI मॉडल की संवेदनशीलता स्तर',
                      iconName: 'tune',
                      type: SettingsItemType.slider,
                      sliderValue: _modelSensitivity,
                      sliderMin: 0.1,
                      sliderMax: 1.0,
                      onSliderChanged: (value) {
                        setState(() {
                          _modelSensitivity = value;
                        });
                        _saveSettings();
                      },
                      showHelpIcon: true,
                    ),
                    SettingsItemWidget(
                      title: 'भविष्यवाणी विश्वास',
                      subtitle: 'न्यूनतम विश्वास स्तर सीमा',
                      iconName: 'verified',
                      type: SettingsItemType.slider,
                      sliderValue: _predictionConfidence,
                      sliderMin: 0.5,
                      sliderMax: 1.0,
                      onSliderChanged: (value) {
                        setState(() {
                          _predictionConfidence = value;
                        });
                        _saveSettings();
                      },
                      showHelpIcon: true,
                    ),
                    SettingsItemWidget(
                      title: 'स्वचालित सीखना',
                      subtitle: 'AI मॉडल स्वचालित रूप से सीखता रहे',
                      iconName: 'school',
                      type: SettingsItemType.toggle,
                      toggleValue: _autoLearning,
                      onToggleChanged: (value) {
                        setState(() {
                          _autoLearning = value;
                        });
                        _saveSettings();
                      },
                    ),
                    SettingsItemWidget(
                      title: 'उन्नत AI सेटिंग्स',
                      subtitle: 'विस्तृत AI कॉन्फ़िगरेशन',
                      iconName: 'settings',
                      type: SettingsItemType.navigation,
                      onTap: _showAIModelDialog,
                      isLast: true,
                    ),
                  ],
                ),

                // Data Management
                SettingsSectionWidget(
                  title: 'डेटा प्रबंधन',
                  children: [
                    SettingsItemWidget(
                      title: 'डेटा सिंक',
                      subtitle: 'क्लाउड के साथ डेटा सिंक करें',
                      iconName: 'sync',
                      type: SettingsItemType.toggle,
                      toggleValue: _dataSync,
                      onToggleChanged: (value) {
                        setState(() {
                          _dataSync = value;
                        });
                        _saveSettings();
                      },
                    ),
                    SettingsItemWidget(
                      title: 'ऑफ़लाइन मोड',
                      subtitle: 'इंटरनेट के बिना काम करें',
                      iconName: 'offline_bolt',
                      type: SettingsItemType.toggle,
                      toggleValue: _offlineMode,
                      onToggleChanged: (value) {
                        setState(() {
                          _offlineMode = value;
                        });
                        _saveSettings();
                      },
                    ),
                    SettingsItemWidget(
                      title: 'डेटा निर्यात',
                      subtitle: 'अपना डेटा निर्यात करें',
                      iconName: 'file_download',
                      type: SettingsItemType.navigation,
                      onTap: _showExportDialog,
                      isLast: true,
                    ),
                  ],
                ),

                // Storage Usage
                StorageUsageWidget(
                  usedStorage: _appData["usedStorage"] as double,
                  totalStorage: _appData["totalStorage"] as double,
                  onClearCache: _clearCache,
                ),

                // Language and Region
                SettingsSectionWidget(
                  title: 'भाषा और क्षेत्र',
                  children: [
                    SettingsItemWidget(
                      title: 'भाषा',
                      subtitle: 'ऐप की भाषा चुनें',
                      iconName: 'language',
                      type: SettingsItemType.info,
                      trailingText: 'हिंदी',
                      onTap: () {
                        // Show language selection
                      },
                    ),
                    SettingsItemWidget(
                      title: 'मुद्रा प्रारूप',
                      subtitle: 'मुद्रा प्रदर्शन प्रारूप',
                      iconName: 'currency_rupee',
                      type: SettingsItemType.info,
                      trailingText: '₹ (INR)',
                      onTap: () {
                        // Show currency selection
                      },
                    ),
                    SettingsItemWidget(
                      title: 'दिनांक प्रारूप',
                      subtitle: 'दिनांक प्रदर्शन प्रारूप',
                      iconName: 'calendar_today',
                      type: SettingsItemType.info,
                      trailingText: 'DD/MM/YYYY',
                      onTap: () {
                        // Show date format selection
                      },
                      isLast: true,
                    ),
                  ],
                ),

                // Privacy and Security
                SettingsSectionWidget(
                  title: 'गोपनीयता और सुरक्षा',
                  children: [
                    SettingsItemWidget(
                      title: 'डेटा उपयोग',
                      subtitle: 'डेटा उपयोग की पारदर्शिता',
                      iconName: 'privacy_tip',
                      type: SettingsItemType.navigation,
                      onTap: () {
                        // Show data usage details
                      },
                    ),
                    SettingsItemWidget(
                      title: 'API कनेक्शन स्थिति',
                      subtitle: 'बाहरी API कनेक्शन की स्थिति',
                      iconName: 'api',
                      type: SettingsItemType.info,
                      trailingText: 'सक्रिय',
                      onTap: () {
                        // Show API status details
                      },
                    ),
                    SettingsItemWidget(
                      title: 'गोपनीयता नीति',
                      subtitle: 'हमारी गोपनीयता नीति पढ़ें',
                      iconName: 'policy',
                      type: SettingsItemType.navigation,
                      onTap: () {
                        // Open privacy policy
                      },
                      isLast: true,
                    ),
                  ],
                ),

                // App Information
                AppInfoWidget(
                  appVersion: _appData["version"] as String,
                  buildNumber: _appData["buildNumber"] as String,
                  onVersionTap: () {
                    // Show version details or easter egg
                    Fluttertoast.showToast(
                      msg: "अंतिम अपडेट: ${_appData["lastUpdate"]}",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                    );
                  },
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExportBottomSheet() {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'डेटा निर्यात करें',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'अपना डेटा निर्यात करने के लिए प्रारूप चुनें',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          _buildExportOption(
            context,
            theme,
            'CSV फ़ाइल',
            'भविष्यवाणी इतिहास और आंकड़े',
            'table_chart',
            () => _exportData('csv'),
          ),
          _buildExportOption(
            context,
            theme,
            'JSON फ़ाइल',
            'संपूर्ण ऐप डेटा',
            'code',
            () => _exportData('json'),
          ),
          _buildExportOption(
            context,
            theme,
            'PDF रिपोर्ट',
            'विस्तृत विश्लेषण रिपोर्ट',
            'picture_as_pdf',
            () => _exportData('pdf'),
          ),
          SizedBox(height: 2.h),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('रद्द करें'),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildExportOption(
    BuildContext context,
    ThemeData theme,
    String title,
    String subtitle,
    String iconName,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        leading: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: theme.colorScheme.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'download',
          color: theme.colorScheme.primary,
          size: 20,
        ),
        onTap: () {
          Navigator.of(context).pop();
          onTap();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: theme.colorScheme.surface,
      ),
    );
  }

  void _exportData(String format) async {
    HapticFeedback.mediumImpact();

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            SizedBox(width: 4.w),
            const Text('डेटा निर्यात हो रहा है...'),
          ],
        ),
      ),
    );

    // Simulate export process
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.of(context).pop();

      Fluttertoast.showToast(
        msg: "${format.toUpperCase()} फ़ाइल सफलतापूर्वक निर्यात की गई",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.getSuccessColor(
            Theme.of(context).brightness == Brightness.light),
        textColor: Colors.white,
      );
    }
  }
}
