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
  });
  final String hintText;
  final Widget? prefixIcon, suffixIcon;
  final TextInputType textInputType;
  final void Function(String?)? onSaved;
  final bool isObscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? contentPadding;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
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
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintStyle: AppTextStyle.textStyle13w400.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: buildBorder(theme),
        enabledBorder: buildBorder(theme),
        focusedBorder: buildBorder(theme),
        errorBorder: buildErrorBorder(theme),
        focusedErrorBorder: buildErrorBorder(theme),
        contentPadding: contentPadding ?? EdgeInsets.all(12),
      ),
    );
  }

  OutlineInputBorder buildBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: theme.colorScheme.outline, width: 1),
    );
  }

  OutlineInputBorder buildErrorBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
    );
  }
}
