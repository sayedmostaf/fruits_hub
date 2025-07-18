import 'package:equatable/equatable.dart';

import 'discount_entity.dart';
import 'review_entity.dart';

class ProductEntity extends Equatable {
  final String name;
  final String code;
  final String description;
  final double price;
  final int expirationMonths;
  final bool isFeatured;
  final bool isOrganic;
  final DateTime addDate;
  final int unitCount;
  final num avgRating;
  final int reviewsCount;
  final int numberOfCalories;
  final List<ReviewEntity> reviews;
  final int sellingCount;
  final String? imageUrL;
  final String? imageFilePath;
  final DiscountEntity? discount;
  const ProductEntity({
    required this.name,
    required this.code,
    required this.description,
    required this.price,
    required this.expirationMonths,
    required this.isFeatured,
    required this.isOrganic,
    required this.addDate,
    required this.unitCount,
    required this.avgRating,
    required this.reviewsCount,
    required this.numberOfCalories,
    required this.reviews,
    required this.sellingCount,
    this.imageUrL,
    this.imageFilePath,
    this.discount,
  });

  ProductEntity copyWith({
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
    return ProductEntity(
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
      reviews: reviews ?? this.reviews,
      sellingCount: sellingCount ?? this.sellingCount,
      imageUrL: imageUrL ?? this.imageUrL,
      imageFilePath: imageFilePath ?? this.imageFilePath,
      discount: discount ?? this.discount,
    );
  }

  @override
  List<Object?> get props => [
    name,
    code,
    description,
    price,
    expirationMonths,
    isFeatured,
    isOrganic,
    addDate,
    unitCount,
    avgRating,
    reviewsCount,
    numberOfCalories,
    reviews,
    sellingCount,
    imageUrL,
    imageFilePath,
    discount,
  ];
}
