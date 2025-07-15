import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/helper_functions/build_custom_snack_bar.dart';
import 'package:fruits_hub/core/helper_functions/on_generate_routes.dart';
import 'package:fruits_hub/core/managers/theme/theme_cubit.dart';
import 'package:fruits_hub/core/managers/theme/theme_state.dart';
import 'package:fruits_hub/core/services/shared_preferences.dart';
import 'package:fruits_hub/core/themes/themes.dart';
import 'package:fruits_hub/core/utils/constants.dart';
import 'package:fruits_hub/firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Pref.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      fallbackLocale: Locale('ar'),
      startLocale: Locale('ar'),
      path: 'assets/langs',
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => ThemeCubit())],
      child: FruitHub(),
    );
  }
}

class FruitHub extends StatefulWidget {
  const FruitHub({super.key});

  @override
  State<FruitHub> createState() => _FruitHubState();
}

class _FruitHubState extends State<FruitHub> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ThemeCubit, ThemeMode?>(
      listener: (context, state) {
        if (state != null) {
          Future.delayed(Duration(milliseconds: 300), () {
            final message =
                state == ThemeMode.dark
                    ? 'dark_mode_enabled'.tr()
                    : 'light_mode_enabled'.tr();
            final color =
                state == ThemeMode.dark ? Color(0xFF4A148C) : Color(0xFF4A148C);
            final IconData icon =
                state == ThemeMode.dark
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined;
            buildCustomSnackBar(
              message: message,
              backgroundColor: color,
              icon: icon,
            );
          });
        }
      },
      child: BlocBuilder<ThemeCubit, ThemeMode?>(
        builder: (context, themeMode) {
          if (themeMode == null) return SizedBox();

          /// TODO: handle custom scroll behavior
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            onGenerateRoute: onGenerateRoute,
            initialRoute: Constants.splashViewRoute,
          );
        },
      ),
    );
  }
}
