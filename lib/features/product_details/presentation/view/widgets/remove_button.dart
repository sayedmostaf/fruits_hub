import 'package:flutter/material.dart';

class RemoveButton extends StatelessWidget {
  const RemoveButton({super.key, this.onPressed});
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Color(0xFF2D9F5D),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(Icons.remove_rounded, size: 22, color: Color(0xFF949D9E)),
      ),
    );
  }
}
