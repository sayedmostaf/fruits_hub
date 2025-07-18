import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/functions/get_dummy_product.dart';
import 'package:fruits_hub/core/managers/product/product_cubit.dart';
import 'package:fruits_hub/core/managers/product/product_state.dart';
import 'package:fruits_hub/core/utils/widgets/custom_loading_error.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/product_sliver_grid_view_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductSliverGridViewBlocBuilder extends StatelessWidget {
  const ProductSliverGridViewBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductSuccess) {
          return ProductSliverGridViewBuilder(
            productEntities: state.productsEntities,
          );
        } else if (state is ProductFailure) {
          return SliverToBoxAdapter(
            child: CustomLoadingError(errMessage: state.message),
          );
        } else {
          return Skeletonizer.sliver(
            child: ProductSliverGridViewBuilder(
              productEntities: getListOfDummyProducts(),
            ),
          );
        }
      },
    );
  }
}
