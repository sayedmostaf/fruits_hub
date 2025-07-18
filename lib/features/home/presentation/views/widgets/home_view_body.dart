import 'package:flutter/material.dart';
import 'package:fruits_hub/core/managers/featured_product/featured_product_cubit.dart';
import 'package:fruits_hub/core/managers/product/product_cubit.dart';
import 'package:fruits_hub/core/utils/widgets/custom_search_app_bar.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/custom_best_selling_header.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/custom_home_app_bar.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/featured_list_view_bloc_builder.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/product_sliver_grid_view_bloc_builder.dart';
import 'package:provider/provider.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  @override
  void initState() {
    context.read<ProductCubit>().getBestSellingProducts();
    context.read<FeaturedProductCubit>().getFeaturedProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                CustomHomeAppBar(),
                SizedBox(height: 16),
                CustomSearchAppBar(),
                SizedBox(height: 12),
                FeaturedListViewBlocBuilder(),
                SizedBox(height: 12),
                CustomBestSellingHeader(),
                SizedBox(height: 8),
              ],
            ),
          ),
          ProductSliverGridViewBlocBuilder(),
        ],
      ),
    );
  }
}
