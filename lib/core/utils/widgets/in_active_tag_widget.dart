import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InActiveTagWidget extends StatelessWidget {
  const InActiveTagWidget({super.key, required this.inActiveTagIcon});
  final String inActiveTagIcon;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(inActiveTagIcon);
  }
}
