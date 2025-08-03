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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                WidgetSpan(
                  child: Transform.translate(
                    offset: const Offset(0, -4),
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$count',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    subTitle,
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
