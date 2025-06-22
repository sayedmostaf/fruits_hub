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
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.2, color: Color(0xFF949D9E)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: ratingCount,
                style: TextStyles.semiBold11.copyWith(color: Color(0xFF949D9E)),
              ),
              TextSpan(
                text: title,
                style: TextStyles.bold13.copyWith(
                  color: Color(0xFF60D290),
                  height: 2,
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyles.semiBold13.copyWith(color: Color(0xFF949D9E)),
        ),
        trailing: SvgPicture.asset(iconImage),
      ),
    );
  }
}
