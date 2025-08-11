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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, currentReviewsCount),
        const SizedBox(height: 20),
        _buildReviewSummaryCard(context, avgRating, currentReviews),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, int reviewsCount) {
    return Row(
      children: [
        Icon(
          Icons.rate_review_outlined,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          '$reviewsCount ${AppStrings.review.tr()}',
          style: AppTextStyle.textStyle13w700.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSummaryCard(
    BuildContext context,
    double avgRating,
    List currentReviews,
  ) {
    if (currentReviews.isEmpty) {
      return _buildEmptyReviewsState(context);
    }

    final double recommendPercentage = (avgRating / 5) * 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.12),
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildRatingOverview(context, avgRating, recommendPercentage),
          const SizedBox(height: 24),
          _buildRatingBreakdown(context, currentReviews),
        ],
      ),
    );
  }

  Widget _buildRatingOverview(
    BuildContext context,
    double avgRating,
    double recommendPercentage,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      avgRating.toStringAsFixed(1),
                      style: AppTextStyle.textStyle16w600.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/5',
                      style: AppTextStyle.textStyle14w400.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _buildStarRating(context, avgRating),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${recommendPercentage.toStringAsFixed(0)}%',
                  style: AppTextStyle.textStyle16w600.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppStrings.recommended.tr(),
                  style: AppTextStyle.textStyle12w400.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(BuildContext context, double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        double fillAmount = (rating - index).clamp(0.0, 1.0);
        return Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Stack(
            children: [
              Icon(
                Icons.star_outline,
                size: 18,
                color: Theme.of(context).colorScheme.outline,
              ),
              ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: fillAmount,
                  child: Icon(
                    Icons.star,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRatingBreakdown(BuildContext context, List currentReviews) {
    final reviewsRatings =
        currentReviews.map((review) => review.rating).cast<num>().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.ratingBreakdown.tr(),
          style: AppTextStyle.textStyle14w600.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(5, (index) {
          final int rating = 5 - index;
          final int ratingsCount = _getTotalRatingCount(
            ratings: reviewsRatings,
            rating: rating,
          );
          final double percentage = _getRatingPercentage(
            percentage:
                reviewsRatings.isEmpty
                    ? 0.0
                    : ratingsCount / reviewsRatings.length,
          );

          return _buildRatingBar(context, rating, ratingsCount, percentage);
        }),
      ],
    );
  }

  Widget _buildRatingBar(
    BuildContext context,
    int rating,
    int count,
    double percentage,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            child: Text(
              '$rating',
              style: AppTextStyle.textStyle13w600.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.star,
            size: 14,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                FractionallySizedBox(
                  alignment:
                      Directionality.of(context) == TextDirection.RTL
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  widthFactor: percentage,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: _getBarColor(context, rating),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 24,
            child: Text(
              '$count',
              textAlign: TextAlign.end,
              style: AppTextStyle.textStyle12w400.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyReviewsState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.12),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noReviewsYet.tr(),
            style: AppTextStyle.textStyle16w600.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.beTheFirstToReview.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyle.textStyle14w400.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBarColor(BuildContext context, int rating) {
    switch (rating) {
      case 5:
      case 4:
        return Theme.of(context).colorScheme.primary;
      case 3:
        return Colors.orange;
      case 2:
      case 1:
        return Colors.red.withOpacity(0.7);
      default:
        return Theme.of(context).colorScheme.outline;
    }
  }

  int _getTotalRatingCount({required List<num> ratings, required int rating}) {
    return ratings
        .where((rate) => rate >= rating && rate < (rating + 1))
        .length;
  }

  double _getRatingPercentage({required double percentage}) {
    if (percentage.isNaN || percentage <= 0) return 0.0;
    if (percentage >= 1.0) return 1.0;
    return percentage;
  }
}
