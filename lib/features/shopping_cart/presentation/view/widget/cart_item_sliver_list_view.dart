import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_item_entity.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/view/widget/cart_item.dart';

class CartItemSliverListView extends StatelessWidget {
  const CartItemSliverListView({super.key, required this.cartItems});
  final List<CartItemEntity> cartItems;
  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            AppStrings.cartEmpty.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyle.textStyle16w400.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverList.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CartItem(cartItemEntity: cartItems[index]),
          );
        },
      ),
    );
  }
}
