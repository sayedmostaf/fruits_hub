// shipping_section.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/shipping_item.dart';
import 'package:provider/provider.dart';

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
    final theme = Theme.of(context);
    
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            AppStrings.selectPaymentMethod.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.choosePaymentOption.tr(),
            style: AppTextStyle.textStyle13w400.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 12),
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
          const SizedBox(height: 8),
          if (selectedIndex == -1)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                AppStrings.pleaseSelectPaymentMethod.tr(),
                style: AppTextStyle.textStyle13w400.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}