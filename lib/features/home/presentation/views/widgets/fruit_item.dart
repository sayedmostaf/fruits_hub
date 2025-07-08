import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/models/product_model.dart';
import 'package:fruits_hub/core/utils/app_colors.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/widgets/custom_network_image.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruits_hub/features/product_details/presentation/view/product_details_view.dart';
import 'package:fruits_hub/core/models/review_model.dart';
import 'package:fruits_hub/features/favorite/presentation/manager/cubit/favorite_cubit.dart';
import 'package:get_it/get_it.dart';

class FruitItem extends StatefulWidget {
  const FruitItem({super.key, required this.productEntity});
  final ProductEntity productEntity;

  @override
  State<FruitItem> createState() => _FruitItemState();
}

class _FruitItemState extends State<FruitItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<FavoriteCubit>().isFavorite(
      productCode: widget.productEntity.code,
    );

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap:
                () => Navigator.pushNamed(
                  context,
                  ProductDetailsView.routeName,
                  arguments: ProductModel(
                    name: widget.productEntity.name,
                    code: widget.productEntity.code,
                    description: widget.productEntity.description,
                    price: widget.productEntity.price,
                    isFeatured: widget.productEntity.isFeatured,
                    imageUrl: widget.productEntity.imageUrl,
                    expirationsMonths: widget.productEntity.expirationsMonths,
                    isOrganic: widget.productEntity.isOrganic,
                    numberOfCalories: widget.productEntity.numberOfCalories,
                    avgRating: widget.productEntity.avgRating,
                    unitAmount: widget.productEntity.unitAmount,
                    sellingCount: 0,
                    reviews:
                        widget.productEntity.reviews
                            .map((e) => ReviewModel.fromEntity(e))
                            .toList(),
                  ),
                ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Main content
                  Positioned.fill(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Image section with gradient overlay
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFFF8F9FA),
                                  const Color(0xFFF3F5F7),
                                ],
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child:
                                  widget.productEntity.imageUrl != null
                                      ? CustomNetworkImage(
                                        imageUrl:
                                            widget.productEntity.imageUrl!,
                                      )
                                      : Container(
                                        color: Colors.grey.shade200,
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 48,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                            ),
                          ),
                        ),

                        // Content section
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product name
                                Text(
                                  widget.productEntity.name,
                                  textAlign: TextAlign.right,
                                  style: TextStyles.semiBold16.copyWith(
                                    color: const Color(0xFF1A1A1A),
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),

                                // Rating stars (if available)
                                if (widget.productEntity.avgRating > 0)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.productEntity.avgRating
                                            .toStringAsFixed(1),
                                        style: TextStyles.regular13.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      ...List.generate(5, (index) {
                                        return Icon(
                                          index <
                                                  widget.productEntity.avgRating
                                                      .floor()
                                              ? Icons.star
                                              : Icons.star_border,
                                          size: 12,
                                          color: const Color(0xFFFFB800),
                                        );
                                      }),
                                    ],
                                  ),

                                const Spacer(),

                                // Price and add button row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Price
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${widget.productEntity.price}',
                                                style: TextStyles.bold16
                                                    .copyWith(
                                                      color:
                                                          AppColors
                                                              .secondaryColor,
                                                      fontSize: 18,
                                                    ),
                                              ),
                                              TextSpan(
                                                text: ' جنية',
                                                style: TextStyles.semiBold13
                                                    .copyWith(
                                                      color:
                                                          AppColors
                                                              .secondaryColor,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          'كيلو',
                                          style: TextStyles.regular13.copyWith(
                                            color:
                                                AppColors.lightSecondaryColor,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),

                                    // Add to cart button
                                    GestureDetector(
                                      onTap: () {
                                        context.read<CartCubit>().addCartItem(
                                          widget.productEntity,
                                        );
                                        // Add haptic feedback
                                        HapticFeedback.lightImpact();
                                      },
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.primaryColor,
                                              AppColors.primaryColor
                                                  .withOpacity(0.8),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 20,
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
                  ),

                  // Favorite button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        final cubit = context.read<FavoriteCubit>();
                        if (isFavorite) {
                          cubit.removeFromFavorites(
                            productCode: widget.productEntity.code,
                          );
                        } else {
                          cubit.addToFavorites(product: widget.productEntity);
                        }
                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            key: ValueKey(isFavorite),
                            color:
                                isFavorite ? Colors.red : Colors.grey.shade600,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Organic badge (if applicable)
                  if (widget.productEntity.isOrganic)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'عضوي',
                          style: TextStyles.bold13.copyWith(
                            color: Colors.white,
                            fontSize: 10,
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
