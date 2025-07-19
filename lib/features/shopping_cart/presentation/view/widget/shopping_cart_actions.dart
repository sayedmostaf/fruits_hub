import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_item_entity.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_cubit.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/view/widget/shopping_cart_action_button.dart';
import 'package:provider/provider.dart';

class ShoppingCartActions extends StatelessWidget {
  const ShoppingCartActions({super.key, required this.cartItemEntity});
  final CartItemEntity cartItemEntity;
  @override
  Widget build(BuildContext context) {
    final product = cartItemEntity.productEntity;
    final count = cartItemEntity.count;
    return Row(
      children: [
        ShoppingCartActionButton(
          icon: Icons.add,
          onPressed: () {
            context.read<CartCubit>().addCartItem(product: product);
          },
          iconColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$count',
            style: AppTextStyle.textStyle16w700.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ShoppingCartActionButton(
          icon: Icons.remove,
          onPressed: () {
            if (count > 1) {
              context.read<CartCubit>().updateItemCount(
                product: product,
                newCount: count - 1,
              );
            } else {
              context.read<CartCubit>().removeCartItem(
                cartItem: cartItemEntity,
              );
            }
          },
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.1),
        ),
      ],
    );
  }
}
