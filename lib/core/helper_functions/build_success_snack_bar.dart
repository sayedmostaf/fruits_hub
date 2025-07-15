import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

void buildSuccessSnackBar(BuildContext context, {required String message}) {
  Flushbar(
    margin: EdgeInsets.all(16),
    borderRadius: BorderRadius.circular(12),
    backgroundColor: Theme.of(context).colorScheme.primary,
    flushbarPosition: FlushbarPosition.TOP,
    icon: Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
    duration: Duration(seconds: 2),
    messageText: Text(
      message.tr(),
      textAlign: TextAlign.start,
      style: AppTextStyle.textStyle13w600.copyWith(color: Colors.white),
    ),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ],
    animationDuration: Duration(milliseconds: 400),
  ).show(context);
}
