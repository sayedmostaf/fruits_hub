import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/payment_item.dart';

class ShippingAddressWidget extends StatelessWidget {
  const ShippingAddressWidget({super.key, required this.pageController});
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return PaymentItem(
      title: 'عنوان التوصيل',
      child: Row(
        children: [
          SvgPicture.asset(Assets.imagesLocation),
          SizedBox(width: 8),
          Text(
            '${context.read<OrderEntity>().shippingAddressEntity}',
            textAlign: TextAlign.right,
            style: TextStyles.regular13.copyWith(color: Color(0xFF4E5556)),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              pageController.animateToPage(
                1,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            child: SizedBox(
              child: Row(
                children: [
                  SvgPicture.asset(Assets.imagesEdit),
                  SizedBox(width: 4),
                  Text(
                    'تعديل',
                    style: TextStyles.semiBold13.copyWith(
                      color: Color(0xFF949D9E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
