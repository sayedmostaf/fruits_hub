import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/widgets/custom_app_bar.dart';
import 'package:fruits_hub/core/widgets/product_lever_grid_view.dart';
import 'package:fruits_hub/core/widgets/skeletonizer_sliver_loading_with_dummy_products.dart';
import 'package:fruits_hub/features/favorite/presentation/manager/cubit/favorite_cubit.dart';
import 'package:fruits_hub/features/favorite/presentation/manager/cubit/favorite_state.dart';

class FavoriteViewBody extends StatefulWidget {
  const FavoriteViewBody({super.key});

  @override
  State<FavoriteViewBody> createState() => _FavoriteViewBodyState();
}

class _FavoriteViewBodyState extends State<FavoriteViewBody> {
  bool isFirstLoaded = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isFirstLoaded) {
        context.read<FavoriteCubit>().initFavorites();
        isFirstLoaded = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: buildAppBar(
              context,
              title: "المفضلة",
              showNotification: false,
              showBackButton: true,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (context, state) {
              log('Current FavoriteState: $state');
              if (state is FavoriteSuccess) {
                log('Favorite products: ${state.favoriteProducts.length}');
                if (state.favoriteProducts.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('لم تقم بإضافة أي منتجات للمفضلة بعد'),
                      ),
                    ),
                  );
                }
                return ProductLeverGridView(
                  len: state.favoriteProducts.length,
                  products: state.favoriteProducts,
                );
              } else if (state is FavoriteFailure) {
                log('Favorite failure: ${state.message}');
                return SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed:
                              () =>
                                  context.read<FavoriteCubit>().getFavorites(),
                          child: const Text("إعادة المحاولة"),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SkeletonizerSliverLoadingWithDummyProducts();
              }
            },
          ),
        ],
      ),
    );
  }
}
