import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/constants.dart';
import 'package:fruits_hub/features/splash/presentation/views/splash_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Constants.splashViewRoute:
      return MaterialPageRoute(builder: (context) => const SplashView());
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(body: Center(child: Text('wrong page'))),
      );
  }
}
