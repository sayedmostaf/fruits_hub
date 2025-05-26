import 'package:fruits_hub/features/checkout/domain/entities/shipping_adress_entity.dart';
import 'package:fruits_hub/features/home/domain/entities/cart_item_entity.dart';

class OrderEntity {
  final List<CartItemEntity> cartItems;
  final bool payWithCash;
  final ShippingAddressEntity shippingAddressEntity;

  OrderEntity({
    required this.cartItems,
    required this.payWithCash,
    required this.shippingAddressEntity,
  });
}
