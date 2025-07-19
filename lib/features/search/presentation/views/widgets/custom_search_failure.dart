import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class CustomSearchFailure extends StatelessWidget {
  const CustomSearchFailure({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(Assets.imagesSearchNotFound, width: 120, height: 120),
        const SizedBox(height: 16),
        Text(
          AppStrings.searchNotAvailable.tr(),
          style: AppTextStyle.textStyle13w400.copyWith(
            color: theme.textTheme.labelMedium?.color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
