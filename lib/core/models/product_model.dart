import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/models/review_model.dart';
import 'package:fruits_hub/core/utils/firebase_fields.dart';
import '../entities/discount_entity.dart';
import '../entities/review_entity.dart';
import 'discount_model.dart';

class ProductModel extends ProductEntity {
  final DiscountModel? discount;

  const ProductModel({
    required super.name,
    required super.code,
    required super.description,
    required super.price,
    required super.expirationMonths,
    required super.isFeatured,
    required super.isOrganic,
    required super.addDate,
    required super.unitCount,
    required super.avgRating,
    required super.reviewsCount,
    required super.numberOfCalories,
    required super.reviews,
    required super.sellingCount,
    super.imageUrL,
    super.imageFilePath,
    this.discount,
  }) : super(discount: discount);

  File? get imageFile => imageFilePath != null ? File(imageFilePath!) : null;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json[FirebaseFields.productName] as String? ?? 'No name',
      code: json[FirebaseFields.productCode] as String? ?? 'No code',
      description:
          json[FirebaseFields.productDescription] as String? ??
          'No description',
      price: (json[FirebaseFields.productPrice] as num?)?.toDouble() ?? 0.0,
      expirationMonths:
          json[FirebaseFields.productExpirationMonths] as int? ?? 0,
      isFeatured: json[FirebaseFields.productIsFeatured] as bool? ?? false,
      isOrganic: json[FirebaseFields.productIsOrganic] as bool? ?? false,
      addDate:
          (json[FirebaseFields.productAddDate] as Timestamp?)?.toDate() ??
          DateTime(2000, 1, 1),
      unitCount: json[FirebaseFields.productUnitCount] as int? ?? 0,
      avgRating: json[FirebaseFields.productAvgRating] as num? ?? 0,
      reviewsCount: json[FirebaseFields.productReviewCount] as int? ?? 0,
      numberOfCalories: json[FirebaseFields.productCalories] as int? ?? 0,
      imageUrL: json[FirebaseFields.productImageURL] as String?,
      imageFilePath: json[FirebaseFields.productImageFilePath] as String?,
      reviews:
          (json[FirebaseFields.productReviews] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sellingCount: json[FirebaseFields.productSellingCount] as int? ?? 0,
      discount:
          json['discount'] != null
              ? DiscountModel.fromJson(
                Map<String, dynamic>.from(json['discount']),
              )
              : null,
    );
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      name: entity.name,
      code: entity.code,
      description: entity.description,
      price: entity.price,
      expirationMonths: entity.expirationMonths,
      isFeatured: entity.isFeatured,
      isOrganic: entity.isOrganic,
      addDate: entity.addDate,
      unitCount: entity.unitCount,
      avgRating: entity.avgRating,
      reviewsCount: entity.reviewsCount,
      numberOfCalories: entity.numberOfCalories,
      reviews: entity.reviews.map((e) => ReviewModel.fromEntity(e)).toList(),
      sellingCount: entity.sellingCount,
      imageUrL: entity.imageUrL,
      imageFilePath: entity.imageFilePath,
      discount:
          entity.discount != null
              ? DiscountModel.fromEntity(entity.discount!)
              : null,
    );
  }

  ProductModel copyWith({
    String? name,
    String? code,
    String? description,
    double? price,
    int? expirationMonths,
    bool? isFeatured,
    bool? isOrganic,
    DateTime? addDate,
    int? unitCount,
    num? avgRating,
    int? reviewsCount,
    int? numberOfCalories,
    List<ReviewEntity>? reviews,
    int? sellingCount,
    String? imageUrL,
    String? imageFilePath,
    DiscountEntity? discount,
  }) {
    return ProductModel(
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      price: price ?? this.price,
      expirationMonths: expirationMonths ?? this.expirationMonths,
      isFeatured: isFeatured ?? this.isFeatured,
      isOrganic: isOrganic ?? this.isOrganic,
      addDate: addDate ?? this.addDate,
      unitCount: unitCount ?? this.unitCount,
      avgRating: avgRating ?? this.avgRating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      numberOfCalories: numberOfCalories ?? this.numberOfCalories,
      reviews:
          (reviews ?? this.reviews)
              .map((e) => ReviewModel.fromEntity(e))
              .toList(),
      sellingCount: sellingCount ?? this.sellingCount,
      imageUrL: imageUrL ?? this.imageUrL,
      imageFilePath: imageFilePath ?? this.imageFilePath,
      discount:
          discount != null ? DiscountModel.fromEntity(discount) : this.discount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      FirebaseFields.productName: name,
      FirebaseFields.productCode: code,
      FirebaseFields.productDescription: description,
      FirebaseFields.productPrice: price,
      FirebaseFields.productExpirationMonths: expirationMonths,
      FirebaseFields.productIsFeatured: isFeatured,
      FirebaseFields.productIsOrganic: isOrganic,
      FirebaseFields.productAddDate: Timestamp.fromDate(addDate),
      FirebaseFields.productUnitCount: unitCount,
      FirebaseFields.productAvgRating: avgRating,
      FirebaseFields.productReviewCount: reviewsCount,
      FirebaseFields.productCalories: numberOfCalories,
      FirebaseFields.productReviews:
          reviews.map((e) => ReviewModel.fromEntity(e).toJson()).toList(),
      FirebaseFields.productImageURL: imageUrL,
      FirebaseFields.productImageFilePath: imageFilePath,
      FirebaseFields.productSellingCount: sellingCount,
    };
  }
}
