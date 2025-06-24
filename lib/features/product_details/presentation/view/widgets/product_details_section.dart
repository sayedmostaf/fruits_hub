import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/models/product_model.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/cart_item_action_buttons.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_item_cubit/cart_item_cubit.dart';

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
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyles.bold19,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.price} جنية',
                        style: TextStyles.bold16.copyWith(
                          color: Color(0xFFF4A91F),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '/ الكيلو',
                        style: TextStyles.semiBold13.copyWith(
                          color: Color(0xFFF8C76D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Quantity Selector
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: SizedBox(
                height: 40,
                width: 100,
                child: BlocProvider(
                  create: (_) => CartItemCubit(),
                  child: CartItemActionButtons(
                    cartItemEntity: context
                        .read<CartCubit>()
                        .cartEntity
                        .getCartItem(widget.productModel.toEntity()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
