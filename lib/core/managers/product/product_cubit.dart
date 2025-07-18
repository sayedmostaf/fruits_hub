import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/managers/product/product_state.dart';
import 'package:fruits_hub/core/repos/product/product_repo.dart';
import 'package:fruits_hub/core/repos/product/product_repo_impl.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo productRepo;
  int length = 0;
  ProductCubit(this.productRepo) : super(ProductInitial());
  Future<void> getBestSellingProducts() async {
    emit(ProductLoading());
    final result = await productRepo.getBestSellingProducts();
    result.fold((failure) => emit(ProductFailure(failure.errMessage)), (
      products,
    ) {
      length = products.length;
      emit(ProductSuccess(products));
    });
  }

  Future<void> getProducts({
    ProductSortType sortType = ProductSortType.priceLowToHigh,
  }) async {
    emit(ProductLoading());
    final result = await productRepo.getProducts(sortType: sortType);
    result.fold((failure) => emit(ProductFailure(failure.errMessage)), (
      products,
    ) {
      length = products.length;
      emit(ProductSuccess(products));
    });
  }

  Future<void> getSearchedProducts({required String search}) async {
    if (search.trim().isEmpty) {
      emit(ProductInitial());
      return;
    }
    emit(ProductLoading());
    final result = await productRepo.getSearchedProducts(searchQuery: search);
    result.fold((failure) => emit(ProductFailure(failure.errMessage)), (
      products,
    ) {
      if (products.isEmpty) {
        emit(ProductNotFound());
      } else {
        emit(ProductSuccess(products));
      }
    });
  }
}
