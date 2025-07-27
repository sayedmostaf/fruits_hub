import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/review_entity.dart';
import 'package:fruits_hub/core/functions/build_error_snack_bar.dart';
import 'package:fruits_hub/core/functions/get_dummy_review_item.dart';
import 'package:fruits_hub/core/functions/get_saved_user_data.dart';
import 'package:fruits_hub/features/reviews/presentation/managers/reviews_cubit.dart';
import 'package:fruits_hub/features/reviews/presentation/managers/reviews_state.dart';
import 'package:fruits_hub/features/reviews/presentation/views/widgets/custom_review_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReviewsSliverListViewBuilder extends StatelessWidget {
  const ReviewsSliverListViewBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewsCubit, ReviewsState>(
      listener: (context, state) {
        if (state is ReviewAddedFailureState) {
          buildErrorSnackBar(context, message: 'فشل في إضافة المراجعة');
        }
      },
      builder: (context, state) {
        if (state is ReviewsSuccessState) {
          final reviews = state.reviews;
          if (reviews.isEmpty) {
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('لا توجد مراجعات بعد، يمكنك إضافة واحدة'),
              ),
            );
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final review = reviews[index];

              return CustomReviewItem(
                reviewEntity: ReviewEntity(
                  userId: getSavedUserData().uid,
                  imageUrl: review.imageUrl,
                  reviewDescription: review.reviewDescription,
                  rating: review.rating,
                  createdAt: review.createdAt,
                  userName: review.userName,
                ),
              );
            }, childCount: reviews.length),
          );
        } else {
          return Skeletonizer.sliver(
            enabled: state is ReviewAddingLoadingState,
            child: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    CustomReviewItem(reviewEntity: getDummyReview()),
                childCount: 10,
              ),
            ),
          );
        }
      },
    );
  }
}
