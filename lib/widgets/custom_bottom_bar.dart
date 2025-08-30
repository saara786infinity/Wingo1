import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomBottomBarVariant {
  standard,
  gaming,
  minimal,
  floating,
}

class CustomBottomBar extends StatefulWidget {
  final CustomBottomBarVariant variant;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final bool enableHapticFeedback;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const CustomBottomBar({
    super.key,
    this.variant = CustomBottomBarVariant.standard,
    this.currentIndex = 0,
    this.onTap,
    this.enableHapticFeedback = true,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<_BottomBarItem> _items = [
    _BottomBarItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/prediction-dashboard',
    ),
    _BottomBarItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      label: 'Analytics',
      route: '/ai-analytics-dashboard',
    ),
    _BottomBarItem(
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      label: 'History',
      route: '/prediction-history',
    ),
    _BottomBarItem(
      icon: Icons.live_tv_outlined,
      activeIcon: Icons.live_tv,
      label: 'Live',
      route: '/live-results-feed',
    ),
    _BottomBarItem(
      icon: Icons.pattern_outlined,
      activeIcon: Icons.pattern,
      label: 'Patterns',
      route: '/pattern-analysis',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    switch (widget.variant) {
      case CustomBottomBarVariant.floating:
        return _buildFloatingBottomBar(context, theme, isLight);
      case CustomBottomBarVariant.minimal:
        return _buildMinimalBottomBar(context, theme, isLight);
      case CustomBottomBarVariant.gaming:
        return _buildGamingBottomBar(context, theme, isLight);
      default:
        return _buildStandardBottomBar(context, theme, isLight);
    }
  }

  Widget _buildStandardBottomBar(
      BuildContext context, ThemeData theme, bool isLight) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: _handleTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: widget.backgroundColor ??
          theme.bottomNavigationBarTheme.backgroundColor,
      selectedItemColor: widget.selectedItemColor ?? theme.colorScheme.primary,
      unselectedItemColor: widget.unselectedItemColor ??
          theme.colorScheme.onSurface.withValues(alpha: 0.6),
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      elevation: 8.0,
      items: _items
          .map((item) => BottomNavigationBarItem(
                icon: Icon(item.icon, size: 24),
                activeIcon: Icon(item.activeIcon, size: 24),
                label: item.label,
              ))
          .toList(),
    );
  }

  Widget _buildGamingBottomBar(
      BuildContext context, ThemeData theme, bool isLight) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == widget.currentIndex;

              return _buildGamingBottomBarItem(
                context,
                theme,
                item,
                isSelected,
                () => _handleTap(index),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildGamingBottomBarItem(
    BuildContext context,
    ThemeData theme,
    _BottomBarItem item,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final selectedColor = widget.selectedItemColor ?? theme.colorScheme.primary;
    final unselectedColor = widget.unselectedItemColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              size: 24,
              color: isSelected ? selectedColor : unselectedColor,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBar(
      BuildContext context, ThemeData theme, bool isLight) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: widget.backgroundColor ??
            theme.colorScheme.surface.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == widget.currentIndex;

            return _buildMinimalBottomBarItem(
              context,
              theme,
              item,
              isSelected,
              () => _handleTap(index),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBarItem(
    BuildContext context,
    ThemeData theme,
    _BottomBarItem item,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final selectedColor = widget.selectedItemColor ?? theme.colorScheme.primary;
    final unselectedColor = widget.unselectedItemColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Icon(
          isSelected ? item.activeIcon : item.icon,
          size: 26,
          color: isSelected ? selectedColor : unselectedColor,
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBar(
      BuildContext context, ThemeData theme, bool isLight) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.15),
                blurRadius: 12.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == widget.currentIndex;

                return _buildFloatingBottomBarItem(
                  context,
                  theme,
                  item,
                  isSelected,
                  () => _handleTap(index),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBarItem(
    BuildContext context,
    ThemeData theme,
    _BottomBarItem item,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final selectedColor = widget.selectedItemColor ?? theme.colorScheme.primary;
    final unselectedColor = widget.unselectedItemColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? selectedColor.withValues(alpha: 0.15)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isSelected ? item.activeIcon : item.icon,
            size: 24,
            color: isSelected ? selectedColor : unselectedColor,
          ),
        ),
      ),
    );
  }

  void _handleTap(int index) {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    if (widget.onTap != null) {
      widget.onTap!(index);
    }

    // Navigate to the corresponding route
    if (index < _items.length) {
      Navigator.pushNamed(context, _items[index].route);
    }

    // Trigger animation for visual feedback
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }
}

class _BottomBarItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const _BottomBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
