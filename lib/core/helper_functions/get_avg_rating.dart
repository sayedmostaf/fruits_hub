import 'package:fruits_hub/core/entities/review_entity.dart';

num getAvgRating(List<ReviewEntity> reviews) {
  var sum = 0.0;
  for (var review in reviews) {
    sum += review.rating;
  }
  return sum / reviews.length;
}
