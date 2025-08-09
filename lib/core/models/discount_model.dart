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
      percentage: _parseDouble(json[FirebaseFields.discountPercentage]),
      createdAt: _parseTimestamp(json[FirebaseFields.discountCreatedAt]),
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

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
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
