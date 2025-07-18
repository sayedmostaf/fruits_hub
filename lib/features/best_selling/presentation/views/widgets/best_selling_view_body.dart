import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/managers/product/product_cubit.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/product_sliver_grid_view_bloc_builder.dart';

class BestSellingViewBody extends StatelessWidget {
  const BestSellingViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    int productsLength = context.watch<ProductCubit>().length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$productsLength ${AppStrings.results.tr()}",
                  textAlign: TextAlign.right,
                  style: AppTextStyle.textStyle16w700.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
