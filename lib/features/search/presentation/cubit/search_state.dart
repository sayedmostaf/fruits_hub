import 'package:fruits_hub/core/entities/product_entity.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<ProductEntity> products;
  final String searchQuery;
  SearchSuccess(this.products, this.searchQuery);
}

class SearchFailure extends SearchState {
  final String errorMessage;
  SearchFailure(this.errorMessage);
}
