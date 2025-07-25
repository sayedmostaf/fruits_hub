import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/functions/build_custom_snack_bar.dart';
import 'package:fruits_hub/core/functions/on_generate_routes.dart';
import 'package:fruits_hub/core/managers/theme/theme_cubit.dart';
import 'package:fruits_hub/core/services/app_locator.dart';
import 'package:fruits_hub/core/services/bloc_observer.dart';
import 'package:fruits_hub/core/services/shared_preferences.dart';
import 'package:fruits_hub/core/services/supabase_storage_service.dart';
import 'package:fruits_hub/core/themes/themes.dart';
import 'package:fruits_hub/core/utils/constants.dart';
import 'package:fruits_hub/core/utils/locale_box.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/custom_scroll_behavior.dart';
import 'package:fruits_hub/features/settings/presentation/managers/favorites/favorites_cubit.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_cubit.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart_item/cart_item_cubit.dart';
import 'package:fruits_hub/firebase_options.dart';
import 'package:fruits_hub/features/search/domain/entities/recent_search_entity.dart';
import 'package:hive_flutter/adapters.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SupabaseStorageService.init();
  await Pref.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  Hive.registerAdapter(RecentSearchesEntityAdapter());
  Hive.registerAdapter(ProductEntityAdapter());
  await Hive.openBox<List>(LocaleBox.recentSearchBox);
  await Hive.openBox<ProductEntity>(LocaleBox.favoritesBox);

  Bloc.observer = CustomBlocObserver();
  setupLocator();
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
      providers: [
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => CartItemCubit()),
        BlocProvider(create: (_) => FavoritesCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
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
          return ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: MaterialApp(
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
            ),
          );
        },
      ),
    );
  }
}
