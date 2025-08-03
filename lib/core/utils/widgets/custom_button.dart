import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    this.text,
    this.child,
    this.elevation = 0,
    this.animationDuration = const Duration(milliseconds: 200),
  });
  final VoidCallback onPressed;
  final String? text;
  final Widget? child;
  final double elevation;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: animationDuration,
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (elevation > 0)
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: elevation * 4,
              spreadRadius: elevation * 0.5,
              offset: Offset(0, elevation * 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.9),
                ],
              ),
            ),
            alignment: Alignment.center,
            child:
                child ??
                Text(
                  text?.tr() ?? AppStrings.next.tr(),
                  style: AppTextStyle.textStyle16w700.copyWith(
                    color: isDark ? Colors.white : theme.colorScheme.onPrimary,
                    shadows: [
                      if (elevation > 0)
                        Shadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
