import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/payment_item.dart';
import 'package:provider/provider.dart';

class OrderPaymentItem extends StatelessWidget {
  const OrderPaymentItem({super.key});

  @override
  Widget build(BuildContext context) {
    final order = context.read<OrderEntity>();
    final theme = Theme.of(context);
    final total = order.cart.calculateTotalPrice();
    const deliveryFee = 40;
    return PaymentItem(
      title: AppStrings.orderSummary.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppStrings.subtotal.tr(),
                style: AppTextStyle.textStyle13w400.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
              Spacer(),
              Text(
                '$total ${AppStrings.currency.tr()}',
                style: AppTextStyle.textStyle16w600.copyWith(
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                AppStrings.deliveryFee.tr(),
                style: AppTextStyle.textStyle13w400.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
              const Spacer(),
              Text(
                '$deliveryFee ${AppStrings.currency.tr()}',
                style: AppTextStyle.textStyle13w600.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(thickness: 0.5, color: theme.dividerColor),
          Row(
            children: [
              Text(
                AppStrings.total.tr(),
                style: AppTextStyle.textStyle16w700.copyWith(
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const Spacer(),
              Text(
                '${total + deliveryFee} ${AppStrings.currency.tr()}',
                style: AppTextStyle.textStyle16w700.copyWith(
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
