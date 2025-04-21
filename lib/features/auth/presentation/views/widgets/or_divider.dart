import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFDCDEDE))),
        SizedBox(width: 18),
        Text('أو', style: TextStyles.semiBold13, textAlign: TextAlign.center),
        SizedBox(width: 18),
        Expanded(child: Divider(color: Color(0xFFDCDEDE))),
      ],
    );
  }
}
