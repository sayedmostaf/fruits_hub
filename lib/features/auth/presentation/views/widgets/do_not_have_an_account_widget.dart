import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/constants.dart';

class DoNotHaveAnAccountWidget extends StatelessWidget {
  const DoNotHaveAnAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Color baseTextColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
    final Color linkColor = Theme.of(context).colorScheme.primary;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: AppStrings.doNotHaveAccount.tr(),
            style: TextStyle(
              color: baseTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, Constants.signUpViewRoute);
                  },
            text: AppStrings.createAccountNow.tr(),
            style: TextStyle(
              color: linkColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
