import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/order_payment_item.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/payment_item.dart';

class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final order = context.read<OrderEntity>();

    final address = order.shippingAddressEntity;
    final String fullAddress =
        '${address.fullName}, ${address.address}, ${address.city}, ${address.phone}';
    return Column(
      children: [
        OrderPaymentItem(),
        PaymentItem(
          title: AppStrings.confirmOrderMsg.tr(),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 8),
                  SvgPicture.asset(
                    Assets.imagesLocation,
                    colorFilter: ColorFilter.mode(
                      theme.iconTheme.color ?? Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      fullAddress,
                      style: AppTextStyle.textStyle13w700.copyWith(
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap:
                        () => pageController.animateToPage(
                          1,
                          duration: Duration(milliseconds: 250),
                          curve: Curves.bounceInOut,
                        ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit,
                          size: 13,
                          color: theme.iconTheme.color?.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppStrings.edit.tr(),
                          style: AppTextStyle.textStyle13w600.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
