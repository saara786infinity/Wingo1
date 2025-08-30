import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class NotificationSettingsModal extends StatefulWidget {
  final Map<String, bool> currentSettings;
  final Function(Map<String, bool>) onSettingsChanged;

  const NotificationSettingsModal({
    super.key,
    required this.currentSettings,
    required this.onSettingsChanged,
  });

  @override
  State<NotificationSettingsModal> createState() =>
      _NotificationSettingsModalState();
}

class _NotificationSettingsModalState extends State<NotificationSettingsModal> {
  late Map<String, bool> _settings;

  @override
  void initState() {
    super.initState();
    _settings = Map.from(widget.currentSettings);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'सूचना सेटिंग्स',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(4.w),
              children: [
                _buildSettingTile(
                  context,
                  'नए परिणाम',
                  'जब नया ड्रॉ परिणाम आए तो सूचना भेजें',
                  'newResults',
                  'notifications',
                ),
                _buildSettingTile(
                  context,
                  'जीत की सूचना',
                  'जब आपकी भविष्यवाणी सही हो तो सूचना भेजें',
                  'winNotifications',
                  'celebration',
                ),
                _buildSettingTile(
                  context,
                  'पैटर्न अलर्ट',
                  'जब नया पैटर्न मिले तो सूचना भेजें',
                  'patternAlerts',
                  'trending_up',
                ),
                _buildSettingTile(
                  context,
                  'AI सुझाव',
                  'AI की नई भविष्यवाणी सुझाव की सूचना',
                  'aiSuggestions',
                  'psychology',
                ),
                _buildSettingTile(
                  context,
                  'दैनिक रिपोर्ट',
                  'दिन के अंत में प्रदर्शन रिपोर्ट भेजें',
                  'dailyReport',
                  'assessment',
                ),
                _buildSettingTile(
                  context,
                  'कनेक्शन स्थिति',
                  'जब कनेक्शन टूटे या जुड़े तो सूचना दें',
                  'connectionStatus',
                  'wifi',
                ),
                SizedBox(height: 2.h),
                _buildSoundSettings(context),
                SizedBox(height: 2.h),
                _buildTimingSettings(context),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'रद्द करें',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      widget.onSettingsChanged(_settings);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'सेव करें',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    String subtitle,
    String key,
    String iconName,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
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
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        trailing: Switch(
          value: _settings[key] ?? false,
          onChanged: (value) {
            HapticFeedback.lightImpact();
            setState(() {
              _settings[key] = value;
            });
          },
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      ),
    );
  }

  Widget _buildSoundSettings(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
            children: [
              CustomIconWidget(
                iconName: 'volume_up',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'ध्वनि सेटिंग्स',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'सूचना ध्वनि',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              Switch(
                value: _settings['soundEnabled'] ?? true,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _settings['soundEnabled'] = value;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'वाइब्रेशन',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              Switch(
                value: _settings['vibrationEnabled'] ?? true,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _settings['vibrationEnabled'] = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimingSettings(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'समय सेटिंग्स',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'रात में सूचना (10 PM - 8 AM)',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              Switch(
                value: _settings['nightNotifications'] ?? false,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _settings['nightNotifications'] = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}