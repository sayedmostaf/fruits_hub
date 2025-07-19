import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/functions/get_dummy_product.dart';
import 'package:fruits_hub/core/locale/recent_searche/recent_search_local_repo.dart';
import 'package:fruits_hub/core/managers/product/product_cubit.dart';
import 'package:fruits_hub/core/managers/product/product_state.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/product_sliver_grid_view_builder.dart';
import 'package:fruits_hub/features/search/presentation/views/widgets/custom_search_failure.dart';
import 'package:fruits_hub/features/search/presentation/views/widgets/custom_start_search_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchProductsBlocBuilder extends StatelessWidget {
  const SearchProductsBlocBuilder({
    super.key,
    required this.recentSearches,
    required this.textEditingController,
    required this.recentSearchLocalRepo,
  });
  final ValueNotifier<List<String>> recentSearches;
  final TextEditingController textEditingController;
  final RecentSearchLocalRepo recentSearchLocalRepo;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductInitial) {
          return SliverToBoxAdapter(
            child: CustomStartSearchWidget(
              recentSearches: recentSearches,
              textEditingController: textEditingController,
              recentSearchLocalRepo: recentSearchLocalRepo,
            ),
          );
        }
        if (state is ProductLoading) {
          return Skeletonizer.sliver(
            enabled: true,
            child: ProductSliverGridViewBuilder(
              productEntities: getListOfDummyProducts(),
            ),
          );
        }
        if (state is ProductSuccess) {
          return ProductSliverGridViewBuilder(
            productEntities: state.productsEntities,
          );
        }
        if (state is ProductNotFound || state is ProductFailure) {
          return const SliverFillRemaining(child: CustomSearchFailure());
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
