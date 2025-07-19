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
      buildWhen: (previous, current) {
        if (current is CartItemUpdatedState) {
          if (current.targetCartItem == cartItemEntity) {
            return true;
          }
        }
        return false;
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.15),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 73,
                height: 92,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: cartItemEntity.productEntity.imageUrL ?? "",
                      width: 53,
                      height: 40,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            width: 53,
                            height: 40,
                            color: theme.colorScheme.surface,
                          ),
                      errorWidget:
                          (context, error, stackTrace) =>
                              Icon(Icons.error, color: theme.colorScheme.error),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          cartItemEntity.productEntity.name,
                          style: AppTextStyle.textStyle13w700.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Spacer(),
                        Material(
                          color: theme.colorScheme.surface.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap:
                                () => context.read<CartCubit>().removeCartItem(
                                  cartItem: cartItemEntity,
                                ),
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: SvgPicture.asset(
                                Assets.imagesTrash,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${cartItemEntity.calculateTotalUnit() ?? 'N/A'} كم',
                      style: AppTextStyle.textStyle13w400.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ShoppingCartActions(cartItemEntity: cartItemEntity),
                        const Spacer(),
                        Text(
                          '${(cartItemEntity.calculateTotalPrice() ?? 0).toStringAsFixed(2)} جنيه',
                          style: AppTextStyle.textStyle16w700.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
