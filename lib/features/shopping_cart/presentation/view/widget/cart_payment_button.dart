import 'package:flutter/material.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/view/widget/cart_payment_button_bloc_builder.dart';

class CartPaymentButton extends StatelessWidget {
  const CartPaymentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CartPaymentButtonBlocBuilder();
  }
}
