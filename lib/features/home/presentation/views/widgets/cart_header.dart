import 'package:flutter/material.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: Color(0xFFEBF9F1)),
      child: Center(
        child: Text(
          'لديك 3 منتجات في سله التسوق',
          style: TextStyle(
            color: Color(0xFF1B5E37),
            fontSize: 13,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w400,
            height: 0.12,
          ),
        ),
      ),
    );
  }
}
