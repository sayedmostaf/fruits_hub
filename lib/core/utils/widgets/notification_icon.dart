import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/features/notifications/presentation/managers/notifications_cubit.dart';
import 'package:fruits_hub/features/notifications/presentation/managers/notifications_state.dart';
import 'package:fruits_hub/features/notifications/presentation/views/notifications_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: context.read<NotificationsCubit>(),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final hasRead =
              state is NotificationsSuccess && state.discounts.isNotEmpty;
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
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const NotificationsView(),
                      withNavBar: true,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
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
              if (hasRead)
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
        },
      ),
    );
  }
}
