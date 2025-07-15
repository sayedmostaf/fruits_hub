import 'package:flutter/material.dart';

class CustomSectionHeader extends StatelessWidget {
  const CustomSectionHeader({
    super.key,
    required this.title,
    required this.subTitle,
    required this.count,
    required this.onTap,
  });
  final String title, subTitle;
  final int count;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 12,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            child: Text(
              '$count',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            splashColor: theme.colorScheme.primary.withOpacity(0.2),
            highlightColor: theme.colorScheme.primary.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 200),
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
                child: Text(subTitle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
