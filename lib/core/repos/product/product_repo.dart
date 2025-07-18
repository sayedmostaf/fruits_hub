import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/errors/failure.dart';
import 'package:fruits_hub/core/repos/product/product_repo_impl.dart';

abstract class ProductRepo {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    ProductSortType sortType = ProductSortType.priceLowToHigh,
  });
  Future<Either<Failure, List<ProductEntity>>> getBestSellingProducts();
  Future<Either<Failure, List<ProductEntity>>> getFeaturedProducts();
  Future<Either<Failure, List<ProductEntity>>> getSearchedProducts({
    required String searchQuery,
  });
}
