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
      height: 80,
      decoration: BoxDecoration(
        color:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
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
                    splashColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    highlightColor: Colors.transparent,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutQuad,
                      margin: EdgeInsets.only(
                        bottom: currentTag == index ? 10 : 0,
                      ),
                      child: SizedBox.expand(
                        child: NavigatorBottomTag(
                          isSelected: currentTag == index,
                          tagEntity: entity,
                        ),
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
