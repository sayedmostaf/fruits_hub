import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/reviews/presentation/managers/reviews_cubit.dart';
import 'package:provider/provider.dart';

class ReviewsDisplaySection extends StatefulWidget {
  const ReviewsDisplaySection({super.key, required this.productEntity});
  final ProductEntity productEntity;
  @override
  State<ReviewsDisplaySection> createState() => _ReviewsDisplaySectionState();
}

class _ReviewsDisplaySectionState extends State<ReviewsDisplaySection> {
  @override
  Widget build(BuildContext context) {
    final reviewsCubit = context.watch<ReviewsCubit>();
    final currentReviews = reviewsCubit.currentReviews;
    final int currentReviewsCount = currentReviews.length;

    final double avgRating = reviewsCubit.getTotalAverageRating().toDouble();
    final double recommendPercentage = (avgRating / 5) * 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$currentReviewsCount ${AppStrings.review.tr()}',
          style: AppTextStyle.textStyle13w700.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 16),
        _buildReviewSummaryBox(
          context: context,
          recommendPercentage: recommendPercentage,
          avgRating: avgRating,
        ),
      ],
    );
  }

  Widget _buildReviewSummaryBox({
    required BuildContext context,
    required double recommendPercentage,
    required double avgRating,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.orderSummary.tr(),
            style: AppTextStyle.textStyle16w600.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 12),
          ...List.generate(5, (index) {
            final int rating = 5 - index;
            final reviewsRatings =
                context
                    .watch<ReviewsCubit>()
                    .currentReviews
                    .map((review) => review.rating)
                    .toList();
            final int ratingsCount = _getTotalRatingCount(
              ratings: reviewsRatings,
              rating: rating,
            );
            final double percentage = _getRatingPercentage(
              percentage: ratingsCount / reviewsRatings.length,
            );

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text(
                    '$rating',
                    style: AppTextStyle.textStyle13w600.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Align(
                          alignment:
                              Directionality.of(context) == TextDirection.RTL
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: percentage,
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    avgRating.toStringAsFixed(1),
                    style: AppTextStyle.textStyle14w700.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.star,
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
          Text(
            '${recommendPercentage.toStringAsFixed(1)}% ${'recommended'.tr()}',
            style: AppTextStyle.textStyle12w400.copyWith(
              color: Theme.of(context).textTheme.labelMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalRatingCount({required List<num> ratings, required int rating}) {
    int counter = 0;
    for (num rate in ratings) {
      if (rate >= rating && rate < (rating + 1)) {
        counter++;
      }
    }
    return counter;
  }

  double _getRatingPercentage({required double percentage}) {
    if (percentage.isNaN || percentage <= 0) return 0.0;
    if (percentage >= 1.0) return 1.0;
    return percentage;
  }
}
