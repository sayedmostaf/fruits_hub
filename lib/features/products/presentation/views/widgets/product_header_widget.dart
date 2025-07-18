import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

class _ProductHeaderWidgetState extends State<ProductHeaderWidget> {
  ProductSortType selectedSortType = ProductSortType.priceLowToHigh;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${widget.productLength} ${'results'.tr()}',
          style: AppTextStyle.textStyle16w700.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Spacer(),
        Material(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          child: InkWell(
            onTap: () {
              final parentContext = context;
              _showProductFilterBottomSheet(parentContext);
            },
            borderRadius: BorderRadius.circular(12),
            splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            highlightColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SvgPicture.asset(
                Assets.imagesFilter2,
                width: 20,
                height: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showProductFilterBottomSheet(BuildContext parentContext) {
    ProductSortType tempSortType = selectedSortType;
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor.withOpacity(0.95),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 4,
                    width: 40,
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      AppStrings.sortBy.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  RadioListTile<ProductSortType>(
                    value: ProductSortType.priceLowToHigh,
                    groupValue: tempSortType,
                    onChanged: (val) => setState(() => tempSortType = val!),
                    title: Text(
                      AppStrings.priceLowToHigh.tr(),
                      textAlign: TextAlign.right,
                    ),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  RadioListTile<ProductSortType>(
                    value: ProductSortType.priceHighToLow,
                    groupValue: tempSortType,
                    onChanged: (val) => setState(() => tempSortType = val!),
                    title: Text(
                      AppStrings.priceHighToLow.tr(),
                      textAlign: TextAlign.right,
                    ),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  RadioListTile<ProductSortType>(
                    value: ProductSortType.newest,
                    groupValue: tempSortType,
                    onChanged: (val) => setState(() => tempSortType = val!),
                    title: Text(
                      AppStrings.newest.tr(),
                      textAlign: TextAlign.right,
                    ),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          selectedSortType = tempSortType;
                        });
                        parentContext.read<ProductCubit>().getProducts(
                          sortType: selectedSortType,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        AppStrings.filter.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
