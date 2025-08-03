import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CustomProgressHubWidget extends StatelessWidget {
  const CustomProgressHubWidget({
    super.key,
    required this.isLoading,
    required this.child,
    this.progressIndicatorColor,
    this.backgroundColor,
    this.opacity = 0.6,
  });
  final bool isLoading;
  final Widget child;
  final Color? progressIndicatorColor;
  final Color? backgroundColor;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      color: backgroundColor ?? Theme.of(context).colorScheme.background,
      opacity: opacity,
      progressIndicator: SizedBox(
        width: 60,
        height: 60,
        child: CircularProgressIndicator(
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(
            progressIndicatorColor ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      child: child,
    );
  }
}
