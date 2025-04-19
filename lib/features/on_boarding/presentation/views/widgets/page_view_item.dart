import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required this.image,
    required this.subTitle,
    required this.backgroundImage,
    required this.title,
  });
  final String image, subTitle, backgroundImage;
  final Widget title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(backgroundImage, fit: BoxFit.fill),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SvgPicture.asset(image),
              ),
              Padding(padding: EdgeInsets.all(16), child: Text('تخط')),
            ],
          ),
        ),
      ],
    );
  }
}
