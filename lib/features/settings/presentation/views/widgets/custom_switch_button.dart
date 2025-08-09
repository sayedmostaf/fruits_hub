import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fruits_hub/features/settings/presentation/views/widgets/custom_setting_item.dart';

class CustomSwitchButton extends StatefulWidget {
  const CustomSwitchButton({
    super.key,
    required this.title,
    required this.svgIcon,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.activeColor,
    this.inactiveColor,
    this.activeText,
    this.inactiveText,
    this.showLabels = false,
    this.isEnabled = true,
    this.hapticFeedback = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.switchSize = SwitchSize.medium,
    this.customSwitchBuilder,
  });

  final String title, svgIcon;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor, inactiveColor;
  final String? activeText, inactiveText;
  final bool showLabels;
  final bool isEnabled;
  final bool hapticFeedback;
  final Duration animationDuration;
  final SwitchSize switchSize;
  final Widget Function(bool value, VoidCallback onTap)? customSwitchBuilder;

  @override
  State<CustomSwitchButton> createState() => _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleToggle(bool newValue) {
    if (!widget.isEnabled) return;

    // Haptic feedback
    if (widget.hapticFeedback) {
      HapticFeedback.lightImpact();
    }

    // Scale animation
    _controller.forward().then((_) {
      _controller.reverse();
    });

    widget.onChanged(newValue);
  }

  Widget _buildSwitch(ThemeData theme) {
    if (widget.customSwitchBuilder != null) {
      return widget.customSwitchBuilder!(
        widget.value,
        () => _handleToggle(!widget.value),
      );
    }

    final switchConfig = _getSwitchConfig();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FlutterSwitch(
            width: switchConfig.width,
            height: switchConfig.height,
            toggleSize: switchConfig.toggleSize,
            borderRadius: switchConfig.borderRadius,
            padding: switchConfig.padding,
            value: widget.value,
            disabled: !widget.isEnabled,
            onToggle: _handleToggle,
            duration: widget.animationDuration,
            activeColor: widget.activeColor ?? theme.colorScheme.primary,
            inactiveColor:
                widget.inactiveColor ??
                theme.colorScheme.outline.withOpacity(0.3),
            activeToggleColor: theme.colorScheme.onPrimary,
            inactiveToggleColor: theme.colorScheme.surface,
            activeSwitchBorder: Border.all(
              color: widget.activeColor ?? theme.colorScheme.primary,
              width: 1,
            ),
            inactiveSwitchBorder: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
            activeToggleBorder: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.1),
              width: 0.5,
            ),
            inactiveToggleBorder: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 0.5,
            ),
            // Text labels if enabled
            showOnOff: widget.showLabels,
            activeText: widget.activeText ?? "ON",
            inactiveText: widget.inactiveText ?? "OFF",
            activeTextColor: theme.colorScheme.onPrimary,
            inactiveTextColor: theme.colorScheme.onSurface,
            activeTextFontWeight: FontWeight.w600,
            inactiveTextFontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }

  SwitchConfig _getSwitchConfig() {
    switch (widget.switchSize) {
      case SwitchSize.small:
        return SwitchConfig(
          width: 36,
          height: 20,
          toggleSize: 16,
          borderRadius: 20,
          padding: 2,
        );
      case SwitchSize.medium:
        return SwitchConfig(
          width: 44,
          height: 24,
          toggleSize: 20,
          borderRadius: 24,
          padding: 2,
        );
      case SwitchSize.large:
        return SwitchConfig(
          width: 52,
          height: 28,
          toggleSize: 24,
          borderRadius: 28,
          padding: 2,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomSettingItem(
      title: widget.title,
      image: widget.svgIcon,
      subtitle: widget.subtitle,
      onTap: widget.isEnabled ? () => _handleToggle(!widget.value) : null,
      isEnabled: widget.isEnabled,
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildSwitch(theme),
          if (widget.showLabels && widget.customSwitchBuilder != null) ...[
            const SizedBox(height: 4),
            AnimatedSwitcher(
              duration: widget.animationDuration,
              child: Text(
                widget.value
                    ? (widget.activeText ?? "Enabled")
                    : (widget.inactiveText ?? "Disabled"),
                key: ValueKey(widget.value),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color:
                      widget.value
                          ? (widget.activeColor ?? theme.colorScheme.primary)
                          : theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Configuration classes
enum SwitchSize { small, medium, large }

class SwitchConfig {
  final double width;
  final double height;
  final double toggleSize;
  final double borderRadius;
  final double padding;

  const SwitchConfig({
    required this.width,
    required this.height,
    required this.toggleSize,
    required this.borderRadius,
    required this.padding,
  });
}

// Custom switch variants for different use cases
class MaterialSwitch extends StatelessWidget {
  const MaterialSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.isEnabled = true,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Switch.adaptive(
      value: value,
      onChanged: isEnabled ? onChanged : null,
      activeColor: activeColor ?? theme.colorScheme.primary,
      inactiveTrackColor:
          inactiveColor ?? theme.colorScheme.outline.withOpacity(0.3),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class CupertinoStyleSwitch extends StatelessWidget {
  const CupertinoStyleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.isEnabled = true,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Transform.scale(
      scale: 0.8,
      child: Switch.adaptive(
        value: value,
        onChanged: isEnabled ? onChanged : null,
        activeColor: activeColor ?? theme.colorScheme.primary,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

// Usage Examples and Extensions
extension CustomSwitchButtonVariants on CustomSwitchButton {
  static CustomSwitchButton notification({
    required String title,
    required String svgIcon,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
  }) {
    return CustomSwitchButton(
      title: title,
      svgIcon: svgIcon,
      value: value,
      onChanged: onChanged,
      subtitle: subtitle,
      switchSize: SwitchSize.medium,
      showLabels: false,
      hapticFeedback: true,
    );
  }

  static CustomSwitchButton withLabels({
    required String title,
    required String svgIcon,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
    String? activeText,
    String? inactiveText,
  }) {
    return CustomSwitchButton(
      title: title,
      svgIcon: svgIcon,
      value: value,
      onChanged: onChanged,
      subtitle: subtitle,
      showLabels: true,
      activeText: activeText,
      inactiveText: inactiveText,
      switchSize: SwitchSize.large,
    );
  }

  static CustomSwitchButton material({
    required String title,
    required String svgIcon,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
    Color? activeColor,
  }) {
    return CustomSwitchButton(
      title: title,
      svgIcon: svgIcon,
      value: value,
      onChanged: onChanged,
      subtitle: subtitle,
      activeColor: activeColor,
      customSwitchBuilder:
          (value, onTap) => GestureDetector(
            onTap: onTap,
            child: MaterialSwitch(
              value: value,
              onChanged: (_) => onTap(),
              activeColor: activeColor,
            ),
          ),
    );
  }
}