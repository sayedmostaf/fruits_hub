import 'package:fruits_hub/core/functions/get_currency.dart';
import 'package:fruits_hub/features/checkout/data/models/paypal/details_model.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';

class AmountModel {
  String? total, currency;
  DetailsModel? details;
  AmountModel({this.total, this.currency, this.details});
  factory AmountModel.fromEntity({required OrderEntity orderEntity}) {
    return AmountModel(
      currency: getCurrency(),
      details: DetailsModel.fromEntity(orderEntity: orderEntity),
      total: orderEntity.calculateTotalPriceAfterShipping().toString(),
    );
  }

  Map<dynamic, dynamic> toJson() => {
    "total": total,
    "currency": currency,
    "details": details?.toJson(),
  };
}
