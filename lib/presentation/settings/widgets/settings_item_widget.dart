import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

enum SettingsItemType {
  navigation,
  toggle,
  slider,
  info,
}

class SettingsItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? iconName;
  final SettingsItemType type;
  final VoidCallback? onTap;
  final bool? toggleValue;
  final ValueChanged<bool>? onToggleChanged;
  final double? sliderValue;
  final ValueChanged<double>? onSliderChanged;
  final double? sliderMin;
  final double? sliderMax;
  final String? trailingText;
  final bool isLast;
  final bool showHelpIcon;

  const SettingsItemWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.iconName,
    this.type = SettingsItemType.navigation,
    this.onTap,
    this.toggleValue,
    this.onToggleChanged,
    this.sliderValue,
    this.onSliderChanged,
    this.sliderMin,
    this.sliderMax,
    this.trailingText,
    this.isLast = false,
    this.showHelpIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return GestureDetector(
      onTap: type == SettingsItemType.navigation
          ? () {
              HapticFeedback.lightImpact();
              onTap?.call();
            }
          : null,
      onLongPress: showHelpIcon
          ? () {
              HapticFeedback.mediumImpact();
              _showHelpTooltip(context);
            }
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: !isLast
              ? Border(
                  bottom: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            if (iconName != null) ...[
              CustomIconWidget(
                iconName: iconName!,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (showHelpIcon) ...[
                        SizedBox(width: 2.w),
                        CustomIconWidget(
                          iconName: 'help_outline',
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                  if (type == SettingsItemType.slider &&
                      sliderValue != null) ...[
                    SizedBox(height: 1.h),
                    _buildSlider(context, theme),
                  ],
                ],
              ),
            ),
            SizedBox(width: 3.w),
            _buildTrailing(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailing(BuildContext context, ThemeData theme) {
    switch (type) {
      case SettingsItemType.toggle:
        return Switch(
          value: toggleValue ?? false,
          onChanged: (value) {
            HapticFeedback.lightImpact();
            onToggleChanged?.call(value);
          },
        );
      case SettingsItemType.info:
        return trailingText != null
            ? Text(
                trailingText!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              )
            : const SizedBox.shrink();
      case SettingsItemType.slider:
        return Text(
          sliderValue?.toStringAsFixed(1) ?? '0.0',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        );
      default:
        return CustomIconWidget(
          iconName: 'chevron_right',
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          size: 20,
        );
    }
  }

  Widget _buildSlider(BuildContext context, ThemeData theme) {
    return SliderTheme(
      data: theme.sliderTheme.copyWith(
        trackHeight: 4.0,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
      ),
      child: Slider(
        value: sliderValue ?? 0.0,
        min: sliderMin ?? 0.0,
        max: sliderMax ?? 1.0,
        divisions: 10,
        onChanged: (value) {
          HapticFeedback.selectionClick();
          onSliderChanged?.call(value);
        },
      ),
    );
  }

  void _showHelpTooltip(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(
          subtitle ?? 'यह सेटिंग आपके ऐप के व्यवहार को नियंत्रित करती है।',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('समझ गया'),
          ),
        ],
      ),
    );
  }
}
