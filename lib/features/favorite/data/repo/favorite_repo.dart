import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';

abstract class FavoriteRepo {
  Future<Either<String, void>> addToFavorites({required ProductEntity product});
  Future<Either<String, void>> removeFavorites({required String productCode});
  Future<Either<String, List<ProductEntity>>> getFavorites();
  Future<bool> isFavorite({required String productCode});
}
