import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class ActiveTagWidget extends StatelessWidget {
  const ActiveTagWidget({
    super.key,
    required this.activeTagIcon,
    required this.title,
    this.maxWidth = 100,
  });
  final String activeTagIcon, title;
  final double maxWidth;
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceVariant = Theme.of(context).colorScheme.surfaceVariant;
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: ShapeDecoration(
        color: surfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: ShapeDecoration(
              color: primaryColor,
              shape: OvalBorder(),
            ),
            child: Center(
              child: SvgPicture.asset(activeTagIcon, width: 12, height: 12),
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              title,
              style: AppTextStyle.textStyle11w600.copyWith(color: primaryColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
