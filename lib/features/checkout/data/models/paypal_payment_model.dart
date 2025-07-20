import 'dart:convert';
import 'package:fruits_hub/features/checkout/data/models/paypal/amount_model.dart';
import 'package:fruits_hub/features/checkout/data/models/paypal/item_list_model.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';

String paypalPaymentToJson(PaypalPaymentModel? data) =>
    json.encode(data?.toJson());

class PaypalPaymentModel {
  AmountModel? amount;
  ItemListModel? itemsList;
  String? description;
  PaypalPaymentModel({this.amount, this.itemsList, this.description});
  factory PaypalPaymentModel.fromEntity({required OrderEntity orderEntity}) {
    return PaypalPaymentModel(
      amount: AmountModel.fromEntity(orderEntity: orderEntity),
      description: 'Paypal Payment Description',
      itemsList: ItemListModel.fromEntity(
        cartItemsEntities: orderEntity.cart.cartItems,
      ),
    );
  }

  Map<dynamic, dynamic> toJson() => {
    "amount": amount?.toJson(),
    "item_list": itemsList?.toJson(),
    "description": description,
  };
}
