import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
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
        return AspectRatio(
          aspectRatio: 163 / 214,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            elevation: 2,
            shadowColor: Theme.of(context).shadowColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              // TODO add product details screen
              onTap:
                  () => PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: Container(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: CachedNetworkImage(
                            imageUrl:
                                productEntity.imageUrL?.isNotEmpty == true
                                    ? productEntity.imageUrL!
                                    : '',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder:
                                (context, url) => Container(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surface.withOpacity(0.5),
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 40,
                                    ),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Icon(
                                  Icons.broken_image,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                productEntity.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.textStyle14w600.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${productEntity.price}',
                                        style: AppTextStyle.textStyle13w700
                                            .copyWith(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.secondary,
                                            ),
                                      ),
                                      TextSpan(
                                        text: ' / ${AppStrings.kilo.tr()}',
                                        style: AppTextStyle.textStyle13w600
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withOpacity(0.8),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: InkWell(
                      onTap: () {
                        favoritesCubit.toggleFavorite(context, productEntity);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
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
                                isFav
                                    ? Colors.red
                                    : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Material(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.9),
                      shape: const CircleBorder(),
                      elevation: 3,
                      shadowColor: Colors.black.withOpacity(0.15),
                      child: InkWell(
                        onTap: () {
                          context.read<CartCubit>().addCartItem(
                            product: productEntity,
                          );
                        },
                        customBorder: const CircleBorder(),
                        splashColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withOpacity(0.2),
                        highlightColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withOpacity(0.1),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.add,
                            size: 20,
                            color: Theme.of(context).colorScheme.onPrimary,
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
