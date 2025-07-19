import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/search/presentation/views/search_products_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

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
        final result = await PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: const SearchProductsView(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
        if (result != null) {
          _controller.text = result;
        }
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
