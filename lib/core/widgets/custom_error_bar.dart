import 'package:flutter/material.dart';

class CustomErrorBar extends StatelessWidget {
  const CustomErrorBar({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
