import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class CustomSettingItem extends StatefulWidget {
  const CustomSettingItem({
    super.key,
    required this.title,
    required this.image,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconSize = 24.0,
    this.iconColor,
    this.textStyle,
    this.subtitleStyle,
    this.backgroundColor,
    this.showDivider = false,
    this.showShadow = true,
    this.isEnabled = true,
    this.badge,
    this.badgeColor,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    this.margin = const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    this.borderRadius = 16.0,
    this.elevation = 0.0,
  });

  final String title, image;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final double iconSize;
  final Color? iconColor;
  final TextStyle? textStyle;
  final TextStyle? subtitleStyle;
  final Color? backgroundColor;
  final bool showDivider;
  final bool showShadow;
  final bool isEnabled;
  final String? badge;
  final Color? badgeColor;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;
  final double elevation;

  @override
  State<CustomSettingItem> createState() => _CustomSettingItemState();
}

class _CustomSettingItemState extends State<CustomSettingItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconRotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isEnabled) {
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isEnabled) {
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.isEnabled) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final effectiveBackgroundColor =
        widget.backgroundColor ??
        (isDarkMode
            ? theme.colorScheme.surface.withOpacity(0.8)
            : theme.colorScheme.surface);

    return Padding(
      padding: widget.margin,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Material(
                  color: Colors.transparent,
                  elevation: widget.elevation,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Container(
                    decoration: BoxDecoration(
                      color: effectiveBackgroundColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.08),
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: widget.isEnabled ? widget.onTap : null,
                      onTapDown: _handleTapDown,
                      onTapUp: _handleTapUp,
                      onTapCancel: _handleTapCancel,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      splashColor: theme.colorScheme.primary.withOpacity(0.08),
                      highlightColor: theme.colorScheme.primary.withOpacity(
                        0.04,
                      ),
                      child: Semantics(
                        button: true,
                        enabled: widget.isEnabled,
                        label: widget.title.tr(),
                        hint: widget.subtitle?.tr(),
                        child: AnimatedOpacity(
                          opacity: widget.isEnabled ? 1.0 : 0.6,
                          duration: const Duration(milliseconds: 200),
                          child: Padding(
                            padding: widget.padding,
                            child: Row(
                              children: [
                                // Icon container with background
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: (widget.iconColor ??
                                            theme.colorScheme.primary)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SvgPicture.asset(
                                    widget.image,
                                    color:
                                        widget.iconColor ??
                                        theme.colorScheme.primary,
                                    width: widget.iconSize,
                                    height: widget.iconSize,
                                    semanticsLabel: widget.title.tr(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              widget.title.tr(),
                                              style:
                                                  widget.textStyle ??
                                                  AppTextStyle.textStyle13w600
                                                      .copyWith(
                                                        color:
                                                            theme
                                                                .colorScheme
                                                                .onSurface,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          // Badge
                                          if (widget.badge != null) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    widget.badgeColor ??
                                                    theme.colorScheme.primary,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                widget.badge!,
                                                style: TextStyle(
                                                  color:
                                                      theme
                                                          .colorScheme
                                                          .onPrimary,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      if (widget.subtitle != null) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          widget.subtitle!.tr(),
                                          style:
                                              widget.subtitleStyle ??
                                              TextStyle(
                                                color:
                                                    theme
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Trailing
                                AnimatedBuilder(
                                  animation: _iconRotationAnimation,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: _iconRotationAnimation.value,
                                      child:
                                          widget.trailing ??
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 18,
                                            color: theme.colorScheme.outline,
                                          ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Divider
          if (widget.showDivider)
            Container(
              margin: const EdgeInsets.only(left: 72, top: 8),
              height: 1,
              color: theme.colorScheme.outline.withOpacity(0.12),
            ),
        ],
      ),
    );
  }
}

// Extension for easy usage with different variations
extension CustomSettingItemVariants on CustomSettingItem {
  static CustomSettingItem card({
    required String title,
    required String image,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    String? badge,
    Color? badgeColor,
    bool isEnabled = true,
  }) {
    return CustomSettingItem(
      title: title,
      image: image,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      badge: badge,
      badgeColor: badgeColor,
      isEnabled: isEnabled,
      showShadow: true,
      borderRadius: 16,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  static CustomSettingItem minimal({
    required String title,
    required String image,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isEnabled = true,
  }) {
    return CustomSettingItem(
      title: title,
      image: image,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      isEnabled: isEnabled,
      showShadow: false,
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}

// Usage examples:
/*
// Card style with badge
CustomSettingItemVariants.card(
  title: "Notifications",
  image: "assets/icons/notification.svg",
  subtitle: "Manage your notification preferences",
  badge: "NEW",
  badgeColor: Colors.green,
  onTap: () => Navigator.push(...),
)

// Minimal style
CustomSettingItemVariants.minimal(
  title: "Privacy",
  image: "assets/icons/privacy.svg",
  subtitle: "Control your privacy settings",
  onTap: () => Navigator.push(...),
)

// Custom trailing widget
CustomSettingItem(
  title: "Dark Mode",
  image: "assets/icons/theme.svg",
  trailing: Switch(
    value: isDarkMode,
    onChanged: (value) => toggleTheme(),
  ),
)

// Disabled state
CustomSettingItem(
  title: "Premium Feature",
  image: "assets/icons/premium.svg",
  subtitle: "Upgrade to unlock this feature",
  isEnabled: false,
  badge: "PRO",
  badgeColor: Colors.amber,
)
*/
