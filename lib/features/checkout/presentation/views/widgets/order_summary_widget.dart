import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/payment_item.dart';
import 'package:provider/provider.dart';

class OrderSummaryWidget extends StatelessWidget {
  const OrderSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PaymentItem(
      title: 'ملخص الطلب',
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'المجموع الفرعي :',
                style: TextStyles.regular13.copyWith(
                  color: const Color(0xFF4E5556),
                ),
              ),
              Spacer(),
              Text(
                '${context.read<OrderEntity>().cartEntity.calculateTotalPrice()} جنيه',
                style: TextStyles.semiBold16,
                textAlign: TextAlign.right,
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                'التوصيل  :',
                style: TextStyles.regular13.copyWith(
                  color: const Color(0xFF4E5556),
                ),
              ),
              Spacer(),
              Text(
                '30 جنيه',
                style: TextStyles.regular13.copyWith(
                  color: const Color(0xFF4E5556),
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          SizedBox(height: 9),
          Divider(thickness: 0.5, color: Color(0xFFCACECE)),
          SizedBox(height: 9),
          Row(
            children: [
              Text('الكلي', style: TextStyles.bold16),
              Spacer(),
              Text(
                '${context.read<OrderEntity>().cartEntity.calculateTotalPrice() + 30} جنيه',
                style: TextStyles.bold16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
