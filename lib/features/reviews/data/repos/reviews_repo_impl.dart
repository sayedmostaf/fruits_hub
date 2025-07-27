import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/entities/review_entity.dart';
import 'package:fruits_hub/core/errors/failure.dart';
import 'package:fruits_hub/core/models/product_model.dart';
import 'package:fruits_hub/core/models/review_model.dart';
import 'package:fruits_hub/core/services/database_service.dart';
import 'package:fruits_hub/core/services/firestore_service.dart';
import 'package:fruits_hub/core/utils/backend_endpoints.dart';
import 'package:fruits_hub/features/reviews/domain/repos/reviews_repo.dart';

class ReviewsRepoImpl implements ReviewsRepo {
  final DatabaseService databaseService;
  final FirestoreService firestoreService = FirestoreService();
  ReviewsRepoImpl({required this.databaseService});
  @override
  Future<Either<Failure, void>> addNewReview({
    required String productCode,
    required ReviewModel newReviewModel,
  }) async {
    try {
      final dynamic rawData = await databaseService.getDocumentOrCollection(
        path: BackendEndpoints.getProduct,
        documentId: productCode,
      );

      if (rawData == null || rawData is! Map<String, dynamic>) {
        log('❌ Product not found or invalid format');
        return left(
          ServerFailure(errMessage: 'Product not found or invalid format'),
        );
      }
      final productJson = rawData as Map<String, dynamic>;
      final ProductModel productModel = ProductModel.fromJson(productJson);
      final reviewsSnapshot =
          await firestoreService.firestore
              .collection(BackendEndpoints.getProducts)
              .doc(productCode)
              .collection(BackendEndpoints.getReviews)
              .get();

      final List<ReviewModel> existingReviews =
          reviewsSnapshot.docs
              .map((doc) => ReviewModel.fromJson(doc.data()))
              .toList();

      final updatedReviews = [
        ...existingReviews.where((r) => r.userId != newReviewModel.userId),
        ReviewModel.fromEntity(newReviewModel),
      ];
      final totalRating = updatedReviews.fold<num>(
        0,
        (sum, r) => sum + (r.rating ?? 0),
      );
      final avgRating =
          updatedReviews.isEmpty ? 0 : totalRating / updatedReviews.length;

      final updatedProduct = productModel.copyWith(
        avgRating: num.parse(avgRating.toStringAsFixed(1)),
        reviewsCount: updatedReviews.length,
      );

      await databaseService.addDocument(
        path: BackendEndpoints.updateProduct,
        data: updatedProduct.toJson(),
        documentId: productCode,
      );

      await firestoreService.firestore
          .collection(BackendEndpoints.getProducts)
          .doc(productCode)
          .collection(BackendEndpoints.getReviews)
          .doc(newReviewModel.userId)
          .set(
            ReviewModel.fromEntity(newReviewModel).toJson(),
            SetOptions(merge: true),
          );
      log('✅ Review saved and product updated');
      return right(null);
    } catch (e, stackTrace) {
      log('❌ Error adding review: $e');
      log('🪵 StackTrace: $stackTrace');
      return left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> fetchReviewsProductCode({
    required String productCode,
  }) async {
    try {
      final reviewsSnapshot =
          await firestoreService.firestore
              .collection(BackendEndpoints.getProducts)
              .doc(productCode)
              .collection(BackendEndpoints.getReviews)
              .orderBy(BackendEndpoints.getReviewDate, descending: true)
              .get();
      final reviews =
          reviewsSnapshot.docs
              .map((doc) => ReviewModel.fromJson(doc.data()))
              .toList();
      log('✅ Fetched ${reviews.length} reviews for product: $productCode');
      return right(reviews);
    } catch (e, stackTrace) {
      log('❌ Error fetching reviews: $e');
      log('🪵 StackTrace: $stackTrace');
      return left(ServerFailure(errMessage: e.toString()));
    }
  }
}
