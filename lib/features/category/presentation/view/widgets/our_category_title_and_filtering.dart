import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/category/presentation/view/widgets/choices_on_bottom_sheet.dart';

class OurCategoryTitleAndFiltering extends StatelessWidget {
  const OurCategoryTitleAndFiltering({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('منتجاتنا', style: TextStyles.bold16),
        InkWell(
          onTap: () {
            showBottomSheet(context);
          },
          child: SvgPicture.asset(Assets.imagesFilter2),
        ),
      ],
    );
  }

  Future<dynamic> showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          width: double.infinity,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ),
          child: ChoicesOnBottomSheet(),
        );
      },
    );
  }
}
