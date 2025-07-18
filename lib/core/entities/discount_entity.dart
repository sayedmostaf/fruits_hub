import 'package:equatable/equatable.dart';

class DiscountEntity extends Equatable {
  final double percentage;
  final String? note;
  final DateTime createdAt;
  final String productCode;
  final List<String> readBy;
  const DiscountEntity({
    required this.percentage,
    required this.createdAt,
    required this.productCode,
    this.note,
    this.readBy = const [],
  });

  DiscountEntity copyWith({
    double? percentage,
    String? note,
    DateTime? createdAt,
    String? productCode,
    List<String>? readBy,
  }) {
    return DiscountEntity(
      percentage: percentage ?? this.percentage,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      productCode: productCode ?? this.productCode,
      readBy: readBy ?? this.readBy,
    );
  }

  @override
  List<Object?> get props => [percentage, note, createdAt, productCode, readBy];
}
