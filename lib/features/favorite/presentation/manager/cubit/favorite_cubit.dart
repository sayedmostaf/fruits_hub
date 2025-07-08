import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/features/favorite/data/repo/favorite_repo.dart';
import 'package:fruits_hub/features/favorite/presentation/manager/cubit/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteRepo favoriteRepo;
  Set<String> favoriteItemsCodes = {};
  List<ProductEntity> cachedProducts = [];

  FavoriteCubit(this.favoriteRepo) : super(FavoriteInitial());

  Future<void> initFavorites() async {
    await getFavorites();
  }

  void addToFavorites({required ProductEntity product}) async {
    emit(FavoriteLoading());
    var response = await favoriteRepo.addToFavorites(product: product);
    response.fold((l) => emit(FavoriteFailure(l)), (r) {
      favoriteItemsCodes.add(product.code);
      cachedProducts.add(product);
      emit(FavoriteSuccess(cachedProducts));
    });
  }

  void removeFromFavorites({required String productCode}) async {
    emit(FavoriteLoading());
    var response = await favoriteRepo.removeFavorites(productCode: productCode);
    response.fold((l) => emit(FavoriteFailure(l)), (r) {
      favoriteItemsCodes.remove(productCode);
      cachedProducts.removeWhere((element) => element.code == productCode);
      emit(FavoriteSuccess(cachedProducts));
    });
  }

  Future<void> getFavorites() async {
    emit(FavoriteLoading());
    try {
      var response = await favoriteRepo.getFavorites();
      response.fold((l) => emit(FavoriteFailure(l)), (r) {
        cachedProducts = r;
        favoriteItemsCodes = r.map((e) => e.code).toSet();
        emit(FavoriteSuccess(r));
      });
    } catch (e) {
      log('Unexpected error in getFavorites: $e');
      emit(FavoriteFailure('حدث خطأ غير متوقع أثناء تحميل المفضلة.'));
    }
  }

  bool isFavorite({required String productCode}) {
    return favoriteItemsCodes.contains(productCode);
  }
}
