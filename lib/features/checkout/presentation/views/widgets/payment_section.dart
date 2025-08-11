// payment_section.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/order_payment_item.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/payment_item.dart';
import 'package:provider/provider.dart';

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text(
            AppStrings.orderSummary.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          OrderPaymentItem(),
          const SizedBox(height: 16),
          PaymentItem(
            title: AppStrings.shippingAddress.tr(),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: SvgPicture.asset(
                        Assets.imagesLocation,
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
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
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap:
                          () => pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AppStrings.edit.tr(),
                              style: AppTextStyle.textStyle13w600.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
