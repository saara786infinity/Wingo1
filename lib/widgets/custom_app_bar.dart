import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomAppBarVariant {
  standard,
  gaming,
  minimal,
  withActions,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool enableHapticFeedback;

  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.enableHapticFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return AppBar(
      title: _buildTitle(context, isLight),
      centerTitle: centerTitle,
      leading: _buildLeading(context),
      actions: _buildActions(context),
      backgroundColor: backgroundColor ?? _getBackgroundColor(theme, isLight),
      foregroundColor: foregroundColor ?? _getForegroundColor(theme, isLight),
      elevation: elevation ?? _getElevation(),
      shadowColor: theme.shadowColor,
      systemOverlayStyle: _getSystemOverlayStyle(isLight),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildTitle(BuildContext context, bool isLight) {
    switch (variant) {
      case CustomAppBarVariant.gaming:
        return Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _getForegroundColor(Theme.of(context), isLight),
            letterSpacing: 0.5,
          ),
        );
      case CustomAppBarVariant.minimal:
        return Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: _getForegroundColor(Theme.of(context), isLight),
          ),
        );
      default:
        return Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _getForegroundColor(Theme.of(context), isLight),
          ),
        );
    }
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () {
          if (enableHapticFeedback) {
            HapticFeedback.lightImpact();
          }
          if (onBackPressed != null) {
            onBackPressed!();
          } else {
            Navigator.of(context).pop();
          }
        },
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions != null) return actions;

    switch (variant) {
      case CustomAppBarVariant.withActions:
        return [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, size: 24),
            onPressed: () {
              if (enableHapticFeedback) {
                HapticFeedback.lightImpact();
              }
              // Navigate to notifications or show notification panel
            },
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 24),
            onPressed: () {
              if (enableHapticFeedback) {
                HapticFeedback.lightImpact();
              }
              Navigator.pushNamed(context, '/settings');
            },
            tooltip: 'Settings',
          ),
          const SizedBox(width: 8),
        ];
      case CustomAppBarVariant.gaming:
        return [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, size: 24),
            onPressed: () {
              if (enableHapticFeedback) {
                HapticFeedback.lightImpact();
              }
              Navigator.pushNamed(context, '/ai-analytics-dashboard');
            },
            tooltip: 'Analytics',
          ),
          IconButton(
            icon: const Icon(Icons.history, size: 24),
            onPressed: () {
              if (enableHapticFeedback) {
                HapticFeedback.lightImpact();
              }
              Navigator.pushNamed(context, '/prediction-history');
            },
            tooltip: 'History',
          ),
          const SizedBox(width: 8),
        ];
      default:
        return null;
    }
  }

  Color _getBackgroundColor(ThemeData theme, bool isLight) {
    switch (variant) {
      case CustomAppBarVariant.minimal:
        return Colors.transparent;
      case CustomAppBarVariant.gaming:
        return theme.colorScheme.surface;
      default:
        return theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;
    }
  }

  Color _getForegroundColor(ThemeData theme, bool isLight) {
    return theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface;
  }

  double _getElevation() {
    switch (variant) {
      case CustomAppBarVariant.minimal:
        return 0.0;
      case CustomAppBarVariant.gaming:
        return 2.0;
      default:
        return 2.0;
    }
  }

  SystemUiOverlayStyle _getSystemOverlayStyle(bool isLight) {
    return isLight
        ? SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
