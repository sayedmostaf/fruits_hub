import 'package:flutter/material.dart';

class CustomLoadingError extends StatelessWidget {
  const CustomLoadingError({
    super.key,
    required this.errMessage,
    this.iconSize = 40,
  });
  final String errMessage;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: iconSize,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              errMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide(color: Theme.of(context).colorScheme.error),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
