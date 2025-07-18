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
      padding: EdgeInsets.only(top: 12, left: 16, right: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(width: 1, color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  Text(
                    subTitle,
                    style: AppTextStyle.textStyle13w600.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16),
              SvgPicture.asset(
                image,
                theme: const SvgTheme(currentColor: Colors.tealAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
