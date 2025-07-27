import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/entities/review_entity.dart';
import 'package:fruits_hub/core/errors/failure.dart';
import 'package:fruits_hub/core/models/review_model.dart';

abstract class ReviewsRepo {
  Future<Either<Failure, void>> addNewReview({
    required String productCode,
    required ReviewModel newReviewModel,
  });
  Future<Either<Failure, List<ReviewEntity>>> fetchReviewsProductCode({
    required String productCode,
  });
}
