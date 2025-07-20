import 'package:fruits_hub/core/functions/get_currency.dart';
import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_item_entity.dart';

class ItemModel {
  int? quantity;
  String? price, name, currency;
  ItemModel({this.quantity, this.price, this.name, this.currency});

  factory ItemModel.fromEntity({required CartItemEntity cartItemEntity}) {
    return ItemModel(
      currency: getCurrency(),
      price: cartItemEntity.productEntity.price.toString(),
      name: cartItemEntity.productEntity.name,
      quantity: cartItemEntity.count,
    );
  }

  Map<dynamic, dynamic> toJson() => {
    "quantity": quantity,
    "price": price,
    "name": name,
    "currency": currency,
  };
}
