import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/errors/failures.dart';
import 'package:fruits_hub/core/models/product_model.dart';
import 'package:fruits_hub/core/repos/products_repo/products_repo.dart';
import 'package:fruits_hub/core/services/data_service.dart';
import 'package:fruits_hub/core/utils/backend_endpoint.dart';
import 'dart:developer' as developer;

class ProductsRepoImpl extends ProductsRepo {
  final DatabaseService databaseService;
  ProductsRepoImpl(this.databaseService);
  @override
  Future<Either<Failure, List<ProductEntity>>> getBestSellingProducts() async {
    try {
      developer.log('Fetching best selling products...');
      var data =
          await databaseService.getData(
                path: BackendEndpoint.getProducts,
                query: {
                  'limit': 10,
                  'orderBy': 'sellingCount',
                  'descending': true,
                },
              )
              as List<Map<String, dynamic>>;
      developer.log(
        'Successfully fetched ${data.length} best selling products',
      );
      List<ProductEntity> products =
          data.map((e) => ProductModel.fromJson(e).toEntity()).toList();
      return right(products);
    } catch (e) {
      developer.log('Error fetching best selling products: $e', error: e);
      return left(ServerFailure('Failed to get products: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      developer.log('Fetching all products...');
      var data =
          await databaseService.getData(path: BackendEndpoint.getProducts)
              as List<Map<String, dynamic>>;
      developer.log('Successfully fetched ${data.length} products');
      List<ProductEntity> products =
          data.map((e) => ProductModel.fromJson(e).toEntity()).toList();
      return right(products);
    } catch (e) {
      developer.log('Error fetching products: $e', error: e);
      return left(ServerFailure('Failed to get products: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String collectionName,
    required String query,
  }) async {
    try {
      developer.log('Searching products with query: $query');
      final response = await databaseService.getData(
        path: collectionName,
        query: {'search': query},
      );

      if (response is List) {
        List<ProductEntity> products =
            response
                .map((map) => ProductModel.fromJson(map).toEntity())
                .toList();
        developer.log('Search successful. Found ${products.length} products');
        return right(products);
      } else {
        developer.log('Search failed: Invalid response format');
        return left(ServerFailure('خطأ في تنسيق البيانات المستلمة'));
      }
    } catch (e) {
      developer.log('Error searching products: $e', error: e);
      return left(ServerFailure('فشل في البحث. يرجى المحاولة مرة أخرى.'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> priceFiltering({
    required String collectionName,
    required bool ascending,
    required bool alpha,
  }) async {
    try {
      final response = await databaseService.getData(
        path: collectionName,
        query: {'ascending': ascending, 'alpha': alpha},
      );
      List<ProductEntity> products =
          response.map((e) => ProductModel.fromJson(e).toEntity()).toList();
      return right(products);
    } catch (e) {
      return left(
        ServerFailure('فشل في تصفية الأسعار. يرجى المحاولة مرة أخرى.'),
      );
    }
  }
}
