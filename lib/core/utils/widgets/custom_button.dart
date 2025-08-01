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
  });
  final VoidCallback onPressed;
  final String? text;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child:
            child ??
            Text(
              text?.tr() ?? AppStrings.next.tr(),
              style: AppTextStyle.textStyle16w700.copyWith(
                color: isDark ? Colors.white : theme.colorScheme.onPrimary,
              ),
            ),
      ),
    );
  }
}
