import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class CustomProductDetailsBox extends StatelessWidget {
  const CustomProductDetailsBox({
    super.key,
    required this.image,
    required this.subTitle,
    required this.title,
  });
  final String image, subTitle;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(15), // Increased padding for better spacing
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          20,
        ), // Larger radius for modern look
        border: Border.all(
          width: 1,
          color:
              isDarkMode
                  ? theme.colorScheme.outline.withOpacity(0.2)
                  : theme.colorScheme.outline.withOpacity(0.1),
        ),
        color: theme.colorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                title,
                const SizedBox(height: 6), // Slightly increased spacing
                Text(
                  subTitle,
                  style: AppTextStyle.textStyle13w600.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12), // Add spacing between content and icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(image, width: 24, height: 24),
          ),
        ],
      ),
    );
  }
}
