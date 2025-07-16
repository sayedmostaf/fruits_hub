import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/auth/presentation/views/widgets/custom_check_box.dart';

class TermsAndConditionsWidget extends StatefulWidget {
  const TermsAndConditionsWidget({super.key, required this.onChange});
  final ValueChanged<bool> onChange;
  @override
  State<TermsAndConditionsWidget> createState() =>
      _TermsAndConditionsWidgetState();
}

class _TermsAndConditionsWidgetState extends State<TermsAndConditionsWidget> {
  bool isTermsChecked = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCheckBox(
          onChange: (currentState) {
            setState(() {
              isTermsChecked = currentState;
              widget.onChange(currentState);
            });
          },
          isChecked: isTermsChecked,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: AppStrings.termsPrefix.tr(),
                  style: AppTextStyle.textStyle13w600.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                TextSpan(
                  text: AppStrings.termsConditions.tr(),
                  style: AppTextStyle.textStyle13w600.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                TextSpan(
                  text: AppStrings.termsOf.tr(),
                  style: AppTextStyle.textStyle13w600.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                TextSpan(
                  text: AppStrings.termsUs.tr(),
                  style: AppTextStyle.textStyle13w600.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
