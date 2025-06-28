import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/repos/products_repo/products_repo.dart';
import 'package:fruits_hub/core/utils/backend_endpoint.dart';
import 'package:fruits_hub/features/search/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final ProductsRepo productsRepo;
  SearchCubit(this.productsRepo) : super(SearchInitial());
  Future<void> searchProducts({required String query}) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    final response = await productsRepo.searchProducts(
      collectionName: BackendEndpoint.getProducts,
      query: query,
    );
    response.fold(
      (failure) => emit(SearchFailure(failure.toString())),
      (products) => emit(SearchSuccess(products, query)),
    );
  }

  void clearSearch() {
    emit(SearchInitial());
  }
}
