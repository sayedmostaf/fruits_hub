import 'package:fruits_hub/features/checkout/domain/entities/shipping_address_entity.dart';
import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_entity.dart';

class OrderEntity {
  final CartEntity cart;
  final String uid;
  bool? payWithCash;
  ShippingAddressEntity shippingAddressEntity = ShippingAddressEntity();
  OrderEntity({required this.cart, required this.uid, this.payWithCash});

  num calculateShippingCost() {
    if (payWithCash!) {
      return 30;
    } else {
      return 0;
    }
  }

  num calculateShippingDiscount() {
    return 0;
  }

  num calculateTotalPriceAfterShipping() {
    return cart.calculateTotalPrice() +
        calculateShippingCost() -
        calculateShippingDiscount();
  }
}
