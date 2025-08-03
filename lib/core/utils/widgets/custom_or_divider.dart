import 'package:flutter/material.dart';

class CustomOrDivider extends StatelessWidget {
  const CustomOrDivider({
    super.key,
    this.color,
    this.thickness = 1,
    this.text = 'أو',
  });
  final Color? color;
  final double thickness;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = color ?? theme.dividerColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Divider(color: dividerColor, thickness: thickness, height: thickness),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
