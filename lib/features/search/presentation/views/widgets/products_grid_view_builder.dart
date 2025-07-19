import 'package:flutter/material.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/fruit_item.dart';

class ProductsGridViewBuilder extends StatelessWidget {
  const ProductsGridViewBuilder({super.key, required this.productsEntities});
  final List<ProductEntity> productsEntities;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: productsEntities.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 8,
        childAspectRatio: 163 / 214,
      ),
      itemBuilder: (context, index) {
        return FruitItem(productEntity: productsEntities[index]);
      },
    );
  }
}
