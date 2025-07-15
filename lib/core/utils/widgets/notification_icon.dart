import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: handle notification bloc builder and it's provider
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: theme.colorScheme.primary.withOpacity(0.08),
          shape: CircleBorder(),
          elevation: 3,
          shadowColor: Colors.black.withOpacity(0.1),
          child: InkWell(
            onTap: () {
              // TODO: handle go to notification page
            },
            customBorder: CircleBorder(),
            splashColor: theme.colorScheme.primary.withOpacity(0.2),
            highlightColor: theme.colorScheme.primary.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: SvgPicture.asset(
                Assets.imagesNotification,
                width: 20,
                height: 20,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
        // TODO: handle has read or not
        Positioned(
          top: 8,
          right: 17.5,
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
