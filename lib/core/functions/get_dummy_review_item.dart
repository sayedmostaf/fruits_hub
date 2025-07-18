import 'package:fruits_hub/core/entities/review_entity.dart';

ReviewEntity getDummyReview() {
  return ReviewEntity(
    userId: '',
    userName: '...',
    createdAt: DateTime.now(),
    reviewDescription: '...',
    rating: 0.0,
    imageUrl: '',
  );
}

List<ReviewEntity> getListOfDummyReviews() {
  return List.generate(5, (_) => getDummyReview());
}
