import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: TextField(
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
          hintText: AppStrings.searchHint.tr(),

          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                Assets.imagesFilter,
                width: 16,
                height: 16,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {},
            ),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: IconButton(
              icon: SvgPicture.asset(
                Assets.imagesSearchIcon,
                width: 18,
                height: 18,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {},
            ),
          ),
          hintStyle: AppTextStyle.textStyle13w400.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: buildBorder(),
          enabledBorder: buildBorder(),
          focusedBorder: buildBorder(),
        ),
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );
  }
}
