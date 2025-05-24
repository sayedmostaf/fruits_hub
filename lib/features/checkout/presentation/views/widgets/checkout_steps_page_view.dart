import 'package:flutter/widgets.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/shipping_section.dart';

class CheckoutStepsPageView extends StatelessWidget {
  const CheckoutStepsPageView({super.key, required this.pageController});
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: PageView.builder(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: getSteps().length,
        itemBuilder: (context, index) {
          return getSteps()[index];
        },
      ),
    );
  }

  List<Widget> getSteps() {
    return [ShippingSection(), SizedBox(), SizedBox(), SizedBox()];
  }
}
