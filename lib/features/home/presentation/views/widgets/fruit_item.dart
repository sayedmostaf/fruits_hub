import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/models/product_model.dart';
import 'package:fruits_hub/core/utils/app_colors.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/widgets/custom_network_image.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruits_hub/features/product_details/presentation/view/product_details_view.dart';
import 'package:fruits_hub/core/models/review_model.dart';

class FruitItem extends StatelessWidget {
  const FruitItem({super.key, required this.productEntity});
  final ProductEntity productEntity;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.pushNamed(
            context,
            ProductDetailsView.routeName,
            arguments: ProductModel(
              name: productEntity.name,
              code: productEntity.code,
              description: productEntity.description,
              price: productEntity.price,
              isFeatured: productEntity.isFeatured,
              imageUrl: productEntity.imageUrl,
              expirationsMonths: productEntity.expirationsMonths,
              isOrganic: productEntity.isOrganic,
              numberOfCalories: productEntity.numberOfCalories,
              avgRating: productEntity.avgRating,
              unitAmount: productEntity.unitAmount,
              sellingCount: 0,
              reviews:
                  productEntity.reviews
                      .map((e) => ReviewModel.fromEntity(e))
                      .toList(),
            ),
          ),
      child: Container(
        decoration: ShapeDecoration(
          color: Color(0xFFF3F5F7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite_outline),
              ),
            ),
            Positioned.fill(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  productEntity.imageUrl != null
                      ? Flexible(
                        child: CustomNetworkImage(
                          imageUrl: productEntity.imageUrl!,
                        ),
                      )
                      : Container(color: Colors.grey, height: 100, width: 100),
                  ListTile(
                    title: Text(
                      productEntity.name,
                      textAlign: TextAlign.right,
                      style: TextStyles.semiBold16,
                    ),
                    subtitle: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${productEntity.price}جنية ',
                            style: TextStyles.bold13.copyWith(
                              color: AppColors.secondaryColor,
                            ),
                          ),
                          TextSpan(
                            text: '/',
                            style: TextStyles.bold13.copyWith(
                              color: AppColors.lightSecondaryColor,
                            ),
                          ),
                          TextSpan(
                            text: ' ',
                            style: TextStyles.semiBold13.copyWith(
                              color: AppColors.secondaryColor,
                            ),
                          ),
                          TextSpan(
                            text: 'كيلو',
                            style: TextStyles.semiBold13.copyWith(
                              color: AppColors.lightSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.right,
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        context.read<CartCubit>().addCartItem(productEntity);
                      },
                      child: CircleAvatar(
                        backgroundColor: AppColors.primaryColor,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
