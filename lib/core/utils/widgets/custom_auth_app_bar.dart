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
    scrolledUnderElevation: 2,
    shadowColor: Theme.of(context).shadowColor.withOpacity(0.1),
    leading:
        goBack
            ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            )
            : null,
    title: Text(
      title,
      style: AppTextStyle.textStyle19w700.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    ),
  );
}
