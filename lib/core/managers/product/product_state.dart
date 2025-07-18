import 'package:fruits_hub/core/entities/product_entity.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final List<ProductEntity> productsEntities;
  ProductSuccess(this.productsEntities);
}

class ProductFailure extends ProductState {
  final String message;
  ProductFailure(this.message);
}

class ProductNotFound extends ProductState {
  final String errMessage;
  ProductNotFound({this.errMessage = 'لم يتم العثور على نتائج'});
}
