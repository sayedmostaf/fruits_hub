import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/functions/build_error_snack_bar.dart';
import 'package:fruits_hub/core/functions/build_success_snack_bar.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/locale_box.dart';
import 'package:fruits_hub/features/settings/presentation/managers/favorites/favorites_state.dart';
import 'package:hive/hive.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial()) {
    _loadFavoritesFromHive();
  }
  final _favoritesBox = Hive.box<ProductEntity>(LocaleBox.favoritesBox);
  List<ProductEntity> _favorites = [];

  List<ProductEntity> get favorites => List.unmodifiable(_favorites);

  void _loadFavoritesFromHive() {
    _favorites = _favoritesBox.values.toList();
    emit(FavoritesUpdated(List<ProductEntity>.from(_favorites)));
  }

  void toggleFavorite(BuildContext context, ProductEntity product) {
    final isFav = _favorites.any((p) => p.code == product.code);

    if (isFav) {
      _favorites.removeWhere((p) => p.code == product.code);
      _favoritesBox.delete(product.code);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        buildErrorSnackBar(
          context,
          message: AppStrings.removedFromFavorites.tr(),
        );
      });
    } else {
      _favorites.add(product);
      _favoritesBox.put(product.code, product);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        buildSuccessSnackBar(
          context,
          message: AppStrings.addedToFavorites.tr(),
        );
      });
    }

    emit(FavoritesUpdated(List<ProductEntity>.from(_favorites)));
  }

  bool isFavorite(ProductEntity product) {
    return _favorites.any((p) => p.code == product.code);
  }

  void clearFavorites() {
    _favorites.clear();
    _favoritesBox.clear();
    emit(FavoritesUpdated([]));
  }
}
