import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/services/shared_preferences.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/constants.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    _navigateToOnboardingView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset(Assets.imagesPlant),
        ),
        FadeInDown(
          duration: Duration(milliseconds: 1200),
          delay: Duration(milliseconds: 300),
          child: SvgPicture.asset(Assets.imagesLogo, width: 160),
        ),
        SvgPicture.asset(Assets.imagesSplashBottom, fit: BoxFit.cover),
      ],
    );
  }

  void _navigateToOnboardingView() {
    final bool isOnBoardingSeen = Pref.getBool(Constants.isOnBoardingViewSeen);
    // TODO: implement navgate to login
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Constants.onboardingViewRoute,
        (route) => false,
      );
    });
  }
}
