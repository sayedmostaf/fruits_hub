import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImageNetworkProvider extends StatelessWidget {
  const CustomImageNetworkProvider({
    super.key,
    this.imageUrl,
    this.borderRadius = 8,
    this.boxShadow,
  });
  final String? imageUrl;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow:
              boxShadow ??
              [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
        ),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: BoxFit.cover,
          placeholder:
              (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          errorWidget:
              (context, url, error) => Container(
                color: Colors.grey[200],
                child: Icon(Icons.error, color: Colors.red[400]),
              ),
        ),
      ),
    );
  }
}
