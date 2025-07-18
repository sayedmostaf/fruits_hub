import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String userId;
  final String userName;
  final DateTime createdAt;
  final String reviewDescription;
  final String? imageUrl;
  final num rating;

  const ReviewEntity({
    required this.userId,
    required this.userName,
    required this.createdAt,
    required this.rating,
    required this.reviewDescription,
    required this.imageUrl,
  });

  ReviewEntity copyWith({
    String? userId,
    String? userName,
    DateTime? createdAt,
    String? reviewDescription,
    String? imageUrl,
    num? rating,
  }) {
    return ReviewEntity(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      createdAt: createdAt ?? this.createdAt,
      rating: rating ?? this.rating,
      reviewDescription: reviewDescription ?? this.reviewDescription,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    userName,
    createdAt,
    rating,
    reviewDescription,
    imageUrl,
  ];
}
