import 'package:fruits_hub/features/checkout/domain/entities/shipping_adress_entity.dart';
import 'package:fruits_hub/features/home/domain/entities/cart_entity.dart';

class OrderEntity {
  final String uID;
  final CartEntity cartEntity;
  bool? payWithCash;
  ShippingAddressEntity? shippingAddressEntity;
  OrderEntity(
    this.cartEntity, {
    this.payWithCash,
    required this.shippingAddressEntity,
    required this.uID,
  });

  double calculateShippingCost() {
    if (payWithCash!) {
      return 30;
    } else {
      return 0;
    }
  }

  double calculateShippingDiscount() {
    return 0;
  }

  double calculateTotalPriceAfterDiscountAndShipping() {
    return cartEntity.calculateTotalPrice() +
        calculateShippingCost() -
        calculateShippingDiscount();
  }
}
