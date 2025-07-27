import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/models/review_model.dart';
import 'package:fruits_hub/features/reviews/domain/repos/reviews_repo.dart';
import 'package:fruits_hub/features/reviews/presentation/managers/reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsRepo reviewsRepo;
  final String productCode;
  List<ReviewModel> currentReviews;

  ReviewsCubit({required this.reviewsRepo, required this.productCode})
    : currentReviews = [],
      super(
        ReviewsSuccessState(reviews: [], averageRating: 0, reviewsCount: 0),
      ) {
    fetchLatestReviews();
  }

  Future<void> addReview({required ReviewModel review}) async {
    emit(ReviewAddingLoadingState());
    final result = await reviewsRepo.addNewReview(
      productCode: productCode,
      newReviewModel: review,
    );
    result.fold(
      (failure) {
        emit(ReviewAddedFailureState(failure.errMessage));
        emit(
          ReviewsSuccessState(
            reviews: currentReviews,
            averageRating: getTotalAverageRating(),
            reviewsCount: currentReviews.length,
          ),
        );
      },
      (_) async {
        await fetchLatestReviews();
      },
    );
  }

  Future<void> fetchLatestReviews() async {
    final result = await reviewsRepo.fetchReviewsProductCode(
      productCode: productCode,
    );
    result.fold(
      (failure) => emit(ReviewAddedFailureState(failure.errMessage)),
      (reviews) {
        currentReviews = reviews.map((e) => ReviewModel.fromEntity(e)).toList();

        emit(
          ReviewsSuccessState(
            reviews: reviews,
            averageRating: getTotalAverageRating(),
            reviewsCount: currentReviews.length,
          ),
        );
      },
    );
  }

  num getTotalAverageRating() {
    if (currentReviews.isEmpty) return 0;
    final total = currentReviews.fold<num>(
      0,
      (sum, review) => sum + (review.rating ?? 0),
    );
    return num.parse((total / currentReviews.length).toStringAsFixed(1));
  }
}
