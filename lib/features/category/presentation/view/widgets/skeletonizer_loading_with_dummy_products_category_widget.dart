import 'package:flutter/material.dart';
import 'package:fruits_hub/core/helper_functions/get_dummy_product.dart';
import 'package:fruits_hub/features/category/presentation/view/widgets/list_view_builder_horizontal_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerLoadingWithDummyProductsCategoryWidget
    extends StatelessWidget {
  const SkeletonizerLoadingWithDummyProductsCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListViewBuilderHorizontalWidget(products: getDummyProducts()),
    );
  }
}
