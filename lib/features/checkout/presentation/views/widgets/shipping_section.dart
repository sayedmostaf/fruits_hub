import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/shipping_item.dart';

class ShippingSection extends StatefulWidget {
  const ShippingSection({super.key});

  @override
  State<ShippingSection> createState() => _ShippingSectionState();
}

class _ShippingSectionState extends State<ShippingSection>
    with AutomaticKeepAliveClientMixin {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    final orderEntity = context.read<OrderEntity>();
    final cartTotal = orderEntity.cart.calculateTotalPrice();
    super.build(context);
    return Column(
      children: [
        SizedBox(height: 32),
        ShippingItem(
          title: AppStrings.payOnDelivery.tr(),
          subTitle: AppStrings.deliveryToPlace.tr(),
          price: cartTotal + 40,
          isSelected: selectedIndex == 0,
          onTap: () {
            setState(() {
              selectedIndex = 0;
              orderEntity.payWithCash = true;
            });
          },
        ),
        SizedBox(height: 8),
        ShippingItem(
          title: AppStrings.buyNowPayLater.tr(),
          subTitle: AppStrings.pleaseSelectPaymentMethod.tr(),
          price: cartTotal,
          isSelected: selectedIndex == 1,
          onTap: () {
            setState(() {
              selectedIndex = 1;
              orderEntity.payWithCash = false;
            });
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
