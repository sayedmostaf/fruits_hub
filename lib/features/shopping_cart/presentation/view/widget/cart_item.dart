import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_item_entity.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_cubit.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart_item/cart_item_cubit.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart_item/cart_item_state.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/view/widget/shopping_cart_actions.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.cartItemEntity});
  final CartItemEntity cartItemEntity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CartItemCubit, CartItemState>(
      buildWhen:
          (previous, current) =>
              current is CartItemUpdatedState &&
              current.targetCartItem == cartItemEntity,
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _showItemDetails(context),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    _buildImage(theme),
                    const SizedBox(width: 12),
                    Expanded(child: _buildDetails(theme, context)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage(ThemeData theme) {
    return Hero(
      tag: 'product_${cartItemEntity.productEntity.name}',
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: cartItemEntity.productEntity.imageUrL ?? "",
            fit: BoxFit.cover,
            placeholder:
                (context, url) => Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
            errorWidget:
                (context, error, stackTrace) => Icon(
                  Icons.image_not_supported_rounded,
                  color: theme.colorScheme.error,
                  size: 24,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetails(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                cartItemEntity.productEntity.name,
                style: AppTextStyle.textStyle13w700.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            _buildRemoveButton(theme, context),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${cartItemEntity.calculateTotalUnit() ?? 'N/A'} كم',
            style: AppTextStyle.textStyle13w400.copyWith(
              color: theme.colorScheme.secondary,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ShoppingCartActions(cartItemEntity: cartItemEntity),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${(cartItemEntity.calculateTotalPrice() ?? 0).toStringAsFixed(2)} جنيه',
                style: AppTextStyle.textStyle14w700.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRemoveButton(ThemeData theme, BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showRemoveDialog(context),
          child: Center(
            child: SvgPicture.asset(
              Assets.imagesTrash,
              width: 16,
              height: 16,
              color: theme.colorScheme.error,
            ),
          ),
        ),
      ),
    );
  }

  void _showItemDetails(BuildContext context) {
    // Add item details modal or navigation
  }

  void _showRemoveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text('Remove Item'),
            content: const Text(
              'Are you sure you want to remove this item from your cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<CartCubit>().removeCartItem(
                    cartItem: cartItemEntity,
                  );
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Remove'),
              ),
            ],
          ),
    );
  }
}
