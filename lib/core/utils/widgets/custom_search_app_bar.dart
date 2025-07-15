import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class CustomSearchAppBar extends StatefulWidget {
  const CustomSearchAppBar({super.key});

  @override
  State<CustomSearchAppBar> createState() => _CustomSearchAppBarState();
}

class _CustomSearchAppBarState extends State<CustomSearchAppBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      controller: _controller,
      readOnly: true,
      onTap: () async {
        // TODO: handle go to next page
      },
      decoration: InputDecoration(
        hintText: 'search_hint'.tr(),
        suffixIcon: SizedBox(
          width: 20,
          child: Center(child: SvgPicture.asset(Assets.imagesFilter)),
        ),
        prefixIcon: SizedBox(
          width: 20,
          child: Center(child: SvgPicture.asset(Assets.imagesSearchIcon)),
        ),
        hintStyle: AppTextStyle.textStyle13w400.copyWith(
          color: Theme.of(context).colorScheme.secondary,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: buildBorder(),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 1),
    );
  }
}
