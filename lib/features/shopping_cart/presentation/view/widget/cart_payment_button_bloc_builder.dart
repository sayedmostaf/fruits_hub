import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/functions/build_error_snack_bar.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
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
    final theme = Theme.of(context);

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  cartEntity.cartItems.isNotEmpty
                      ? [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withOpacity(0.8),
                      ]
                      : [
                        theme.colorScheme.outline.withOpacity(0.3),
                        theme.colorScheme.outline.withOpacity(0.2),
                      ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow:
                cartEntity.cartItems.isNotEmpty
                    ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ]
                    : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap:
                  cartEntity.cartItems.isNotEmpty
                      ? () {
                        HapticFeedback.mediumImpact();
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: CheckoutView(cart: cartEntity),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      }
                      : () {
                        HapticFeedback.lightImpact();
                        buildErrorSnackBar(
                          context,
                          message: AppStrings.emptyCartMessage,
                        );
                      },
              child: Container(
                height: 56,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        cartEntity.cartItems.isNotEmpty
                            ? Icons.payment_rounded
                            : Icons.shopping_cart_outlined,
                        color:
                            cartEntity.cartItems.isNotEmpty
                                ? Colors.white
                                : theme.colorScheme.outline,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: Text(
                          cartEntity.cartItems.isNotEmpty
                              ? '${AppStrings.payTotal.tr()} ${totalPrice.toStringAsFixed(2)}'
                              : AppStrings.cartEmpty.tr(),
                          key: ValueKey(cartEntity.cartItems.isNotEmpty),
                          style: TextStyle(
                            color:
                                cartEntity.cartItems.isNotEmpty
                                    ? Colors.white
                                    : theme.colorScheme.outline,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
