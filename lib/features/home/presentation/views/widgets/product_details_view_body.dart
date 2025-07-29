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
          return Stack(
            children: [
              ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.imagesProductDetailsBackground,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              CachedNetworkImage(
                                imageUrl: productEntity.imageUrL ?? '',
                                width: 221,
                                height: 167,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Container(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      child: Center(
                                        child: Icon(
                                          Icons.image,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => Icon(
                                      Icons.error,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      productEntity.name,
                                      style: AppTextStyle.textStyle16w700
                                          .copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                          ),
                                    ),
                                    Spacer(),
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
                                SizedBox(height: 4),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${productEntity.price}جنية ',
                                        style: AppTextStyle.textStyle13w700
                                            .copyWith(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.secondary,
                                            ),
                                      ),
                                      TextSpan(
                                        text: '/',
                                        style: AppTextStyle.textStyle13w700
                                            .copyWith(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.tertiary,
                                            ),
                                      ),
                                      const TextSpan(text: ' '),
                                      TextSpan(
                                        text: AppStrings.kilo.tr(),
                                        style: AppTextStyle.textStyle13w600
                                            .copyWith(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.tertiary,
                                            ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      Assets.imagesStar,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                    ),
                                    Text(
                                      avgRating.toStringAsFixed(1),
                                      style: AppTextStyle.textStyle13w600
                                          .copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                          ),
                                    ),
                                    const SizedBox(width: 9),
                                    Text(
                                      '($reviewsCount+)',
                                      style: AppTextStyle.textStyle13w600
                                          .copyWith(
                                            color: Theme.of(context).hintColor,
                                          ),
                                    ),
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
                                      child: Text(
                                        AppStrings.review.tr(),
                                        style: AppTextStyle.textStyle13w700
                                            .copyWith(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  productEntity.description,
                                  style: AppTextStyle.textStyle13w400.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        delegate: SliverChildListDelegate([
                          CustomProductDetailsBox(
                            image: Assets.imagesCalendar,
                            title: Text(
                              AppStrings.general.tr(),
                              style: AppTextStyle.textStyle16w700.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            subTitle: AppStrings.validity.tr(),
                          ),
                          CustomProductDetailsBox(
                            image: Assets.imagesCalendar,
                            title: Text(
                              productEntity.isOrganic ? '100%' : '50%',
                              style: AppTextStyle.textStyle16w700.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            subTitle: AppStrings.organic.tr(),
                          ),
                          CustomProductDetailsBox(
                            image: Assets.imagesOrganic,
                            title: Text(
                              '${productEntity.numberOfCalories} ${AppStrings.calories.tr()}',
                              style: AppTextStyle.textStyle16w700.copyWith(
                                color: Theme.of(context).colorScheme.primary,
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
                                    text: ' $avgRating',
                                    style: AppTextStyle.textStyle16w700
                                        .copyWith(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        ),
                                  ),
                                  TextSpan(
                                    text: ' (',
                                    style: AppTextStyle.textStyle12w500
                                        .copyWith(
                                          color: Theme.of(context).hintColor,
                                        ),
                                  ),
                                  TextSpan(
                                    text: '$reviewsCount',
                                    style: AppTextStyle.textStyle13w600
                                        .copyWith(
                                          color: Theme.of(context).hintColor,
                                        ),
                                  ),
                                  TextSpan(
                                    text: ')',
                                    style: AppTextStyle.textStyle12w500
                                        .copyWith(
                                          color: Theme.of(context).hintColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            subTitle: AppStrings.reviews.tr(),
                          ),
                        ]),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 163 / 80,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 122)),
                  ],
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).size.height * 0.067,
                child: CustomButton(
                  onPressed:
                      () => context.read<CartCubit>().addCartItem(
                        product: productEntity,
                      ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
