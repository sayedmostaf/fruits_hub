import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/errors/exceptions.dart';
import 'package:fruits_hub/core/models/product_model.dart';
import 'package:fruits_hub/core/services/favorite_service.dart';
import 'package:fruits_hub/core/services/firestore_service.dart';
import 'package:fruits_hub/core/utils/backend_endpoint.dart';
import 'package:fruits_hub/features/favorite/data/repo/favorite_repo.dart';

class FavoriteRepoImpl implements FavoriteRepo {
  final FavoriteService favoriteService;
  final FireStoreService fireStoreService;
  FavoriteRepoImpl(this.favoriteService, this.fireStoreService);
  @override
  Future<Either<String, void>> addToFavorites({
    required ProductEntity product,
  }) async {
    try {
      await favoriteService.addToFavorite(itemId: product.code);
      return right(null);
    } on CustomException catch (e) {
      return left("حدث خطأ أثناء إضافة المنتج.");
    }
  }

  @override
  Future<Either<String, List<ProductEntity>>> getFavorites() async {
    try {
      final favoriteItems = await favoriteService.getFavoriteItems();
      final response = await Future.wait(
        favoriteItems.map(
          (e) => fireStoreService.getData(
            path: BackendEndpoint.getProducts,
            documentId: e,
          ),
        ),
      );
      List<ProductEntity> products = [];
      if (response.isNotEmpty) {
        {
          for (var element in response) {
            var product = await element;
            if (product != null) {
              products.add(ProductModel.fromJson(product).toEntity());
            }
          }
        }
      }
      return right(products);
    } on CustomException catch (e) {
      return left("حدث خطأ في تحميل المنتجات.");
    }
  }

  @override
  Future<bool> isFavorite({required String productCode}) async {
    try {
      return await favoriteService.isFavorite(itemId: productCode);
    } on CustomException catch (e) {
      return false;
    }
  }

  @override
  Future<Either<String, void>> removeFavorites({
    required String productCode,
  }) async {
    try {
      await favoriteService.removeFromFavorite(itemId: productCode);
      return right(null);
    } on CustomException catch (e) {
      return left("حدث خطأ أثناء إزالة المنتج.");
    }
  }
}
