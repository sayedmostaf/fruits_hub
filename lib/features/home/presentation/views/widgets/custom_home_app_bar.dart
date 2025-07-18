import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/functions/get_saved_user_data.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/widgets/notification_icon.dart';

class CustomHomeAppBar extends StatelessWidget {
  const CustomHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String? userImageUrl = getSavedUserData().imageUrl;
    return ListTile(
      leading: ClipOval(
        child: CachedNetworkImage(
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          imageUrl: userImageUrl ?? '',
          errorWidget:
              (context, url, error) => Container(
                color: Theme.of(context).colorScheme.surface,
                alignment: Alignment.center,
                child: Icon(Icons.person, size: 24, color: Colors.white),
              ),
        ),
      ),
      title: Text(
        AppStrings.goodMorning.tr(),
        style: AppTextStyle.textStyle16w400.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
      subtitle: Text(
        getSavedUserData().name,
        style: AppTextStyle.textStyle16w700.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
      trailing: NotificationIcon(),
    );
  }
}
