import 'package:flutter/widgets.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class ProductDescriptionText extends StatelessWidget {
  const ProductDescriptionText({super.key, required this.description});
  final String description;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Text(
        description,
        style: TextStyles.regular13.copyWith(color: Color(0xFF949D9E)),
      ),
    );
  }
}
