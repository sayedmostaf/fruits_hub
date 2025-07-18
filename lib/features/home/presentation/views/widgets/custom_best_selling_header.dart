import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/widgets/see_more_button.dart';
import 'package:fruits_hub/features/best_selling/presentation/views/best_selling_view.dart';

class CustomBestSellingHeader extends StatelessWidget {
  const CustomBestSellingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.bestSelling.tr(),
          style: AppTextStyle.textStyle16w700.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Spacer(),
        SeeMoreButton(view: BestSellingView()),
      ],
    );
  }
}
