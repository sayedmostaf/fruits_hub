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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1,
          color: Theme.of(context).dividerColor.withOpacity(0.3),
        ),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              title,
              const SizedBox(height: 4),
              Text(
                subTitle,
                style: AppTextStyle.textStyle13w600.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
          SvgPicture.asset(image, width: 32, height: 32),
        ],
      ),
    );
  }
}
