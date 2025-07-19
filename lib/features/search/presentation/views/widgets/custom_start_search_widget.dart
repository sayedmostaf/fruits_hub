import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/locale/recent_searche/recent_search_local_repo.dart';
import 'package:fruits_hub/core/managers/product/product_cubit.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:provider/provider.dart';

class CustomStartSearchWidget extends StatelessWidget {
  const CustomStartSearchWidget({
    super.key,
    required this.recentSearches,
    required this.textEditingController,
    required this.recentSearchLocalRepo,
  });
  final ValueNotifier<List<String>> recentSearches;
  final TextEditingController textEditingController;
  final RecentSearchLocalRepo recentSearchLocalRepo;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                AppStrings.recentSearchTitle.tr(),
                style: AppTextStyle.textStyle13w600.copyWith(
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  await recentSearchLocalRepo.clearAll();
                  recentSearches.value = [];
                },
                child: Text(
                  AppStrings.clearAll.tr(),
                  style: AppTextStyle.textStyle13w400.copyWith(
                    color: theme.textTheme.labelMedium?.color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ValueListenableBuilder<List<String>>(
            valueListenable: recentSearches,
            builder: (context, searches, child) {
              if (searches.isEmpty) {
                return Text(
                  AppStrings.noRecentSearches.tr(),
                  style: AppTextStyle.textStyle13w400.copyWith(
                    color: theme.textTheme.labelMedium?.color,
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: searches.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      textEditingController.text = searches[index];
                      context.read<ProductCubit>().getSearchedProducts(
                        search: searches[index],
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: theme.iconTheme.color),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            searches[index],
                            style: AppTextStyle.textStyle13w600.copyWith(
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await recentSearchLocalRepo.removeAt(index);
                            recentSearches.value =
                                await recentSearchLocalRepo.getRecentSearches();
                          },
                          icon: Icon(Icons.close, color: theme.iconTheme.color),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
