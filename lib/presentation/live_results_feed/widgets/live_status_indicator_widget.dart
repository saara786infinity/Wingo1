import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

enum ConnectionStatus { connected, connecting, disconnected }

class LiveStatusIndicatorWidget extends StatefulWidget {
  final ConnectionStatus status;
  final DateTime? lastUpdate;
  final VoidCallback? onRetry;

  const LiveStatusIndicatorWidget({
    super.key,
    required this.status,
    this.lastUpdate,
    this.onRetry,
  });

  @override
  State<LiveStatusIndicatorWidget> createState() =>
      _LiveStatusIndicatorWidgetState();
}

class _LiveStatusIndicatorWidgetState extends State<LiveStatusIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.status == ConnectionStatus.connected) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(LiveStatusIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status == ConnectionStatus.connected &&
        oldWidget.status != ConnectionStatus.connected) {
      _pulseController.repeat(reverse: true);
    } else if (widget.status != ConnectionStatus.connected) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(theme, isLight).withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatusIndicator(theme, isLight),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusText(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(theme, isLight),
                  ),
                ),
                if (widget.lastUpdate != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    'अंतिम अपडेट: ${_formatLastUpdate(widget.lastUpdate!)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (widget.status == ConnectionStatus.disconnected &&
              widget.onRetry != null)
            _buildRetryButton(theme, isLight),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(ThemeData theme, bool isLight) {
    final statusColor = _getStatusColor(theme, isLight);

    switch (widget.status) {
      case ConnectionStatus.connected:
        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.4),
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      case ConnectionStatus.connecting:
        return SizedBox(
          width: 4.w,
          height: 4.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
          ),
        );
      case ConnectionStatus.disconnected:
        return Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: 'close',
            size: 12,
            color: Colors.white,
          ),
        );
    }
  }

  Widget _buildRetryButton(ThemeData theme, bool isLight) {
    return GestureDetector(
      onTap: widget.onRetry,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.primary,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'refresh',
              size: 16,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: 1.w),
            Text(
              'पुनः कनेक्ट',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(ThemeData theme, bool isLight) {
    switch (widget.status) {
      case ConnectionStatus.connected:
        return isLight ? const Color(0xFF059669) : const Color(0xFF34D399);
      case ConnectionStatus.connecting:
        return isLight ? const Color(0xFFF59E0B) : const Color(0xFFFBBF24);
      case ConnectionStatus.disconnected:
        return isLight ? const Color(0xFFDC2626) : const Color(0xFFF87171);
    }
  }

  String _getStatusText() {
    switch (widget.status) {
      case ConnectionStatus.connected:
        return 'लाइव कनेक्टेड';
      case ConnectionStatus.connecting:
        return 'कनेक्ट हो रहा है...';
      case ConnectionStatus.disconnected:
        return 'कनेक्शन टूटा';
    }
  }

  String _formatLastUpdate(DateTime lastUpdate) {
    final now = DateTime.now();
    final difference = now.difference(lastUpdate);

    if (difference.inSeconds < 30) {
      return 'अभी';
    } else if (difference.inMinutes < 1) {
      return '${difference.inSeconds} सेकंड पहले';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} मिनट पहले';
    } else {
      return '${lastUpdate.hour}:${lastUpdate.minute.toString().padLeft(2, '0')}';
    }
  }
}
