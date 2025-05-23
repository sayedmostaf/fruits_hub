import 'package:flutter/material.dart';
import 'package:fruits_hub/core/widgets/custom_button.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/cart_header.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/cart_items_list.dart';
import '../../../../../constants.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: kTopPadding),
                  buildAppBar(context, title: 'السلة', showNotification: false),
                  const SizedBox(height: 16),
                  const CartHeader(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: CustomDivider()),
            const CartItemsList(cartItems: []),
            const SliverToBoxAdapter(child: CustomDivider()),
          ],
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: MediaQuery.sizeOf(context).height * .07,
          child: CustomButton(onPressed: () {}, text: 'الدفع  120جنيه'),
        ),
      ],
    );
  }
}
