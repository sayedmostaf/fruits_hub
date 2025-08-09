import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/widgets/notification_icon.dart';

AppBar buildBestSellingAppBar(BuildContext context) {
  final theme = Theme.of(context);
  return AppBar(
    backgroundColor: theme.scaffoldBackgroundColor,
    elevation: 0,
    centerTitle: true,
    leading: Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: theme.iconTheme.color,
          size: 20,
        ),
        tooltip: 'back'.tr(),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FittedBox(fit: BoxFit.scaleDown, child: NotificationIcon()),
      ),
    ],
    title: Text(
      'best_selling'.tr(),
      style: AppTextStyle.textStyle19w700.copyWith(
        color: theme.textTheme.bodyLarge?.color,
        letterSpacing: 0.5,
      ),
    ),
    shape: Border(
      bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1), width: 1),
    ),
  );
}
