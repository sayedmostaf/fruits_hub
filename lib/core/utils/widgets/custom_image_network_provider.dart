import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImageNetworkProvider extends StatelessWidget {
  const CustomImageNetworkProvider({super.key, this.imageUrl});
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Icon(color: Colors.grey, Icons.image_not_supported);
    }
    return Flexible(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Image(
          image: CachedNetworkImageProvider(imageUrl!),
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.error, color: Colors.red);
          },
        ),
      ),
    );
  }
}
