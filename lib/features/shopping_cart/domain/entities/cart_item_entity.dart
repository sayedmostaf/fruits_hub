import 'package:equatable/equatable.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';

class CartItemEntity extends Equatable {
  final ProductEntity productEntity;
  final int count;
  const CartItemEntity({required this.productEntity, this.count = 0});

  num calculateTotalPrice() => (productEntity.price) * (count);
  num calculateTotalUnit() => (productEntity.unitCount) * (count);

  CartItemEntity copyWith({int? count}) {
    return CartItemEntity(
      productEntity: productEntity,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [productEntity];
}
