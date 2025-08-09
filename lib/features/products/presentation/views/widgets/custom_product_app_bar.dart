import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/widgets/notification_icon.dart';

class CustomProductAppBar extends StatelessWidget {
  const CustomProductAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppStrings.products.tr(),
        textAlign: TextAlign.start,
        style: AppTextStyle.textStyle18w700.copyWith(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      trailing: NotificationIcon(),
    );
  }
}
