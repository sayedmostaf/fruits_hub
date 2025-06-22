import 'package:flutter/material.dart';
import 'package:fruits_hub/core/models/product_model.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/cart_item_action_buttons.dart';
import 'package:fruits_hub/features/product_details/presentation/view/widgets/add_button.dart';
import 'package:fruits_hub/features/product_details/presentation/view/widgets/remove_button.dart';

class ProductDetailsSection extends StatefulWidget {
  const ProductDetailsSection({
    super.key,
    required this.onPressed,
    required this.price,
    required this.name,
    required this.productModel,
    required this.initialCount,
  });
  final void Function(int value) onPressed;
  final int price;
  final String name;
  final ProductModel productModel;
  final int initialCount;
  @override
  State<ProductDetailsSection> createState() => _ProductDetailsSectionState();
}

class _ProductDetailsSectionState extends State<ProductDetailsSection> {
  late int count;
  @override
  void initState() {
    super.initState();
    count = widget.initialCount;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        widget.name,
        textAlign: TextAlign.right,
        style: TextStyles.bold16.copyWith(height: 2),
      ),
      subtitle: Text.rich(
        textAlign: TextAlign.right,
        TextSpan(
          children: [
            TextSpan(
              text: '${widget.price}جنية ',
              style: TextStyles.bold13.copyWith(color: Color(0xFFF4A91F)),
            ),
            TextSpan(
              text: '/ الكيلو ',
              style: TextStyles.semiBold13.copyWith(color: Color(0xFFF8C76D)),
            ),
          ],
        ),
      ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          AddButton(
            productModel: widget.productModel,
            onPressed: () {
              setState(() {
                count++;
              });
              widget.onPressed(count);
            },
            showMessage: false,
          ),
          SizedBox(width: 16),
          Text(count.toString(), style: TextStyles.bold16),
          SizedBox(width: 16),
          RemoveButton(
            onPressed: () {
              setState(() {
                if (count > 1) {
                  count--;
                }
              });
              widget.onPressed(count);
            },
          ),
        ],
      ),
    );
  }
}
