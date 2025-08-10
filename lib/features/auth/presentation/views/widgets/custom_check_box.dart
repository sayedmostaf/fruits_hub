import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.onChange,
    required this.isChecked,
    this.size = 24,
    this.borderRadius = 8,
  });
  final ValueChanged<bool> onChange;
  final bool isChecked;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChange(!isChecked),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isChecked ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isChecked ? Colors.transparent : theme.dividerColor,
            width: 1.5,
          ),
        ),
        child:
            isChecked
                ? Center(
                  child: SvgPicture.asset(
                    Assets.imagesCheck,
                    width: size * 0.6,
                    height: size * 0.6,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.onPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                )
                : null,
      ),
    );
  }
}
