import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/repos/products_repo/products_repo.dart';
import 'package:fruits_hub/core/utils/backend_endpoint.dart';
import 'package:fruits_hub/features/search/presentation/cubit/search_state.dart';
import 'dart:developer' as developer;

class SearchCubit extends Cubit<SearchState> {
  final ProductsRepo productsRepo;
  SearchCubit(this.productsRepo) : super(SearchInitial());

  Future<void> searchProducts({required String query}) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    developer.log('Searching for products with query: $query');

    final response = await productsRepo.searchProducts(
      collectionName: BackendEndpoint.getProducts,
      query: query,
    );

    response.fold(
      (failure) {
        developer.log('Search failed: ${failure.message}');
        emit(SearchFailure('فشل في البحث. يرجى المحاولة مرة أخرى.'));
      },
      (products) {
        developer.log('Search successful. Found ${products.length} products');
        emit(SearchSuccess(products, query));
      },
    );
  }

  void clearSearch() {
    emit(SearchInitial());
  }
}
