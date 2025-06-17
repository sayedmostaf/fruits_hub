import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';

class DetailsEntity {
  String? subTotal, shipping;
  double? shippingDiscount;
  DetailsEntity({this.subTotal, this.shipping, this.shippingDiscount});
  Map<String, dynamic> toJson() => {
    'subtotal': subTotal,
    'shipping': shipping,
    'shipping_discount': shippingDiscount,
  };

  factory DetailsEntity.fromEntity(OrderEntity entity) => DetailsEntity(
    subTotal: entity.cartEntity.calculateTotalPrice().toString(),
    shipping: entity.calculateShippingCost().toString(),
    shippingDiscount: entity.calculateShippingDiscount(),
  );
}
