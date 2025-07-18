import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruits_hub/core/entities/discount_entity.dart';
import 'package:fruits_hub/core/utils/firebase_fields.dart';

class DiscountModel extends DiscountEntity {
  const DiscountModel({
    required super.percentage,
    required super.createdAt,
    required super.productCode,
    super.note,
    super.readBy,
  });

  factory DiscountModel.fromEntity(DiscountEntity entity) {
    return DiscountModel(
      percentage: entity.percentage,
      createdAt: entity.createdAt,
      productCode: entity.productCode,
      note: entity.note,
      readBy: entity.readBy,
    );
  }

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      percentage: (json[FirebaseFields.discountPercentage] as num).toDouble(),
      createdAt: (json[FirebaseFields.discountCreatedAt] as Timestamp).toDate(),
      note: json[FirebaseFields.discountNote] as String?,
      productCode: json[FirebaseFields.productCode] ?? '',
      readBy: List<String>.from(json[FirebaseFields.readBy] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      FirebaseFields.discountPercentage: percentage,
      FirebaseFields.discountCreatedAt: Timestamp.fromDate(createdAt),
      FirebaseFields.discountNote: note,
      FirebaseFields.productCode: productCode,
      FirebaseFields.readBy: readBy,
    };
  }

  @override
  DiscountModel copyWith({
    double? percentage,
    DateTime? createdAt,
    String? note,
    String? productCode,
    List<String>? readBy,
  }) {
    return DiscountModel(
      percentage: percentage ?? this.percentage,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
      productCode: productCode ?? this.productCode,
      readBy: readBy ?? this.readBy,
    );
  }

  DiscountEntity toEntity() {
    return DiscountEntity(
      percentage: percentage,
      createdAt: createdAt,
      productCode: productCode,
      note: note,
      readBy: readBy,
    );
  }
}
