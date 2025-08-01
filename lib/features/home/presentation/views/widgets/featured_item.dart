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
    final height = width * 158 / 342;

    final hasDiscount = productEntity.discount != null;
    log('FeaturedItem: hasDiscount: $hasDiscount');
    final discountText =
        hasDiscount
            ? "${productEntity.discount!.percentage.toInt()}% ${AppStrings.discount.tr()}"
            : AppStrings.noDiscount.tr();
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: CachedNetworkImage(
              imageUrl: productEntity.imageUrL ?? '',
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Icon(Icons.broken_image),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              color: theme.colorScheme.primaryContainer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Opacity(
                    opacity: 0.8,
                    child: Text(
                      productEntity.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.textStyle16w400.copyWith(
                        color: theme.colorScheme.onPrimary,
                        height: 1.6,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    discountText,
                    style: AppTextStyle.textStyle18w700.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 8),

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
    );
  }
}
