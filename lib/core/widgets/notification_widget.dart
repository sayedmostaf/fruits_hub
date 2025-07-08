import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/features/favorite/presentation/view/favorite_view.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, FavoriteView.routeName),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          shape: OvalBorder(),
          color: Color(0xFFEEF8ED),
        ),
        child: SvgPicture.asset(Assets.imagesNotification),
      ),
    );
  }
}
