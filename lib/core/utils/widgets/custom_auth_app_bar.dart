import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

AppBar buildAppBar(
  BuildContext context, {
  required String title,
  bool goBack = true,
}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    elevation: 0,
    leading:
        goBack
            ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            )
            : null,
    title: Text(
      title,
      style: AppTextStyle.textStyle19w700.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    ),
  );
}
