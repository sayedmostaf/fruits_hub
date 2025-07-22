import 'package:fruits_hub/core/entities/product_entity.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesUpdated extends FavoritesState {
  final List<ProductEntity> favorites;
  FavoritesUpdated(this.favorites);
}
