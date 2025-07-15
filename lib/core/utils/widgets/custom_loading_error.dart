import 'package:flutter/material.dart';

class CustomLoadingError extends StatelessWidget {
  const CustomLoadingError({super.key, required this.errMessage});
  final String errMessage;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(errMessage));
  }
}
