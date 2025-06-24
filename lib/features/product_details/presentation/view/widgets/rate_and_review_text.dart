import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';

class RateAndReviewText extends StatelessWidget {
  const RateAndReviewText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    Assets.imagesStar,
                    width: 18,
                    height: 18,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'التقييم والمراجعات',
                    style: TextStyles.bold13.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.star,
                  color: Color(0xFF60D290),
                  size: 22,
                  shadows: [Shadow(color: Color(0xFF98E77E), blurRadius: 12)],
                ),
                const SizedBox(width: 6),
                Text(
                  "4.5",
                  style: TextStyles.bold16.copyWith(color: Color(0xFF60D290)),
                ),
                const SizedBox(width: 8),
                Text(
                  "(30+)",
                  style: TextStyles.semiBold13.copyWith(
                    color: Color(0xFF949D9E),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'المراجعه',
                  style: TextStyles.bold13.copyWith(
                    color: Color(0xFF1B5E37),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
