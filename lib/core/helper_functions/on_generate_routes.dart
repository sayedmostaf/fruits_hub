import 'package:flutter/material.dart';
import 'package:fruits_hub/core/models/product_model.dart';
import 'package:fruits_hub/features/auth/presentation/views/signin_view.dart';
import 'package:fruits_hub/features/auth/presentation/views/signup_view.dart';
import 'package:fruits_hub/features/best_selling_fruits/presentation/views/best_selling_view.dart';
import 'package:fruits_hub/features/checkout/presentation/views/checkout_view.dart';
import 'package:fruits_hub/features/favorite/presentation/view/favorite_view.dart';
import 'package:fruits_hub/features/home/domain/entities/cart_entity.dart';
import 'package:fruits_hub/features/home/presentation/views/main_view.dart';
import 'package:fruits_hub/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:fruits_hub/features/product_details/presentation/view/product_details_view.dart';
import 'package:fruits_hub/features/search/presentation/view/search_result_view.dart';
import 'package:fruits_hub/features/splash/presentation/views/splash_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (_) => const SplashView());
    case OnBoardingView.routeName:
      return MaterialPageRoute(builder: (_) => const OnBoardingView());
    case Signin.routeName:
      return MaterialPageRoute(builder: (_) => const Signin());
    case SignupView.routeName:
      return MaterialPageRoute(builder: (_) => const SignupView());
    case MainView.routeName:
      return MaterialPageRoute(builder: (_) => const MainView());
    case BestSellingView.routeName:
      return MaterialPageRoute(builder: (context) => const BestSellingView());
    case CheckoutView.routeName:
      return MaterialPageRoute(
        builder:
            (_) => CheckoutView(cartEntity: settings.arguments as CartEntity),
      );
    case ProductDetailsView.routeName:
      return MaterialPageRoute(
        builder:
            (context) => ProductDetailsView(
              productModel: settings.arguments as ProductModel,
            ),
      );
    case SearchResultView.routeName:
      return MaterialPageRoute(builder: (_) => const SearchResultView());
    case FavoriteView.routeName:
      return MaterialPageRoute(builder: (_) => const FavoriteView ());
    default:
      return MaterialPageRoute(builder: (_) => const Scaffold());
  }
}
