import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/widgets/custom_text_form_field.dart';

class CustomPasswordFormField extends StatefulWidget {
  const CustomPasswordFormField({
    super.key,
    this.onSaved,
    this.hintText = 'password_hint',
    this.validator,
    this.controller,
  });
  final void Function(String?)? onSaved;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  @override
  State<CustomPasswordFormField> createState() =>
      _CustomPasswordFormFieldState();
}

class _CustomPasswordFormFieldState extends State<CustomPasswordFormField> {
  bool isObscureText = true;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomTextFormField(
      validator:
          widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.fieldRequired.tr();
            } else {
              return null;
            }
          },
      controller: widget.controller,
      hintText: widget.hintText!.tr(),
      textInputType: TextInputType.visiblePassword,
      isObscureText: isObscureText,
      onSaved: widget.onSaved,
      suffixIcon: InkWell(
        onTap: () {
          setState(() {
            isObscureText = !isObscureText;
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 31, vertical: 16),
          child: Icon(
            isObscureText ? Icons.visibility_off : Icons.visibility,
            color: isObscureText ? theme.hintColor : theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
