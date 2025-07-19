import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/custom_scroll_behavior.dart';
import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_item_entity.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_cubit.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/view/widget/build_cart_app_bar.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/view/widget/cart_item_sliver_list_view.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/view/widget/cart_payment_button.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/view/widget/shopping_cart_view_header.dart';

class ShoppingCartViewBody extends StatelessWidget {
  const ShoppingCartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CartItemEntity> cartItems =
        context.watch<CartCubit>().cart.cartItems;
    return Stack(
      children: [
        Positioned(
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      buildCartAppBar(context),
                      SizedBox(height: 16),
                      ShoppingCartViewHeader(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                CartItemSliverListView(cartItems: cartItems),
                SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).size.height * 0.067,
          child: CartPaymentButton(),
        ),
      ],
    );
  }
}
