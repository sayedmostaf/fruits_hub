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
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child:
          isSelected
              ? ActiveTagWidget(
                activeTagIcon: tagEntity.activeTag,
                title: tagEntity.translatedName,
                key: const ValueKey('active'),
                maxWidth: 120,
              )
              : InActiveTagWidget(
                key: const ValueKey('inactive'),
                inActiveTagIcon: tagEntity.inActiveTag,
              ),
    );
  }
}
