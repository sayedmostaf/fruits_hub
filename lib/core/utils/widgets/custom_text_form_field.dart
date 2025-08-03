import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    required this.textInputType,
    this.onSaved,
    this.isObscureText = false,
    this.controller,
    this.validator,
    this.contentPadding,
    this.borderRadius = 12,
    this.elevation = 0,
  });
  final String hintText;
  final Widget? prefixIcon, suffixIcon;
  final TextInputType textInputType;
  final void Function(String?)? onSaved;
  final bool isObscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      shadowColor: theme.shadowColor,
      child: TextFormField(
        obscureText: isObscureText,
        keyboardType: textInputType,
        controller: controller,
        onSaved: onSaved,
        validator: validator,
        style: AppTextStyle.textStyle13w400.copyWith(
          color: theme.colorScheme.onBackground,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon:
              suffixIcon != null
                  ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: suffixIcon,
                  )
                  : null,
          prefixIcon:
              prefixIcon != null
                  ? Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: prefixIcon,
                  )
                  : null,
          hintStyle: AppTextStyle.textStyle13w400.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
          contentPadding:
              contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: buildBorder(theme),
          enabledBorder: buildBorder(theme),
          focusedBorder: buildFocusedBorder(theme),
          errorBorder: buildErrorBorder(theme),
          focusedErrorBorder: buildErrorBorder(theme),
        ),
      ),
    );
  }

  OutlineInputBorder buildBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: theme.colorScheme.outline.withOpacity(0.3),
        width: 1,
      ),
    );
  }

  OutlineInputBorder buildFocusedBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
    );
  }

  OutlineInputBorder buildErrorBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
    );
  }
}
