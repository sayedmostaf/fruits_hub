import 'package:flutter/material.dart';

class CustomOrDivider extends StatelessWidget {
  const CustomOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFDCDEDE), thickness: 1)),
        SizedBox(width: 18),
        Text(
          'أو',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF0C0D0D),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 18),
        Expanded(child: Divider(color: Color(0xFFDCDEDE), thickness: 1)),
      ],
    );
  }
}
