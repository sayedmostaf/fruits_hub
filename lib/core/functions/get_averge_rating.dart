import 'package:fruits_hub/core/entities/review_entity.dart';

num getAverageRating(List<ReviewEntity> reviews) {
  if (reviews.isEmpty) return 0.0;
  num sum = 0.0;
  for (var review in reviews) {
    sum += review.rating;
  }

  return num.parse((sum / reviews.length).toStringAsFixed(1));
}
