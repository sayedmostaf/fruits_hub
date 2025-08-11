import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

void buildSuccessSnackBar(BuildContext context, {required String message}) {
  final theme = Theme.of(context);

  Flushbar(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.all(20),
    borderRadius: BorderRadius.circular(12),
    backgroundColor: theme.colorScheme.primary,
    flushbarPosition: FlushbarPosition.TOP,
    icon: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_circle_rounded,
        color: Colors.white,
        size: 22,
      ),
    ),
    shouldIconPulse: false,
    duration: const Duration(seconds: 4),
    messageText: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.success.tr(),
          style: AppTextStyle.textStyle14w700.copyWith(
            color: Colors.white,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          message.tr(),
          style: AppTextStyle.textStyle14w400.copyWith(
            color: Colors.white.withOpacity(0.9),
            height: 1.4,
          ),
        ),
      ],
    ),
    mainButton: TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(40, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Icon(
        Icons.close_rounded,
        color: Colors.white.withOpacity(0.8),
        size: 20,
      ),
      onPressed: () {},
    ),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 16,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
    ],
    animationDuration: const Duration(milliseconds: 600),
    forwardAnimationCurve: Curves.fastEaseInToSlowEaseOut,
    reverseAnimationCurve: Curves.fastOutSlowIn,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    isDismissible: true,
    showProgressIndicator: true,
    progressIndicatorBackgroundColor: Colors.white.withOpacity(0.2),
    progressIndicatorValueColor: AlwaysStoppedAnimation<Color>(
      Colors.white.withOpacity(0.6),
    ),
  ).show(context);
}
