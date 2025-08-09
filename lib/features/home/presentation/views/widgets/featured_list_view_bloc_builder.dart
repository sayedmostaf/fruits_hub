import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/functions/get_dummy_product.dart';
import 'package:fruits_hub/core/managers/featured_product/featured_product_cubit.dart';
import 'package:fruits_hub/core/managers/featured_product/featured_product_state.dart';
import 'package:fruits_hub/core/utils/widgets/custom_loading_error.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/featured_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FeaturedListViewBlocBuilder extends StatelessWidget {
  const FeaturedListViewBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final itemWidth = MediaQuery.of(context).size.width - 32;
    return BlocBuilder<FeaturedProductCubit, FeaturedProductState>(
      builder: (context, state) {
        if (state is FeaturedProductSuccess) {
          return _buildListView(
            itemWidth,
            state.productsEntities.length,
            products: state.productsEntities,
          );
        } else if (state is FeaturedProductFailure) {
          return Center(
            child: CustomLoadingError(errMessage: state.errMessage),
          );
        } else {
          return Skeletonizer(
            enabled: true,
            child: _buildListView(
              itemWidth,
              getListOfDummyProducts().length,
              products: getListOfDummyProducts(),
            ),
          );
        }
      },
    );
  }

  Widget _buildListView(
    double itemWidth,
    int itemCount, {
    required List<ProductEntity> products,
  }) {
    return SizedBox(
      height: itemWidth * 158 / 342,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FeaturedItem(
              width: itemWidth,
              productEntity: products[index],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: itemCount,
      ),
    );
  }
}
