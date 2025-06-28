import 'package:flutter/material.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/fruit_item.dart';

class ProductLeverGridView extends StatelessWidget {
  const ProductLeverGridView({
    super.key,
    required this.len,
    required this.products,
  });
  final int len;
  final List<ProductEntity> products;
  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 147 / 181,
      ),
      itemBuilder: (context, index) {
        return FruitItem(productEntity: products[index]);
      },
      itemCount: len,
    );
  }
}
