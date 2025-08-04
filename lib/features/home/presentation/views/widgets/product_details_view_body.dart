import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/widgets/custom_button.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/custom_product_details_box.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/custom_scroll_behavior.dart';
import 'package:fruits_hub/features/reviews/presentation/managers/reviews_cubit.dart';
import 'package:fruits_hub/features/reviews/presentation/managers/reviews_state.dart';
import 'package:fruits_hub/features/reviews/presentation/views/reviews_view.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_cubit.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_state.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart_item/cart_item_cubit.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart_item/cart_item_state.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/view/widget/shopping_cart_actions.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class ProductDetailsViewBody extends StatelessWidget {
  const ProductDetailsViewBody({super.key, required this.productEntity});
  final ProductEntity productEntity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return MultiBlocListener(
      listeners: [
        BlocListener<CartItemCubit, CartItemState>(
          listener: (context, state) {},
        ),
        BlocListener<ReviewsCubit, ReviewsState>(listener: (context, state) {}),
      ],
      child: BlocBuilder<CartItemCubit, CartItemState>(
        builder: (context, cartItemState) {
          final reviewsState = context.watch<ReviewsCubit>().state;
          double avgRating = productEntity.avgRating.toDouble();
          int reviewsCount = productEntity.reviewsCount;

          if (reviewsState is ReviewsSuccessState) {
            avgRating = reviewsState.averageRating.toDouble();
            reviewsCount = reviewsState.reviewsCount;
          }

          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            body: Stack(
              children: [
                ScrollConfiguration(
                  behavior: const CustomScrollBehavior(),
                  child: CustomScrollView(
                    slivers: [
                      // Product Image Sliver
                      SliverAppBar(
                        expandedHeight: 280,
                        collapsedHeight: 80,
                        pinned: true,
                        backgroundColor: theme.colorScheme.surface,
                        elevation: 0,
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: theme.colorScheme.surface
                                .withOpacity(0.8),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: theme.colorScheme.primary,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.imagesProductDetailsBackground,
                                color: theme.colorScheme.surface,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              Hero(
                                tag: 'product-${productEntity.code}',
                                child: CachedNetworkImage(
                                  imageUrl: productEntity.imageUrL ?? '',
                                  width: 240,
                                  height: 200,
                                  fit: BoxFit.contain,
                                  placeholder:
                                      (context, url) => Center(
                                        child: CircularProgressIndicator(
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => Icon(
                                        Icons.error,
                                        color: theme.colorScheme.error,
                                        size: 40,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Product Details Sliver
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productEntity.name,
                                          style: AppTextStyle.textStyle23w700
                                              .copyWith(
                                                color:
                                                    theme.colorScheme.primary,
                                                height: 1.3,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '${productEntity.price} ',
                                                style: AppTextStyle
                                                    .textStyle18w700
                                                    .copyWith(
                                                      color:
                                                          theme
                                                              .colorScheme
                                                              .secondary,
                                                    ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${AppStrings.currency.tr()} / ${AppStrings.kilo.tr()}',
                                                style: AppTextStyle
                                                    .textStyle14w600
                                                    .copyWith(
                                                      color:
                                                          theme
                                                              .colorScheme
                                                              .tertiary,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  BlocBuilder<CartCubit, CartState>(
                                    builder: (context, state) {
                                      final cartItem = context
                                          .read<CartCubit>()
                                          .cart
                                          .getCartItem(
                                            productEntity: productEntity,
                                          );
                                      return ShoppingCartActions(
                                        cartItemEntity: cartItem,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Rating Row
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.secondary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          Assets.imagesStar,
                                          width: 16,
                                          height: 16,
                                          color: theme.colorScheme.secondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          avgRating.toStringAsFixed(1),
                                          style: AppTextStyle.textStyle14w600
                                              .copyWith(
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '($reviewsCount)',
                                          style: AppTextStyle.textStyle14w400
                                              .copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.6),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () async {
                                      context
                                          .read<ReviewsCubit>()
                                          .fetchLatestReviews();
                                      await PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: ReviewsView(
                                          productEntity: productEntity,
                                        ),
                                        withNavBar: false,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      AppStrings.review.tr(),
                                      style: AppTextStyle.textStyle14w600
                                          .copyWith(
                                            color: theme.colorScheme.primary,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Description
                              Text(
                                'description'.tr(),
                                style: AppTextStyle.textStyle16w700.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                productEntity.description,
                                style: AppTextStyle.textStyle14w400.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),

                      // Product Info Grid
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverGrid(
                          delegate: SliverChildListDelegate([
                            CustomProductDetailsBox(
                              image: Assets.imagesCalendar,
                              title: Text(
                                AppStrings.general.tr(),
                                style: AppTextStyle.textStyle16w700.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              subTitle: AppStrings.validity.tr(),
                            ),
                            CustomProductDetailsBox(
                              image: Assets.imagesCalendar,
                              title: Text(
                                productEntity.isOrganic ? '100%' : '50%',
                                style: AppTextStyle.textStyle16w700.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              subTitle: AppStrings.organic.tr(),
                            ),
                            CustomProductDetailsBox(
                              image: Assets.imagesOrganic,
                              title: Text(
                                '${productEntity.numberOfCalories}',
                                style: AppTextStyle.textStyle16w700.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              subTitle: '100 ${AppStrings.grams.tr()}',
                            ),
                            CustomProductDetailsBox(
                              image: Assets.imagesReviewStar,
                              title: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: avgRating.toStringAsFixed(1),
                                      style: AppTextStyle.textStyle16w700
                                          .copyWith(
                                            color: theme.colorScheme.primary,
                                          ),
                                    ),
                                    TextSpan(
                                      text: ' ($reviewsCount)',
                                      style: AppTextStyle.textStyle12w500
                                          .copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.6),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              subTitle: AppStrings.reviews.tr(),
                            ),
                          ]),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 1.8,
                              ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                ),

                // Add to Cart Button
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: SafeArea(
                    child: CustomButton(
                      text: AppStrings.addToCart.tr(),
                      onPressed:
                          () => context.read<CartCubit>().addCartItem(
                            product: productEntity,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
