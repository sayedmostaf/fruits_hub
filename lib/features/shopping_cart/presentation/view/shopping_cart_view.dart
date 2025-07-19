import 'package:flutter/material.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/view/widget/shopping_cart_view_body.dart';

class ShoppingCartView extends StatelessWidget {
  const ShoppingCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ShoppingCartViewBody());
  }
}
