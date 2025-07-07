import 'package:fruits_hub/core/entities/product_entity.dart';

abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteSuccess extends FavoriteState {
  final List<ProductEntity> favoriteProducts;
  FavoriteSuccess(this.favoriteProducts);
}

class FavoriteFailure extends FavoriteState {
  final String message;
  FavoriteFailure(this.message);
}

class FavoriteIsFavorite extends FavoriteState {
  final bool isFavorite;
  final String productCode;
  FavoriteIsFavorite({required this.isFavorite, required this.productCode});
}
