import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_item_entity.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_cubit.dart';
import 'package:provider/provider.dart';

class ShoppingCartActions extends StatelessWidget {
  const ShoppingCartActions({super.key, required this.cartItemEntity});
  final CartItemEntity cartItemEntity;

  @override
  Widget build(BuildContext context) {
    final product = cartItemEntity.productEntity;
    final count = cartItemEntity.count;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionButton(
            context: context,
            icon: Icons.remove_rounded,
            onPressed: () {
              HapticFeedback.lightImpact();
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
            backgroundColor:
                count > 1
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : theme.colorScheme.error.withOpacity(0.1),
            iconColor:
                count > 1 ? theme.colorScheme.primary : theme.colorScheme.error,
          ),
          Container(
            width: 50,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                '$count',
                key: ValueKey(count),
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle16w700.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          _buildActionButton(
            context: context,
            icon: Icons.add_rounded,
            onPressed: () {
              HapticFeedback.lightImpact();
              context.read<CartCubit>().addCartItem(product: product);
            },
            backgroundColor: theme.colorScheme.primary,
            iconColor: theme.colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          child: Icon(icon, color: iconColor, size: 16),
        ),
      ),
    );
  }
}
