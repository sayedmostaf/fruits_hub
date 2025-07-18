import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/managers/featured_product/featured_product_cubit.dart';
import 'package:fruits_hub/core/managers/product/product_cubit.dart';
import 'package:fruits_hub/core/repos/product/product_repo.dart';
import 'package:fruits_hub/core/services/app_locator.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    log('✅ User after sign out: ${user?.email ?? "No user"}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ProductCubit>(
              create: (context) => ProductCubit(getIt.get<ProductRepo>()),
            ),
            BlocProvider<FeaturedProductCubit>(
              create:
                  (context) => FeaturedProductCubit(getIt.get<ProductRepo>()),
            ),
          ],
          child: HomeViewBody(),
        ),
      ),
    );
  }
}
