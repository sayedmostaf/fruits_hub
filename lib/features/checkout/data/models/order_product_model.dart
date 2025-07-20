import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_item_entity.dart';

class OrderProductModel {
  final String name;
  final String code;
  final String? imageUrl;
  final num price;
  final int count;

  const OrderProductModel({
    required this.name,
    required this.code,
    required this.imageUrl,
    required this.price,
    required this.count,
  });

  factory OrderProductModel.fromCartItemEntity({
    required CartItemEntity cartItem,
  }) {
    return OrderProductModel(
      name: cartItem.productEntity.name,
      price: cartItem.productEntity.price,
      count: cartItem.count,
      imageUrl: cartItem.productEntity.imageUrL,
      code: cartItem.productEntity.code,
    );
  }

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      name: json['name'],
      code: json['code'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'imageUrl': imageUrl,
      'price': price,
      'count': count,
    };
  }
}
