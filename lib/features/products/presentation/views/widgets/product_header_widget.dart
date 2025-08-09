import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruits_hub/core/managers/product/product_cubit.dart';
import 'package:fruits_hub/core/repos/product/product_repo_impl.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:provider/provider.dart';

class ProductHeaderWidget extends StatefulWidget {
  const ProductHeaderWidget({super.key, required this.productLength});
  final int productLength;

  @override
  State<ProductHeaderWidget> createState() => _ProductHeaderWidgetState();
}

class _ProductHeaderWidgetState extends State<ProductHeaderWidget>
    with SingleTickerProviderStateMixin {
  ProductSortType selectedSortType = ProductSortType.priceLowToHigh;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Cubic(0.4, 0.0, 0.2, 1.0),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Semantics(
            label: '${widget.productLength} results found',
            child: Text(
              '${widget.productLength} ${'results'.tr()}',
              style: AppTextStyle.textStyle14w700.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const Spacer(),
          _buildFilterButton(context),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open filter options',
      child: InkWell(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        onTap: () => _showProductFilterBottomSheet(context),
        borderRadius: BorderRadius.circular(12),
        splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.imagesFilter2,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  AppStrings.filter.tr(),
                  style: AppTextStyle.textStyle14w600.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProductFilterBottomSheet(BuildContext parentContext) {
    final ValueNotifier<ProductSortType> tempSortType =
        ValueNotifier<ProductSortType>(selectedSortType);
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Theme.of(parentContext).colorScheme.surface,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.25,
          maxChildSize: 0.55,
          expand: false,
          builder:
              (_, controller) => ValueListenableBuilder<ProductSortType>(
                valueListenable: tempSortType,
                builder:
                    (context, value, _) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDragHandle(context),
                          const SizedBox(height: 12),
                          Text(
                            AppStrings.sortBy.tr(),
                            style: AppTextStyle.textStyle23w700.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Flexible(
                            child: ListView(
                              controller: controller,
                              shrinkWrap: true,
                              children: [
                                _buildSortOption(
                                  context,
                                  ProductSortType.priceLowToHigh,
                                  AppStrings.priceLowToHigh.tr(),
                                  value,
                                  (val) => tempSortType.value = val!,
                                ),
                                _buildSortOption(
                                  context,
                                  ProductSortType.priceHighToLow,
                                  AppStrings.priceHighToLow.tr(),
                                  value,
                                  (val) => tempSortType.value = val!,
                                ),
                                _buildSortOption(
                                  context,
                                  ProductSortType.newest,
                                  AppStrings.newest.tr(),
                                  value,
                                  (val) => tempSortType.value = val!,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildApplyButton(parentContext, tempSortType),
                        ],
                      ),
                    ),
              ),
        );
      },
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 4,
        width: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    ProductSortType value,
    String title,
    ProductSortType groupValue,
    ValueChanged<ProductSortType?> onChanged,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: const Cubic(0.4, 0.0, 0.2, 1.0),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color:
            groupValue == value
                ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                : Theme.of(context).colorScheme.surface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              groupValue == value
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: RadioListTile<ProductSortType>(
        value: value,
        groupValue: groupValue,
        onChanged: (val) {
          onChanged(val);
          _animationController.forward().then(
            (_) => _animationController.reverse(),
          );
        },
        title: Text(
          title,
          style: AppTextStyle.textStyle16w600.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: 0.2,
          ),
        ),
        activeColor: Theme.of(context).colorScheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildApplyButton(
    BuildContext parentContext,
    ValueNotifier<ProductSortType> tempSortType,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(parentContext).pop();
          setState(() {
            selectedSortType = tempSortType.value;
          });
          await parentContext.read<ProductCubit>().getProducts(
            sortType: selectedSortType,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyle.textStyle16w700.copyWith(letterSpacing: 0.4),
        ),
        child: Text(
          AppStrings.filter.tr(),
          style: AppTextStyle.textStyle16w700.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}
