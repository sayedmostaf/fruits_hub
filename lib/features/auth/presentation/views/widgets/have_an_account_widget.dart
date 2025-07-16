import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class HaveAnAccountWidget extends StatelessWidget {
  const HaveAnAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: AppStrings.alreadyHaveAccount.tr(),
            style: AppTextStyle.textStyle16w600.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          TextSpan(
            text: AppStrings.login.tr(),
            style: AppTextStyle.textStyle16w600.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
            recognizer:
                TapGestureRecognizer()..onTap = () => Navigator.pop(context),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
