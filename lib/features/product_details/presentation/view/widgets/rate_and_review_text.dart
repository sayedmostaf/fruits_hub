import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class RateAndReviewText extends StatelessWidget {
  const RateAndReviewText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.star,
              color: Color(0xFF60D290),
              size: 25,
              shadows: [Shadow(color: Color(0xFF98E77E), blurRadius: 20)],
            ),
            Text("4.5", style: TextStyles.semiBold13),
            Text(
              "(30+)",
              style: TextStyles.regular13.copyWith(color: Color(0xFF949D9E)),
            ),
            Text(
              'المراجعه',
              style: TextStyles.bold13.copyWith(
                color: Color(0xFF1B5E37),
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
