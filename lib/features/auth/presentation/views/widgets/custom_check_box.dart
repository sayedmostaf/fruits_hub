import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.onChange,
    required this.isChecked,
  });
  final ValueChanged<bool> onChange;
  final bool isChecked;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color fillColor =
        isChecked ? theme.colorScheme.primary : theme.colorScheme.background;
    final Color borderColor =
        isChecked ? Colors.transparent : theme.dividerColor;
    return GestureDetector(
      onTap: () => onChange(!isChecked),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child:
            isChecked
                ? Padding(
                  padding: EdgeInsets.all(2),
                  child: SvgPicture.asset(
                    Assets.imagesCheck,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.onPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                )
                : SizedBox.shrink(),
      ),
    );
  }
}
