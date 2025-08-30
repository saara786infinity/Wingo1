import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomTabBarVariant {
  standard,
  gaming,
  minimal,
  pills,
  underlined,
}

class CustomTabBar extends StatefulWidget {
  final List<String> tabs;
  final CustomTabBarVariant variant;
  final int initialIndex;
  final ValueChanged<int>? onTap;
  final bool enableHapticFeedback;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final EdgeInsetsGeometry? padding;
  final bool isScrollable;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.variant = CustomTabBarVariant.standard,
    this.initialIndex = 0,
    this.onTap,
    this.enableHapticFeedback = true,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
    this.indicatorColor,
    this.padding,
    this.isScrollable = false,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    if (widget.onTap != null) {
      widget.onTap!(_tabController.index);
    }

    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    switch (widget.variant) {
      case CustomTabBarVariant.gaming:
        return _buildGamingTabBar(context, theme, isLight);
      case CustomTabBarVariant.minimal:
        return _buildMinimalTabBar(context, theme, isLight);
      case CustomTabBarVariant.pills:
        return _buildPillsTabBar(context, theme, isLight);
      case CustomTabBarVariant.underlined:
        return _buildUnderlinedTabBar(context, theme, isLight);
      default:
        return _buildStandardTabBar(context, theme, isLight);
    }
  }

  Widget _buildStandardTabBar(
      BuildContext context, ThemeData theme, bool isLight) {
    return Container(
      color: widget.backgroundColor ?? theme.colorScheme.surface,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        labelColor: widget.selectedColor ?? theme.colorScheme.primary,
        unselectedLabelColor: widget.unselectedColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: widget.indicatorColor ?? theme.colorScheme.primary,
        indicatorWeight: 2.0,
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        tabs: widget.tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildGamingTabBar(
      BuildContext context, ThemeData theme, bool isLight) {
    return Container(
      height: 56,
      margin: widget.padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.colorScheme.surface,
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
        controller: _tabController,
        isScrollable: widget.isScrollable,
        labelColor: widget.selectedColor ?? theme.colorScheme.primary,
        unselectedLabelColor: widget.unselectedColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.6),
        indicator: BoxDecoration(
          color: (widget.indicatorColor ?? theme.colorScheme.primary)
              .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorPadding: const EdgeInsets.all(4),
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        dividerColor: Colors.transparent,
        tabs: widget.tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildMinimalTabBar(
      BuildContext context, ThemeData theme, bool isLight) {
    return Container(
      height: 48,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        labelColor: widget.selectedColor ?? theme.colorScheme.primary,
        unselectedLabelColor: widget.unselectedColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.6),
        indicator: const BoxDecoration(),
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        dividerColor: Colors.transparent,
        tabs: widget.tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildPillsTabBar(
      BuildContext context, ThemeData theme, bool isLight) {
    return Container(
      height: 48,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == _tabController.index;

          return _buildPillTab(context, theme, tab, isSelected, () {
            _tabController.animateTo(index);
          });
        }).toList(),
      ),
    );
  }

  Widget _buildPillTab(
    BuildContext context,
    ThemeData theme,
    String text,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final selectedColor = widget.selectedColor ?? theme.colorScheme.primary;
    final unselectedColor = widget.unselectedColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? Border.all(color: selectedColor, width: 1.5)
              : Border.all(color: Colors.transparent),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? selectedColor : unselectedColor,
          ),
        ),
      ),
    );
  }

  Widget _buildUnderlinedTabBar(
      BuildContext context, ThemeData theme, bool isLight) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
      ),
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        labelColor: widget.selectedColor ?? theme.colorScheme.primary,
        unselectedLabelColor: widget.unselectedColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: widget.indicatorColor ?? theme.colorScheme.primary,
        indicatorWeight: 3.0,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        dividerColor: Colors.transparent,
        tabs: widget.tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }
}

/// Gaming-specific tab bar for prediction modes
class CustomGamingTabBar extends StatefulWidget {
  final ValueChanged<int>? onTap;
  final int initialIndex;
  final bool enableHapticFeedback;

  const CustomGamingTabBar({
    super.key,
    this.onTap,
    this.initialIndex = 0,
    this.enableHapticFeedback = true,
  });

  @override
  State<CustomGamingTabBar> createState() => _CustomGamingTabBarState();
}

class _CustomGamingTabBarState extends State<CustomGamingTabBar> {
  final List<_GamingTab> _gamingTabs = [
    _GamingTab(
      title: 'Quick',
      subtitle: '1min',
      icon: Icons.flash_on,
      route: '/prediction-dashboard',
    ),
    _GamingTab(
      title: 'Standard',
      subtitle: '5min',
      icon: Icons.timer,
      route: '/prediction-dashboard',
    ),
    _GamingTab(
      title: 'Extended',
      subtitle: '15min',
      icon: Icons.schedule,
      route: '/prediction-dashboard',
    ),
  ];

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      height: 80,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: _gamingTabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == _selectedIndex;

          return Expanded(
            child: _buildGamingTab(context, theme, tab, isSelected, () {
              setState(() {
                _selectedIndex = index;
              });

              if (widget.enableHapticFeedback) {
                HapticFeedback.lightImpact();
              }

              if (widget.onTap != null) {
                widget.onTap!(index);
              }

              Navigator.pushNamed(context, tab.route);
            }),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGamingTab(
    BuildContext context,
    ThemeData theme,
    _GamingTab tab,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border:
              isSelected ? Border.all(color: selectedColor, width: 2.0) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tab.icon,
              size: 24,
              color: isSelected ? selectedColor : unselectedColor,
            ),
            const SizedBox(height: 4),
            Text(
              tab.title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
            Text(
              tab.subtitle,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GamingTab {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  const _GamingTab({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });
}
