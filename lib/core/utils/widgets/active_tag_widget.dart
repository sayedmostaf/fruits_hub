import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class ActiveTagWidget extends StatelessWidget {
  const ActiveTagWidget({
    super.key,
    required this.activeTagIcon,
    required this.title,
    this.maxWidth = 100,
    this.elevation = 2,
  });
  final String activeTagIcon, title;
  final double maxWidth;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceVariant = Theme.of(context).colorScheme.surfaceVariant;

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: surfaceVariant,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                activeTagIcon,
                width: 12,
                height: 12,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              title.tr(),
              style: AppTextStyle.textStyle11w600.copyWith(
                color: primaryColor,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
