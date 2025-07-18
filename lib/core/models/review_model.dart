import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruits_hub/core/entities/review_entity.dart';
import 'package:fruits_hub/core/utils/firebase_fields.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.userId,
    required super.userName,
    required super.createdAt,
    required super.rating,
    required super.reviewDescription,
    required super.imageUrl,
  });

  factory ReviewModel.fromEntity(ReviewEntity entity) {
    return ReviewModel(
      userId: entity.userId,
      userName: entity.userName,
      createdAt: entity.createdAt,
      rating: entity.rating,
      reviewDescription: entity.reviewDescription,
      imageUrl: entity.imageUrl,
    );
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawDate = json[FirebaseFields.reviewDate];
    final DateTime parsedDate = rawDate is Timestamp
        ? rawDate.toDate()
        : DateTime.tryParse(rawDate?.toString() ?? '') ?? DateTime(2000, 1, 1);

    return ReviewModel(
      userId: json[FirebaseFields.reviewUserId] as String? ?? '',
      userName: json[FirebaseFields.reviewUserName] as String? ?? '',
      createdAt: parsedDate,
      rating: json[FirebaseFields.reviewRating] as num? ?? 0,
      reviewDescription: json[FirebaseFields.reviewDescription] as String? ?? '',
      imageUrl: json[FirebaseFields.reviewImageUrl] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      FirebaseFields.reviewUserId: userId,
      FirebaseFields.reviewUserName: userName,
      FirebaseFields.reviewDate: Timestamp.fromDate(createdAt),
      FirebaseFields.reviewRating: rating,
      FirebaseFields.reviewDescription: reviewDescription,
      FirebaseFields.reviewImageUrl: imageUrl,
    };
  }
}