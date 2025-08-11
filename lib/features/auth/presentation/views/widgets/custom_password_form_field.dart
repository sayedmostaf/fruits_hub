import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/widgets/custom_text_form_field.dart';

class CustomPasswordFormField extends StatefulWidget {
  const CustomPasswordFormField({
    super.key,
    this.onSaved,
    this.hintText = AppStrings.passwordHint,
    this.validator,
    this.controller,
    this.onChanged,
    this.prefixIcon,
    this.contentPadding,
  });
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? prefixIcon;

  @override
  State<CustomPasswordFormField> createState() =>
      _CustomPasswordFormFieldState();
}

class _CustomPasswordFormFieldState extends State<CustomPasswordFormField> {
  bool isObscureText = true;
  bool hasText = false;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired.tr();
    }
    if (value.length < 8) {
      return AppStrings.passwordTooShort.tr();
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return AppStrings.passwordNeedsUppercase.tr();
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return AppStrings.passwordNeedsNumber.tr();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomTextFormField(
      prefixIcon: widget.prefixIcon,
      validator: widget.validator ?? _validatePassword,
      controller: widget.controller,
      hintText: widget.hintText!.tr(),
      textInputType: TextInputType.visiblePassword,
      isObscureText: isObscureText,
      onSaved: widget.onSaved,
      onChanged: (value) {
        setState(() => hasText = value.isNotEmpty);
        widget.onChanged?.call(value);
      },
      contentPadding: widget.contentPadding,
      suffixIcon:
          hasText
              ? IconButton(
                icon: Icon(
                  isObscureText ? Icons.visibility_off : Icons.visibility,
                  color:
                      isObscureText
                          ? theme.hintColor
                          : theme.colorScheme.primary,
                  size: 20,
                ),
                onPressed: () {
                  setState(() => isObscureText = !isObscureText);
                },
                padding: EdgeInsets.zero,
                splashRadius: 20,
              )
              : null,
    );
  }
}
