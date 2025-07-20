import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class ActiveStepItem extends StatelessWidget {
  const ActiveStepItem({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greenColor = theme.colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 23,
          height: 23,
          decoration: BoxDecoration(color: greenColor, shape: BoxShape.circle),
          child: Center(
            child: Icon(Icons.check, color: Colors.white, size: 16),
          ),
        ),
        SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyle.textStyle13w700.copyWith(color: greenColor),
        ),
      ],
    );
  }
}
