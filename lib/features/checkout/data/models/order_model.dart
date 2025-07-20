import 'package:fruits_hub/features/checkout/data/models/order_product_model.dart';
import 'package:fruits_hub/features/checkout/data/models/shipping_address_model.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';

class OrderModel {
  final num? totalPrice;
  final String? uid;
  final ShippingAddressModel? shippingAddressModel;
  final List<OrderProductModel>? orderProducts;
  final String? paymentMethod;
  OrderModel({
    required this.totalPrice,
    required this.uid,
    required this.shippingAddressModel,
    required this.orderProducts,
    required this.paymentMethod,
  });

  factory OrderModel.fromEntity({required OrderEntity orderEntity}) {
    return OrderModel(
      totalPrice: orderEntity.cart.calculateTotalPrice(),
      uid: orderEntity.uid,
      shippingAddressModel: ShippingAddressModel.fromEntity(
        orderEntity.shippingAddressEntity,
      ),
      orderProducts:
          orderEntity.cart.cartItems
              .map((e) => OrderProductModel.fromCartItemEntity(cartItem: e))
              .toList(),
      paymentMethod: orderEntity.payWithCash! ? 'Cash' : 'Paypal',
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      totalPrice: json['totalPrice'],
      uid: json['uid'],
      paymentMethod: json['paymentMethod'],
      shippingAddressModel:
          json['shippingAddressModel'] != null
              ? ShippingAddressModel.fromJson(json['shippingAddressModel'])
              : null,
      orderProducts:
          json['orderProducts'] != null
              ? List<OrderProductModel>.from(
                json['orderProducts'].map(
                  (item) => OrderProductModel.fromJson(item),
                ),
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPrice': totalPrice,
      'uid': uid,
      'status': 'pending',
      'paymentMethod': paymentMethod,
      'date': DateTime.now().toString(),
      'shippingAddressModel': shippingAddressModel?.toJson(),
      'orderProducts': orderProducts?.map((item) => item.toJson()).toList(),
    };
  }
}
