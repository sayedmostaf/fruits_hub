import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fruits_hub/core/entities/discount_entity.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class DiscountNotificationCard extends StatelessWidget {
  const DiscountNotificationCard({
    super.key,
    required this.discount,
    required this.relativeTime,
    this.onSwiped,
  });
  final DiscountEntity discount;
  final String relativeTime;
  final VoidCallback? onSwiped;
  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final secondaryColor = Theme.of(context).textTheme.bodySmall?.color;
    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: Colors.green.shade600,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Dismissible(
        key: ValueKey(
          discount.productCode + discount.createdAt.toIso8601String(),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          if (onSwiped != null) onSwiped!();
        },
        background: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.mark_email_read_rounded,
                color: Colors.white,
                size: 26,
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.markedAsRead.tr(),
                style: AppTextStyle.textStyle14w700.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).cardColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.discount_outlined,
                color: Colors.green,
                size: 36,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      discount.note ?? AppStrings.noNote.tr(),
                      style: AppTextStyle.textStyle16w700.copyWith(
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppStrings.discount.tr()}: ${discount.percentage.toStringAsFixed(0)}%',
                      style: AppTextStyle.textStyle14w400.copyWith(
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '📅  ${AppStrings.date.tr()}: $relativeTime',
                      style: AppTextStyle.textStyle12w400.copyWith(
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
