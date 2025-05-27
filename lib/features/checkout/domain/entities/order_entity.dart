import 'package:fruits_hub/features/checkout/domain/entities/shipping_adress_entity.dart';
import 'package:fruits_hub/features/home/domain/entities/cart_entity.dart';

class OrderEntity {
  final CartEntity cartEntity;
  bool? payWithCash;
   ShippingAddressEntity? shippingAddressEntity;
  OrderEntity(this.cartEntity, {this.payWithCash, this.shippingAddressEntity});
}
