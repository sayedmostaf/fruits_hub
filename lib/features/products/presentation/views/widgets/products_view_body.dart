import 'package:flutter/material.dart';
import 'package:fruits_hub/core/managers/product/product_cubit.dart';
import 'package:fruits_hub/core/utils/widgets/custom_search_app_bar.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/product_sliver_grid_view_bloc_builder.dart';
import 'package:fruits_hub/features/products/presentation/views/widgets/custom_product_app_bar.dart';
import 'package:fruits_hub/features/products/presentation/views/widgets/product_header_widget.dart';
import 'package:provider/provider.dart';

class ProductsViewBody extends StatefulWidget {
  const ProductsViewBody({super.key});

  @override
  State<ProductsViewBody> createState() => _ProductsViewBodyState();
}

class _ProductsViewBodyState extends State<ProductsViewBody> {
  @override
  void initState() {
    context.read<ProductCubit>().getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                CustomProductAppBar(),
                const SizedBox(height: 16),
                CustomSearchAppBar(),
                const SizedBox(height: 12),
                ProductHeaderWidget(
                  productLength: context.watch<ProductCubit>().length,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          ProductSliverGridViewBlocBuilder(),
        ],
      ),
    );
  }
}
