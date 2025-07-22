import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/fruit_item.dart';
import 'package:fruits_hub/features/settings/presentation/managers/favorites/favorites_cubit.dart';
import 'package:fruits_hub/features/settings/presentation/managers/favorites/favorites_state.dart';

class FavoritesViewBody extends StatelessWidget {
  const FavoritesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final favorites = context.read<FavoritesCubit>().favorites;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Text(
                    AppStrings.favorites.tr(),
                    style: AppTextStyle.textStyle16w700.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Spacer(),
                  if (favorites.isNotEmpty)
                    Material(
                      elevation: 3,
                      shape: CircleBorder(),
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withOpacity(0.1),
                      shadowColor: Colors.black.withOpacity(0.1),
                      child: IconButton(
                        onPressed: () => _showClearDialog(context),
                        icon: Icon(
                          Icons.delete_forever_rounded,
                          color: Theme.of(context).colorScheme.error,
                          size: 24,
                        ),
                        tooltip: AppStrings.clearAll.tr(),
                        splashRadius: 24,
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child:
                  favorites.isEmpty
                      ? Center(
                        child: Text(
                          AppStrings.noFavoritesYet.tr(),
                          style: AppTextStyle.textStyle14w600.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                      : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: favorites.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 163 / 214,
                            ),
                        itemBuilder: (context, index) {
                          return FruitItem(productEntity: favorites[index]);
                        },
                      ),
            ),
          ],
        );
      },
    );
  }

  void _showClearDialog(BuildContext context) {
    final theme = Theme.of(context);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'clear_dialog',
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete_forever,
                    size: 48,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.clearAllFavoritesTitle.tr(),
                    style: AppTextStyle.textStyle16w600.copyWith(
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.clearAllFavoritesMessage.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle14w400.copyWith(
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                            side: BorderSide(color: theme.colorScheme.primary),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed:
                              () =>
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop(),
                          child: Text(
                            AppStrings.cancel.tr(),
                            style: AppTextStyle.textStyle14w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            context.read<FavoritesCubit>().clearFavorites();
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Text(
                            AppStrings.confirm.tr(),
                            style: AppTextStyle.textStyle14w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
