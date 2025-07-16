import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class CustomSocialButtons extends StatelessWidget {
  const CustomSocialButtons({
    super.key,
    required this.text,
    required this.iconData,
    required this.onPressed,
  });
  final String text, iconData;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 56,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: theme.dividerColor, width: 1),
          ),
        ),
        child: ListTile(
          leading: SvgPicture.asset(
            iconData,
            color:
                Theme.of(context).brightness == Brightness.dark &&
                        iconData == Assets.imagesFacebookIcon
                    ? Colors.blue
                    : null,
          ),
          visualDensity: const VisualDensity(
            vertical: VisualDensity.minimumDensity,
          ),
          title: Text(
            text.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyle.textStyle16w600.copyWith(
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ),
    );
  }
}
