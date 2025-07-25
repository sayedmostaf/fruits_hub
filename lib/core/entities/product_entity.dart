import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'discount_entity.dart';
import 'review_entity.dart';
part 'product_entity.g.dart';

@HiveType(typeId: 1)
class ProductEntity extends Equatable {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String code;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final int expirationMonths;

  @HiveField(5)
  final bool isFeatured;

  @HiveField(6)
  final bool isOrganic;

  @HiveField(7)
  final DateTime addDate;

  @HiveField(8)
  final int unitCount;

  @HiveField(9)
  final num avgRating;

  @HiveField(10)
  final int reviewsCount;

  @HiveField(11)
  final int numberOfCalories;

  @HiveField(12)
  final List<ReviewEntity> reviews;

  @HiveField(13)
  final int sellingCount;

  @HiveField(14)
  final String? imageUrL;

  @HiveField(15)
  final String? imageFilePath;

  @HiveField(16)
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
