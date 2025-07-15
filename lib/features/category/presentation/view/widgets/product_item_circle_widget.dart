import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/product_details/presentation/view/product_details_view.dart';

class ProductItemCircleWidget extends StatelessWidget {
  const ProductItemCircleWidget({super.key, required this.productEntity});
  final ProductEntity productEntity;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ProductDetailsView.routeName,
          arguments: productEntity,
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35,
            child:
                productEntity.imageUrl != null
                    ? CachedNetworkImage(
                      imageUrl: productEntity.imageUrl!,
                      height: 45,
                    )
                    : Icon(
                      Icons.image_not_supported_outlined,
                      size: 45,
                      color: Colors.grey.shade400,
                    ),
          ),
          Text(productEntity.name, style: TextStyles.semiBold13),
        ],
      ),
    );
  }
}
