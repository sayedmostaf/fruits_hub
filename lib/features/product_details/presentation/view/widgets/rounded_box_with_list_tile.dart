import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class RoundedBoxWithListTile extends StatelessWidget {
  const RoundedBoxWithListTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.iconImage,
    this.ratingCount = '',
  });
  final String title, subTitle, iconImage, ratingCount;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FA),
        borderRadius: BorderRadius.circular(16),

        border: Border.all(width: 0.2, color: const Color(0xFF949D9E)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: ratingCount,
                style: TextStyles.semiBold11.copyWith(color: Color(0xFF949D9E)),
              ),
              TextSpan(
                text: title,
                style: TextStyles.bold16.copyWith(
                  color: Color(0xFF60D290),
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyles.semiBold13.copyWith(color: Color(0xFF949D9E)),
        ),
        trailing: SvgPicture.asset(iconImage, width: 32, height: 32),
      ),
    );
  }
}
