import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/address_input_section.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/payment_section.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/shipping_section.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/custom_scroll_behavior.dart';

class CheckoutStepsPageView extends StatelessWidget {
  const CheckoutStepsPageView({
    super.key,
    required this.formKey,
    required this.pageController,
    required this.valueListenable,
  });
  final GlobalKey<FormState> formKey;
  final PageController pageController;
  final ValueListenable<AutovalidateMode> valueListenable;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: PageView.builder(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: getCheckoutStepsWidget().length,
        itemBuilder: (context, index) {
          return getCheckoutStepsWidget()[index];
        },
      ),
    );
  }

  List<Widget> getCheckoutStepsWidget() {
    return [
      ShippingSection(),
      AddressInputSection(formKey: formKey, valueListenable: valueListenable),
      PaymentSection(pageController: pageController),
    ];
  }
}
