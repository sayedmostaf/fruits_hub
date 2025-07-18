import 'package:fruits_hub/core/entities/product_entity.dart';

abstract class FeaturedProductState {}

class FeaturedProductInitial extends FeaturedProductState {}

class FeaturedProductLoading extends FeaturedProductState {}

class FeaturedProductSuccess extends FeaturedProductState {
  final List<ProductEntity> productsEntities;
  FeaturedProductSuccess(this.productsEntities);
}

class FeaturedProductFailure extends FeaturedProductState {
  final String errMessage;
  FeaturedProductFailure(this.errMessage);
}
