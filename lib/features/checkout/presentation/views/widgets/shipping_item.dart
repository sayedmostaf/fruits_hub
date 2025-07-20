import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/active_shipping_item_dot.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/in_active_shipping_item_dot.dart';

class ShippingItem extends StatelessWidget {
  const ShippingItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  final String title, subTitle;
  final num price;
  final bool isSelected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: ShapeDecoration(
          color: theme.cardColor.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              color:
                  isSelected ? theme.colorScheme.primary : Colors.transparent,
              width: 1.2,
            ),
          ),
        ),
        child: Row(
          children: [
            isSelected
                ? const ActiveShippingItemDot()
                : const InActiveShippingItemDot(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.textStyle13w600.copyWith(
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subTitle,
                    style: AppTextStyle.textStyle13w400.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$price جنيه',
              style: AppTextStyle.textStyle13w700.copyWith(
                color:
                    isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
