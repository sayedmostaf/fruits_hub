import 'package:flutter/material.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/fruit_item.dart';

class ProductSliverGridViewBuilder extends StatelessWidget {
  const ProductSliverGridViewBuilder({
    super.key,
    required this.productEntities,
  });
  final List<ProductEntity> productEntities;
  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: productEntities.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 8,
        childAspectRatio: 163 / 214,
      ),
      itemBuilder: (context, index) {
        return FruitItem(productEntity: productEntities[index]);
      },
    );
  }
}
