import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/widgets.dart';
import 'package:fruits_hub/core/cubits/products_cubit/products_cubit.dart';
import 'package:fruits_hub/core/widgets/custom_app_bar.dart';
import 'package:fruits_hub/core/widgets/search_text_field.dart';
import 'package:fruits_hub/features/category/presentation/view/widgets/our_category_bloc_builder.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/product_view_header.dart';
import 'package:fruits_hub/features/search/presentation/view/search_result_view.dart';
import 'package:provider/provider.dart';

class CategoryViewBody extends StatefulWidget {
  const CategoryViewBody({super.key});

  @override
  State<CategoryViewBody> createState() => _CategoryViewBodyState();
}

class _CategoryViewBodyState extends State<CategoryViewBody> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().getBestSellingProducts();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      triggerAxis: Axis.vertical,
      onRefresh: () {
        context.read<ProductsCubit>().getBestSellingProducts();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildAppBar(
                    context,
                    title: 'المنتجات',
                    showNotification: true,
                  ),
                  SizedBox(height: 16),
                  SearchTextField(
                    readOnly: true,
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          SearchResultView.routeName,
                        ),
                  ),
                  SizedBox(height: 10),
                  OurCategoryBlocBuilder(),
                  const SizedBox(height: 10),
                  ProductViewHeader(
                    productsLength:
                        context.read<ProductsCubit>().productsLength,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
