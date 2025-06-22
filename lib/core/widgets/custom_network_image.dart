import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: width,
          color: Colors.grey[300],
          child: const Icon(Icons.error, color: Colors.grey),
        );
      },
    );
  }
}
