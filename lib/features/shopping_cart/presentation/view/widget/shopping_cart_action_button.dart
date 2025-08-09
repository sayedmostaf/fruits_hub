import 'package:flutter/material.dart';

class ShoppingCartActionButton extends StatelessWidget {
  const ShoppingCartActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.iconColor,
    required this.backgroundColor,
  });
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor, backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      child: FittedBox(
        child: IconButton(
          onPressed: onPressed,
          icon: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: iconColor, size: 30),
          ),
        ),
      ),
    );
  }
}
