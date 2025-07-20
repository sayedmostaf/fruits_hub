import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class InActiveStepItem extends StatelessWidget {
  const InActiveStepItem({super.key, required this.text, required this.index});
  final String text;
  final int index;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            index.toString(),
            style: AppTextStyle.textStyle13w600.copyWith(
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyle.textStyle13w600.copyWith(
            color: theme.hintColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
