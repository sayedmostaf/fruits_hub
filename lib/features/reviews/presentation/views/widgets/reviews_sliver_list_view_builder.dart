import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fruits_hub/core/entities/review_entity.dart';
import 'package:fruits_hub/core/functions/build_error_snack_bar.dart';
import 'package:fruits_hub/core/functions/get_dummy_review_item.dart';
import 'package:fruits_hub/core/functions/get_saved_user_data.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/reviews/presentation/managers/reviews_cubit.dart';
import 'package:fruits_hub/features/reviews/presentation/managers/reviews_state.dart';
import 'package:fruits_hub/features/reviews/presentation/views/widgets/custom_review_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReviewsSliverListViewBuilder extends StatefulWidget {
  const ReviewsSliverListViewBuilder({
    super.key,
    this.showUserReviewsFirst = true,
    this.enablePullToRefresh = true,
  });

  final bool showUserReviewsFirst;
  final bool enablePullToRefresh;

  @override
  State<ReviewsSliverListViewBuilder> createState() =>
      _ReviewsSliverListViewBuilderState();
}

class _ReviewsSliverListViewBuilderState
    extends State<ReviewsSliverListViewBuilder>
    with AutomaticKeepAliveClientMixin {
  final Set<int> _expandedReviews = {};

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<ReviewsCubit, ReviewsState>(
      listener: _handleStateChanges,
      builder: (context, state) => _buildContent(context, state),
    );
  }

  void _handleStateChanges(BuildContext context, ReviewsState state) {
    if (state is ReviewAddedFailureState) {
      buildErrorSnackBar(context, message: state.errorMessage);
    } else if (state is ReviewsSuccessState) {
      // Show success message if a review was added
      if (state.reviews.isNotEmpty) {
        _showSuccessMessage(
          context,
          AppStrings.gettingReviews.tr(),
        );
      } else {
        _showSuccessMessage(context, AppStrings.reviewAddedSuccessfully.tr());
      }
      _expandedReviews.clear();
    } else if (state is ReviewAddedFailureState) {
      buildErrorSnackBar(context, message: state.errorMessage);
    }
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(message.tr()),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ReviewsState state) {
    if (state is ReviewsSuccessState) {
      return _buildReviewsList(context, state.reviews);
    } else if (state is ReviewAddingLoadingState) {
      return _buildLoadingState();
    } else if (state is ReviewAddedFailureState) {
      return _buildErrorState(context, state.errorMessage);
    } else {
      return _buildLoadingState();
    }
  }

  Widget _buildReviewsList(BuildContext context, List<ReviewEntity> reviews) {
    if (reviews.isEmpty) {
      return _buildEmptyState(context);
    }

    final userReviews =
        widget.showUserReviewsFirst
            ? _getUserReviews(reviews)
            : <ReviewEntity>[];
    final otherReviews =
        widget.showUserReviewsFirst ? _getOtherReviews(reviews) : reviews;

    return SliverMainAxisGroup(
      slivers: [
        if (userReviews.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            AppStrings.yourReviews.tr(),
            userReviews.length,
          ),
          _buildReviewsSliver(userReviews, isUserSection: true),
          if (otherReviews.isNotEmpty)
            _buildSectionHeader(
              context,
              AppStrings.otherReviews.tr(),
              otherReviews.length,
            ),
        ],
        if (otherReviews.isNotEmpty)
          _buildReviewsSliver(otherReviews, isUserSection: false),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title.tr(),
              style: AppTextStyle.textStyle16w600.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: AppTextStyle.textStyle12w500.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSliver(
    List<ReviewEntity> reviews, {
    required bool isUserSection,
  }) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final review = reviews[index];
        final reviewKey = review.hashCode;
        final isExpanded = _expandedReviews.contains(reviewKey);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomReviewItem(
            reviewEntity: review,
            isExpanded: isExpanded,
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedReviews.remove(reviewKey);
                } else {
                  _expandedReviews.add(reviewKey);
                }
              });
            },
          ),
        );
      }, childCount: reviews.length),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceVariant.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.rate_review_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.noReviewsYet.tr(),
                style: AppTextStyle.textStyle18w700.copyWith(
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
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {
                  // Scroll to add review section or trigger add review
                  Scrollable.ensureVisible(
                    context,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                icon: const Icon(Icons.add_comment),
                label: Text(AppStrings.addReview.tr()),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Skeletonizer.sliver(
      enabled: true,
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomReviewItem(reviewEntity: getDummyReview()),
          ),
          childCount: 5,
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.somethingWentWrong.tr(),
                style: AppTextStyle.textStyle18w700.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message ?? AppStrings.failedToLoadReviews.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle14w400.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<ReviewsCubit>().fetchLatestReviews();
                },
                icon: const Icon(Icons.refresh),
                label: Text(AppStrings.tryAgain.tr()),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ReviewEntity> _getUserReviews(List<ReviewEntity> reviews) {
    final currentUserId = getSavedUserData().uid;
    return reviews.where((review) => review.userId == currentUserId).toList();
  }

  List<ReviewEntity> _getOtherReviews(List<ReviewEntity> reviews) {
    final currentUserId = getSavedUserData().uid;
    return reviews.where((review) => review.userId != currentUserId).toList();
  }
}
