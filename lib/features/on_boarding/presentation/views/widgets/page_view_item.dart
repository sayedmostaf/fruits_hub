import 'package:flutter/material.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required this.image,
    required this.subTitle,
    required this.backgroundImage,
    required this.title,
  });
  final String image, subTitle, backgroundImage;
  final Widget title;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
