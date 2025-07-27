import 'package:fruits_hub/core/entities/review_entity.dart';

sealed class ReviewsState {}

final class ReviewsSuccessState extends ReviewsState {
  final List<ReviewEntity> reviews;
  final num averageRating;
  final int reviewsCount;

  ReviewsSuccessState({
    required this.reviews,
    required this.averageRating,
    required this.reviewsCount,
  });
}

final class ReviewAddingLoadingState extends ReviewsState {}

final class ReviewAddedFailureState extends ReviewsState {
  final String errorMessage;

  ReviewAddedFailureState(this.errorMessage);
}
