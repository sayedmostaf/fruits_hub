abstract class FavoriteService {
  Future<bool> addToFavorite({required String itemId});
  Future<bool> removeFromFavorite({required String itemId});
  Future<bool> isFavorite({required String itemId});
  Future<List<String>> getFavoriteItems();
}