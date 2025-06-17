import 'package:fruits_hub/core/helper_functions/get_currency.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:fruits_hub/features/checkout/domain/entities/paypal_payment_entitiy/details_entity.dart';

class Amount {
  String? total, currency;
  DetailsEntity? details;
  Amount({this.total, this.currency, this.details});

  factory Amount.fromEntity(OrderEntity entity) {
    return Amount(
      total: entity.calculateTotalPriceAfterDiscountAndShipping().toString(),
      currency: getCurrency(),
      details: DetailsEntity.fromEntity(entity),
    );
  }
}
