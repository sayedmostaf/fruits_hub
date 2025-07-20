import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';

class DetailsModel {
  String? shipping;
  int? shippingDiscount;
  String? subtotal;
  DetailsModel({this.shipping, this.shippingDiscount, this.subtotal});
  factory DetailsModel.fromEntity({required OrderEntity orderEntity}) {
    return DetailsModel(
      subtotal: orderEntity.cart.calculateTotalPrice().toString(),
      shipping: orderEntity.calculateShippingCost().toString(),
      shippingDiscount: orderEntity.calculateShippingDiscount().toInt(),
    );
  }

  Map<dynamic, dynamic> toJson() => {
    "shipping": shipping,
    "shipping_discount": shippingDiscount,
    "subtotal": subtotal,
  };
}
