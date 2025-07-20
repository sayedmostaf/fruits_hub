import 'package:flutter/material.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/checkout_steps_selector.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/checkout_view_body.dart';

class CheckoutSteps extends StatelessWidget {
  const CheckoutSteps({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.onTap,
  });
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(getCheckoutStepsText().length, (index) {
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(index),
            child: CheckoutStepsSelector(
              text: getCheckoutStepsText()[index],
              index: index + 1,
              isActive: index <= currentPage,
            ),
          ),
        );
      }),
    );
  }
}
