import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/functions/build_error_snack_bar.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/widgets/custom_button.dart';
import 'package:fruits_hub/features/checkout/presentation/views/checkout_view.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_cubit.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_state.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class CartPaymentButtonBlocBuilder extends StatelessWidget {
  const CartPaymentButtonBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final cartEntity = context.watch<CartCubit>().cart;
    final totalPrice = cartEntity.calculateTotalPrice();
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return CustomButton(
          text: '${AppStrings.payTotal.tr()} ${totalPrice.toStringAsFixed(2)}',
          onPressed: () {
            if (cartEntity.cartItems.isNotEmpty) {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: CheckoutView(cart: cartEntity),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            } else {
              buildErrorSnackBar(context, message: AppStrings.emptyCartMessage);
            }
          },
        );
      },
    );
  }
}
