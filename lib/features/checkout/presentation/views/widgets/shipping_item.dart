// shipping_item.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
            width: isSelected ? 1.5 : 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            isSelected
                ? const ActiveShippingItemDot()
                : const InActiveShippingItemDot(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.textStyle14w700.copyWith(
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
              '$price ${AppStrings.currency.tr()}',
              style: AppTextStyle.textStyle14w700.copyWith(
                color:
                    isSelected
                        ? theme.colorScheme.primary
                        : theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
