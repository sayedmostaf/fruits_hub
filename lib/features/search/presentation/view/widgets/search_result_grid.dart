import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/widgets/product_lever_grid_view.dart';
import 'package:fruits_hub/core/widgets/skeletonizer_sliver_loading_with_dummy_products.dart';
import 'package:fruits_hub/features/search/presentation/cubit/search_cubit.dart';
import 'package:fruits_hub/features/search/presentation/cubit/search_state.dart';

class SearchResultGrid extends StatelessWidget {
  const SearchResultGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(child: Text('ابحث عن المنتجات')),
            ),
          );
        } else if (state is SearchLoading) {
          return SkeletonizerSliverLoadingWithDummyProducts();
        } else if (state is SearchSuccess) {
          if (state.products.isEmpty) {
            return SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(Assets.imagesNoResult),
                    Text(
                      'البحث',
                      textAlign: TextAlign.center,
                      style: TextStyles.bold16.copyWith(
                        color: Color(0xFF616A6B),
                      ),
                    ),
                    Text(
                      'عفوًا... هذه المعلومات غير متوفرة للحظة',
                      textAlign: TextAlign.center,
                      style: TextStyles.regular13.copyWith(
                        color: Color(0xFF616A6B),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ProductLeverGridView(
            len: state.products.length,
            products: state.products,
          );
        } else if (state is SearchFailure) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Color(0xFF616A6B),
                    ),
                    SizedBox(height: 16),
                    Text(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyles.regular13.copyWith(
                        color: Color(0xFF616A6B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
      },
    );
  }
}
