import 'package:flutter/material.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/models/product_model.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/widgets/custom_button.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/custom_cart_button.dart';
import 'package:fruits_hub/features/product_details/presentation/view/widgets/product_description_text.dart';
import 'package:fruits_hub/features/product_details/presentation/view/widgets/product_details_section.dart';
import 'package:fruits_hub/features/product_details/presentation/view/widgets/rate_and_review_text.dart';
import 'package:fruits_hub/features/product_details/presentation/view/widgets/rounded_box_with_list_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_item_cubit/cart_item_cubit.dart';

class ProductDetailsData extends StatefulWidget {
  const ProductDetailsData({super.key, required this.productModel});
  final ProductModel productModel;
  @override
  State<ProductDetailsData> createState() => _ProductDetailsDataState();
}

class _ProductDetailsDataState extends State<ProductDetailsData> {
  int counter = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductDetailsSection(
              onPressed: (count) {
                setState(() {
                  counter = count;
                });
              },
              price: widget.productModel.price.toInt(),
              name: widget.productModel.name,
              productModel: widget.productModel,
              initialCount: counter,
            ),
            RateAndReviewText(),
            ProductDescriptionText(
              description: widget.productModel.description,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RoundedBoxWithListTile(
                    title: 'عام',
                    subTitle: 'الصلاحية',
                    iconImage: Assets.imagesCalendar,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: RoundedBoxWithListTile(
                    title: "100%",
                    subTitle: "اورجانيك",
                    iconImage: Assets.imagesOrganic,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RoundedBoxWithListTile(
                    title: "${widget.productModel.numberOfCalories} كالوري",
                    subTitle: "100 جرام",
                    iconImage: Assets.imagesFire,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: RoundedBoxWithListTile(
                    title: "4.5",
                    ratingCount: "(256) ",
                    subTitle: "Reviews",
                    iconImage: Assets.imagesStar,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // CustomCartButton(),
            CustomButton(
              onPressed: () {
                context.read<CartCubit>().addCartItem(
                  widget.productModel.toEntity(),
                );
                showSuccessMessage(context);
              },
              text: "اضف إلى السلة",
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة ${widget.productModel.name} إلى السلة'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
