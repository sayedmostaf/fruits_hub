import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/utils/app_colors.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;

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
                      // Product Image Sliver with improved design
                      SliverAppBar(
                        expandedHeight: screenWidth * 0.9,
                        collapsedHeight: 80,
                        pinned: true,
                        backgroundColor: theme.colorScheme.surface,
                        elevation: 0,
                        leading: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: theme.colorScheme.primary,
                              size: 24,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Hero image with better shadow and border
                              Hero(
                                tag: 'product-${productEntity.code}',
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.primaryGreen
                                            .withOpacity(0.2),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CachedNetworkImage(
                                      imageUrl: productEntity.imageUrL ?? '',
                                      width: screenWidth * 0.7,
                                      height: screenWidth * 0.7,
                                      fit: BoxFit.cover,
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Product Details Sliver with improved spacing
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and price section with better layout
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
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.secondary
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${productEntity.price} ',
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
                              const SizedBox(height: 24),

                              // Rating Row with improved visual hierarchy
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceVariant
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.colorScheme.outline
                                        .withOpacity(0.1),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Rating badge with improved design
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
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
                                          const SizedBox(width: 6),
                                          Text(
                                            avgRating.toStringAsFixed(1),
                                            style: AppTextStyle.textStyle14w600
                                                .copyWith(
                                                  color:
                                                      theme.colorScheme.primary,
                                                  fontWeight: FontWeight.w700,
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
                                    // Reviews button with icon
                                    TextButton.icon(
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
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        foregroundColor:
                                            theme.colorScheme.primary,
                                      ),
                                      icon: Icon(
                                        Icons.reviews_outlined,
                                        size: 18,
                                        color: theme.colorScheme.primary,
                                      ),
                                      label: Text(
                                        AppStrings.showAllReviews.tr(),
                                        style: AppTextStyle.textStyle14w600
                                            .copyWith(
                                              color: theme.colorScheme.primary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Description section with better typography
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.description_outlined,
                                        size: 20,
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.8),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        AppStrings.description.tr(),
                                        style: AppTextStyle.textStyle16w700
                                            .copyWith(
                                              color: theme.colorScheme.primary,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceVariant
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      productEntity.description,
                                      style: AppTextStyle.textStyle14w400
                                          .copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.8),
                                            height: 1.6,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),

                      // Product Info Grid using CustomProductDetailsBox
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              subTitle: AppStrings.grams.tr(),
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
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: screenWidth < 400 ? 1.6 : 1.8,
                              ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                ),

                // Add to Cart Button with floating effect
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 24,
                  child: SafeArea(
                    child: Container(
                      child: CustomButton(
                        text: AppStrings.addToCart.tr(),
                        onPressed:
                            () => context.read<CartCubit>().addCartItem(
                              product: productEntity,
                            ),
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
