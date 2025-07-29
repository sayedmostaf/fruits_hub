import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/services/app_locator.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/product_details_view_body.dart';
import 'package:fruits_hub/features/reviews/domain/repos/reviews_repo.dart';
import 'package:fruits_hub/features/reviews/presentation/managers/reviews_cubit.dart';
import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_item_entity.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key, required this.cartItemEntity});
  final CartItemEntity cartItemEntity;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create:
              (_) => ReviewsCubit(
                reviewsRepo: getIt.get<ReviewsRepo>(),
                productCode: cartItemEntity.productEntity.code,
              ),
          child: ProductDetailsViewBody(
            productEntity: cartItemEntity.productEntity,
          ),
        ),
      ),
    );
  }
}
