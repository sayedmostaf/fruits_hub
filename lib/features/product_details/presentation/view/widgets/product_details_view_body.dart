import 'package:flutter/material.dart';
import 'package:fruits_hub/core/models/product_model.dart';
import 'package:fruits_hub/features/product_details/presentation/view/widgets/half_eclipse_background.dart';
import 'package:fruits_hub/features/product_details/presentation/view/widgets/product_details_data.dart';

class ProductDetailsViewBody extends StatelessWidget {
  const ProductDetailsViewBody({super.key, required this.productModel});
  final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HalfEclipseBackground(imageUrl: productModel.imageUrl ?? ''),
          ProductDetailsData(productModel: productModel),
        ],
      ),
    );
  }
}
