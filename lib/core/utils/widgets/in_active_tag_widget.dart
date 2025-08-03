import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InActiveTagWidget extends StatelessWidget {
  const InActiveTagWidget({
    super.key,
    required this.inActiveTagIcon,
    this.size = 24,
    this.color,
  });
  final String inActiveTagIcon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: SvgPicture.asset(
        inActiveTagIcon,
        width: size,
        height: size,
        color:
            color ??
            Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
      ),
    );
  }
}
