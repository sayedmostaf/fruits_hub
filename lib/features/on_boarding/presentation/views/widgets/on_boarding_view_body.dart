import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/constants.dart';
import 'package:fruits_hub/core/services/shared_preferences_singleton.dart';
import 'package:fruits_hub/core/utils/app_colors.dart';
import 'package:fruits_hub/core/widgets/custom_button.dart';
import 'package:fruits_hub/features/auth/presentation/views/signin_view.dart';
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
    super.initState();
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.round().toInt();
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: OnBoardingPageView(pageController: pageController)),
        DotsIndicator(
          dotsCount: 2,
          decorator: DotsDecorator(
            activeColor: AppColors.primaryColor,
            color:
                currentPage == 1
                    ? AppColors.primaryColor
                    : AppColors.primaryColor.withOpacity(0.5),
          ),
        ),
        SizedBox(height: 29),
        Visibility(
          visible: currentPage == 1,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            child: CustomButton(
              onPressed: () {
                Prefs.setBool(kIsOnBoardingViewSeen, true);
                Navigator.of(context).pushReplacementNamed(Signin.routeName);
              },
              text: 'ابدأ الان',
            ),
          ),
        ),
        SizedBox(height: 43),
      ],
    );
  }
}
