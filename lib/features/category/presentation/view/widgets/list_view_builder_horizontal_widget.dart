import 'package:flutter/widgets.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/features/category/presentation/view/widgets/product_item_circle_widget.dart';

class ListViewBuilderHorizontalWidget extends StatelessWidget {
  const ListViewBuilderHorizontalWidget({super.key, required this.products});
  final List<ProductEntity> products;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        padding: EdgeInsets.all(0),
        itemBuilder:
            (context, index) => Padding(
              padding: EdgeInsets.only(left: 15),
              child: ProductItemCircleWidget(productEntity: products[index]),
            ),
      ),
    );
  }
}
