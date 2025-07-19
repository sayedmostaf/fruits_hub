import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/errors/failure.dart';
import 'package:fruits_hub/core/models/discount_model.dart';
import 'package:fruits_hub/core/models/product_model.dart';
import 'package:fruits_hub/core/repos/product/product_repo.dart';
import 'package:fruits_hub/core/services/database_service.dart';
import 'package:fruits_hub/core/utils/backend_endpoints.dart';
import 'package:fruits_hub/core/utils/firebase_fields.dart';

enum ProductSortType { newest, priceLowToHigh, priceHighToLow }

class ProductRepoImpl extends ProductRepo {
  final DatabaseService databaseService;
  ProductRepoImpl(this.databaseService);
  @override
  Future<Either<Failure, List<ProductEntity>>> getFeaturedProducts() async {
    try {
      final collection = await databaseService.getDocumentOrCollection(
        path: BackendEndpoints.getProducts,
        queries: {
          'where': [
            {
              'field': FirebaseFields.productIsFeatured,
              'operator': '==',
              'value': true,
            },
          ],
          'limit': 10,
        },
      );
      final products = await _mapCollectionWithDiscount(collection);

      log('ProductRepoImpl.getFeaturedProducts: ✅ Success');
      return right(products);
    } catch (e) {
      log('ProductRepoImpl.getFeaturedProducts: ❌ ${e.toString()}');
      return left(ServerFailure(errMessage: 'Failed to get Featured Products'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getSearchedProducts({
    required String searchQuery,
  }) async {
    try {
      final collection = await databaseService.getDocumentOrCollection(
        path: BackendEndpoints.getProducts,
        queries: {
          'where': [
            {
              'field': FirebaseFields.productName,
              'operator': '>=',
              'value': searchQuery,
            },
            {
              'field': FirebaseFields.productName,
              'operator': '<=',
              'value': searchQuery + '\uf8ff',
            },
          ],
          'limit': 10,
        },
      );
      final products = await _mapCollectionWithDiscount(collection);

      log(
        products.isEmpty
            ? 'ProductRepoImpl.getSearchedProducts: ❗ No products found'
            : 'ProductRepoImpl.getSearchedProducts: ✅ Success',
      );

      return right(products);
    } catch (e) {
      log('ProductRepoImpl.getSearchedProducts: ❌  [31m${e.toString()}');
      return left(ServerFailure(errMessage: 'Failed to search products'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getBestSellingProducts() async {
    try {
      final collection = await databaseService.getDocumentOrCollection(
        path: BackendEndpoints.getProducts,
        queries: {
          'orderBy': FirebaseFields.productSellingCount,
          'descending': true,
          'limit': 10,
        },
      );
      final products = await _mapCollectionWithDiscount(collection);
      log('ProductRepoImpl.getBestSellingProducts: ✅ Success');
      return right(products);
    } catch (e) {
      log('ProductRepoImpl.getBestSellingProducts: ❌ ${e.toString()}');
      return left(
        ServerFailure(errMessage: 'Failed to get best selling products'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    ProductSortType sortType = ProductSortType.priceLowToHigh,
  }) async {
    try {
      final queries = <String, dynamic>{};

      switch (sortType) {
        case ProductSortType.newest:
          queries['orderBy'] = FirebaseFields.productAddDate;
          queries['descending'] = true;
          break;
        case ProductSortType.priceLowToHigh:
          queries['orderBy'] = FirebaseFields.productPrice;
          queries['descending'] = false;
          break;
        case ProductSortType.priceHighToLow:
          queries['orderBy'] = FirebaseFields.productPrice;
          queries['descending'] = true;
          break;
      }

      final collection = await databaseService.getDocumentOrCollection(
        path: BackendEndpoints.getProducts,
        queries: queries,
      );

      final products = await _mapCollectionWithDiscount(collection);
      log('ProductRepoImpl.getProducts: ✅ Success with sortType = $sortType');
      return right(products);
    } catch (e) {
      log('ProductRepoImpl.getProducts: ❌ ${e.toString()}');
      return left(ServerFailure(errMessage: 'Failed to get products'));
    }
  }

  Future<List<ProductEntity>> _mapCollectionWithDiscount(
    dynamic collection,
  ) async {
    if (collection is! List) {
      log('⚠️ Unexpected data type from databaseService');
      return [];
    }

    final List<ProductModel> products =
        collection
            .whereType<Map<String, dynamic>>()
            .map((doc) => ProductModel.fromJson(doc))
            .toList();

    final List<ProductModel> productsWithDiscount = [];

    for (final product in products) {
      try {
        final discountDoc = await databaseService.getDocumentOrCollection(
          path:
              '${BackendEndpoints.getProducts}/${product.code}/${BackendEndpoints.getDiscounts}',
          documentId: BackendEndpoints.getCurrentDiscounts,
        );
        if (discountDoc != null &&
            discountDoc is Map<String, dynamic> &&
            discountDoc.isNotEmpty) {
          final discount = DiscountModel.fromJson(discountDoc);
          final discountedPrice =
              product.price - (product.price * discount.percentage / 100);
          log(
            '✅✅✅ Discount fetched for ${product.name}: percentage = ${discount.percentage}, price: ${product.price} -> $discountedPrice',
          );
          productsWithDiscount.add(
            product.copyWith(discount: discount, price: discountedPrice),
          );
        } else {
          log('❌ No discount found for product: ${product.name}');
          productsWithDiscount.add(product);
        }
      } catch (e, s) {
        log('❌ Error fetching discount for ${product.name}: $e');
        log('📌 Stack trace:\n$s');
        productsWithDiscount.add(product);
      }
    }
    return productsWithDiscount;
  }
}
