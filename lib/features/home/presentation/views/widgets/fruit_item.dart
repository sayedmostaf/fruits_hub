import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/home/presentation/views/product_details_view.dart';
import 'package:fruits_hub/features/settings/presentation/managers/favorites/favorites_cubit.dart';
import 'package:fruits_hub/features/settings/presentation/managers/favorites/favorites_state.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_cubit.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class FruitItem extends StatelessWidget {
  const FruitItem({super.key, required this.productEntity});
  final ProductEntity productEntity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final favoritesCubit = context.read<FavoritesCubit>();
        final isFav = favoritesCubit.isFavorite(productEntity);
        final theme = Theme.of(context);

        return AspectRatio(
          aspectRatio: 163 / 230, // Slightly taller
          child: Material(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            elevation: 1,
            shadowColor: Colors.black.withOpacity(0.1),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap:
                  () => PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: ProductDetailsView(
                      cartItemEntity: context
                          .read<CartCubit>()
                          .cart
                          .getCartItem(productEntity: productEntity),
                    ),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 6,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Container(
                            color: theme.colorScheme.surface.withOpacity(0.3),
                            child: CachedNetworkImage(
                              imageUrl:
                                  productEntity.imageUrL?.isNotEmpty == true
                                      ? productEntity.imageUrL!
                                      : '',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder:
                                  (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      color: theme.colorScheme.primary,
                                      strokeWidth: 2,
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => Icon(
                                    Icons.broken_image,
                                    color: theme.colorScheme.error,
                                    size: 40,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productEntity.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.textStyle14w600.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${productEntity.price}',
                                          style: AppTextStyle.textStyle16w700
                                              .copyWith(
                                                color:
                                                    theme.colorScheme.secondary,
                                              ),
                                        ),
                                        TextSpan(
                                          text: ' / ${AppStrings.kilo.tr()}',
                                          style: AppTextStyle.textStyle13w600
                                              .copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .secondary
                                                    .withOpacity(0.8),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        context.read<CartCubit>().addCartItem(
                                          product: productEntity,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: theme.colorScheme.onPrimary,
                                        size: 20,
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      style: IconButton.styleFrom(
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        favoritesCubit.toggleFavorite(context, productEntity);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: Icon(
                            key: ValueKey<bool>(isFav),
                            isFav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 20,
                            color:
                                isFav ? Colors.red : theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
