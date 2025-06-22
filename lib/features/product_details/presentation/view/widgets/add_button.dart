import 'package:flutter/material.dart';
import 'package:fruits_hub/core/models/product_model.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    super.key,
    this.onPressed,
    required this.productModel,
    required this.showMessage,
  });
  final void Function()? onPressed;
  final ProductModel productModel;
  final bool showMessage;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Color(0xFF1B5E37),
      child: IconButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
            if (showMessage) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "تمت إضافة ${productModel.name} إلى السلة",
                    style: const TextStyle(color: Colors.white),
                  ),
                  duration: const Duration(milliseconds: 500),
                ),
              );
            }
          }
        },
        icon: Icon(Icons.add, size: 22, color: Colors.white),
      ),
    );
  }
}
