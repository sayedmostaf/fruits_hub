import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/on_boarding/presentation/views/widgets/page_view_item.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({super.key, required this.pageController});
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    final Color textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    return PageView(
      physics: BouncingScrollPhysics(),
      controller: pageController,
      children: [
        PageViewItem(
          backgroundImage: Assets.imagesPageViewItem1BackgroundImage,
          image: Assets.imagesPageViewItem1Image,
          subTitle: 'on_boarding_1_subtitle'.tr(),
          title: Text.rich(
            TextSpan(
              children:
                  context.locale.languageCode == 'ar'
                      ? [
                        TextSpan(
                          text: ' Fruit',
                          style: AppTextStyle.textStyle23w700.copyWith(
                            color: const Color(0xFF1B5E37),
                          ),
                        ),
                        TextSpan(
                          text: 'HUB',
                          style: AppTextStyle.textStyle23w700.copyWith(
                            color: const Color(0xFFF4A91F),
                          ),
                        ),
                        TextSpan(
                          text: ' ${'on_boarding_1_title_1'.tr()}',
                          style: AppTextStyle.textStyle23w700.copyWith(
                            color: textColor,
                          ),
                        ),
                      ]
                      : [
                        TextSpan(
                          text: '${'on_boarding_1_title_1'.tr()} ',
                          style: AppTextStyle.textStyle23w700.copyWith(
                            color: textColor,
                          ),
                        ),
                        TextSpan(
                          text: 'Fruit',
                          style: AppTextStyle.textStyle23w700.copyWith(
                            color: const Color(0xFF1B5E37),
                          ),
                        ),
                        TextSpan(
                          text: 'HUB',
                          style: AppTextStyle.textStyle23w700.copyWith(
                            color: const Color(0xFFF4A91F),
                          ),
                        ),
                      ],
            ),
            textAlign: TextAlign.center,
          ),
          isVisible: true,
        ),
        PageViewItem(
          backgroundImage: Assets.imagesPageViewItem2BackgroundImage,
          image: Assets.imagesPageViewItem2Image,
          subTitle: 'on_boarding_2_subtitle'.tr(),
          title: Text(
            'on_boarding_2_title'.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyle.textStyle23w700.copyWith(color: textColor),
          ),
          isVisible: false,
        ),
      ],
    );
  }
}
