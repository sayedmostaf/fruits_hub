import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/cubits/products_cubit/products_cubit.dart';
import 'package:fruits_hub/core/cubits/products_cubit/products_state.dart';
import 'package:fruits_hub/features/category/presentation/view/widgets/list_view_builder_horizontal_widget.dart';
import 'package:fruits_hub/features/category/presentation/view/widgets/our_category_title_and_filtering.dart';
import 'package:fruits_hub/features/category/presentation/view/widgets/skeletonizer_loading_with_dummy_products_category_widget.dart';

class OurCategoryBlocBuilder extends StatelessWidget {
  const OurCategoryBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          OurCategoryTitleAndFiltering(),
          SizedBox(height: 10),
          BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is ProductsSuccess) {
                return ListViewBuilderHorizontalWidget(
                  products: state.products,
                );
              } else if (state is ProductsFailure) {
                return Center(child: Text('Error to get products'));
              } else {
                return SkeletonizerLoadingWithDummyProductsCategoryWidget();
              }
            },
          ),
        ],
      ),
    );
  }
}
