import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/constants.dart';
import 'package:fruits_hub/features/auth/presentation/views/login_view.dart';
import 'package:fruits_hub/features/auth/presentation/views/sign_up_view.dart';
import 'package:fruits_hub/features/auth/presentation/views/widgets/forget_password_view.dart';
import 'package:fruits_hub/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:fruits_hub/features/splash/presentation/views/splash_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Constants.splashViewRoute:
      return MaterialPageRoute(builder: (context) => const SplashView());
    case Constants.onboardingViewRoute:
      return MaterialPageRoute(builder: (context) => const OnBoardingView());
    case Constants.signUpViewRoute:
      return MaterialPageRoute(builder: (context) => const SignUpView());
    case Constants.loginViewRoute:
      return MaterialPageRoute(builder: (context) => const LoginView());
    case Constants.forgetPasswordViewRoute:
      return MaterialPageRoute(
        builder: (context) => const ForgetPasswordView(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(body: Center(child: Text('wrong page'))),
      );
  }
}
