import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/widgets/active_tag_widget.dart';
import 'package:fruits_hub/core/utils/widgets/in_active_tag_widget.dart';
import 'package:fruits_hub/features/home/domain/entities/bottom_navigation_bar_entity.dart';

class NavigatorBottomTag extends StatelessWidget {
  const NavigatorBottomTag({
    super.key,
    required this.isSelected,
    required this.tagEntity,
  });
  final bool isSelected;
  final BottomNavigationBarEntity tagEntity;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child:
          isSelected
              ? ActiveTagWidget(
                activeTagIcon: tagEntity.activeTag,
                title: tagEntity.translatedName,
                key: ValueKey('active'),
              )
              : InActiveTagWidget(
                key: ValueKey('inactive'),
                inActiveTagIcon: tagEntity.inActiveTag,
              ),
    );
  }
}
