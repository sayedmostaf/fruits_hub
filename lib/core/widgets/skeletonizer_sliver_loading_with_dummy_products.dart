import 'package:flutter/widgets.dart';
import 'package:fruits_hub/core/helper_functions/get_dummy_product.dart';
import 'package:fruits_hub/core/widgets/product_lever_grid_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerSliverLoadingWithDummyProducts extends StatelessWidget {
  const SkeletonizerSliverLoadingWithDummyProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.sliver(
      enabled: true,
      child: ProductLeverGridView(
        len: getDummyProducts().length,
        products: getDummyProducts(),
      ),
    );
  }
}
