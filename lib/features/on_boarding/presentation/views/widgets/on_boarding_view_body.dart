import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/services/shared_preferences.dart';
import 'package:fruits_hub/core/utils/constants.dart';
import 'package:fruits_hub/core/utils/widgets/custom_button.dart';
import 'package:fruits_hub/features/on_boarding/presentation/views/widgets/on_boarding_page_view.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  late PageController pageController;
  int currentPage = 0;

  @override
  void initState() {
    pageController = PageController();
    pageController.addListener(() {
      currentPage = pageController.page!.round();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        Expanded(child: OnBoardingPageView(pageController: pageController)),
        SizedBox(height: 64),
        DotsIndicator(
          dotsCount: 2,
          decorator: DotsDecorator(
            activeColor: primary,
            color: primary.withOpacity(currentPage == 0 ? 0.5 : 1),
          ),
        ),
        SizedBox(height: 29),
        Visibility(
          visible: currentPage == 1,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              onPressed: () {
                Pref.setBool(Constants.isOnBoardingViewSeen, true);
                // TODO: implement login
              },
              text: 'start_now'.tr(),
            ),
          ),
        ),
        SizedBox(height: 43),
      ],
    );
  }
}
