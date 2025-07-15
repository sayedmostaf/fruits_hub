import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/widgets/navigator_bottom_tag.dart';
import 'package:fruits_hub/features/home/domain/entities/bottom_navigation_bar_entity.dart';

class CustomButtonNavigationBar extends StatelessWidget {
  const CustomButtonNavigationBar({
    super.key,
    required this.currentTag,
    required this.onTap,
  });
  final int currentTag;
  final Function(int) onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: ShapeDecoration(
        color:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 25,
            offset: Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            bottomNavigationBarTags.asMap().entries.map((tag) {
              final index = tag.key;
              final entity = tag.value;
              return Expanded(
                flex: currentTag == index ? 3 : 2,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onTap(index),
                    child: SizedBox.expand(
                      child: NavigatorBottomTag(
                        isSelected: currentTag == index,
                        tagEntity: entity,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
