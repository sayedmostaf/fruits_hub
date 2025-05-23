import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_colors.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class ActiveStepItem extends StatelessWidget {
  const ActiveStepItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 11.5,
          backgroundColor: AppColors.primaryColor,
          child: Icon(Icons.check, size: 18, color: Colors.white),
        ),
        SizedBox(width: 4),
        Text(
          'الشحن',
          style: TextStyles.bold13.copyWith(color: AppColors.primaryColor),
        ),
      ],
    );
  }
}
