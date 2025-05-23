import 'package:flutter/widgets.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/checkout_steps.dart';

class CheckoutViewBody extends StatelessWidget {
  const CheckoutViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [SizedBox(height: 20), CheckoutSteps()]),
    );
  }
}
