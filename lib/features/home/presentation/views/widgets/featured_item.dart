import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/home/presentation/views/product_details_view.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/custom_featured_button.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_cubit.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class FeaturedItem extends StatelessWidget {
  const FeaturedItem({
    super.key,
    required this.width,
    required this.productEntity,
  });
  final double width;
  final ProductEntity productEntity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final height = width * 0.5; // Adjusted aspect ratio for modern look
    final hasDiscount = productEntity.discount != null;
    log('FeaturedItem: hasDiscount: $hasDiscount');
    final discountText =
        hasDiscount
            ? "${productEntity.discount!.percentage.toInt()}% ${AppStrings.discount.tr()}"
            : AppStrings.noDiscount.tr();

    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: ProductDetailsView(
            cartItemEntity: context.read<CartCubit>().cart.getCartItem(
              productEntity: productEntity,
            ),
          ),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            16,
          ), // Larger radius for modern look
          color: theme.colorScheme.surface,
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            isDarkMode
                                ? [
                                  Colors.black.withOpacity(0.3),
                                  theme.colorScheme.surface,
                                ]
                                : [
                                  Colors.white.withOpacity(0.2),
                                  theme.colorScheme.surface,
                                ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: productEntity.imageUrL ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorWidget:
                          (context, url, error) => Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 48,
                              color: theme.colorScheme.error,
                            ),
                          ),
                    ),
                  ),
                  if (hasDiscount)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${productEntity.discount!.percentage}% OFF',
                          style: AppTextStyle.textStyle14w700.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(20), // Increased padding
                color:
                    isDarkMode
                        ? theme.colorScheme.primaryContainer.withOpacity(0.9)
                        : theme.colorScheme.primaryContainer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productEntity.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.textStyle16w700.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        height: 1.1,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            hasDiscount
                                ? Colors.redAccent.withOpacity(0.15)
                                : theme.colorScheme.onSurface.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        discountText,
                        style: AppTextStyle.textStyle14w600.copyWith(
                          color:
                              hasDiscount
                                  ? Colors.redAccent
                                  : theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    CustomFeaturedButton(
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: ProductDetailsView(
                            cartItemEntity: context
                                .read<CartCubit>()
                                .cart
                                .getCartItem(productEntity: productEntity),
                          ),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
