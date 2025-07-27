import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/custom_scroll_behavior.dart';
import 'package:fruits_hub/features/reviews/presentation/managers/reviews_cubit.dart';
import 'package:fruits_hub/features/reviews/presentation/managers/reviews_state.dart';
import 'package:fruits_hub/features/reviews/presentation/views/widgets/adding_review_section.dart';
import 'package:fruits_hub/features/reviews/presentation/views/widgets/reviews_display_section.dart';
import 'package:fruits_hub/features/reviews/presentation/views/widgets/reviews_sliver_list_view_builder.dart';

class ReviewsViewBody extends StatefulWidget {
  const ReviewsViewBody({super.key, required this.productEntity});
  final ProductEntity productEntity;
  @override
  State<ReviewsViewBody> createState() => _ReviewsViewBodyState();
}

class _ReviewsViewBodyState extends State<ReviewsViewBody> {
  Future<void> _onRefresh() async {
    await context.read<ReviewsCubit>().fetchLatestReviews();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AddingReviewSection(),
                        const SizedBox(height: 16),
                        ReviewsDisplaySection(
                          productEntity: widget.productEntity,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: ReviewsSliverListViewBuilder(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
