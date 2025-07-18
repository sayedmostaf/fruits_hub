import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/managers/featured_product/featured_product_state.dart';
import 'package:fruits_hub/core/repos/product/product_repo.dart';

class FeaturedProductCubit extends Cubit<FeaturedProductState> {
  final ProductRepo productRepo;
  FeaturedProductCubit(this.productRepo) : super(FeaturedProductInitial());
  int length = 0;
  Future<void> getFeaturedProducts() async {
    emit(FeaturedProductLoading());
    final result = await productRepo.getFeaturedProducts();
    result.fold((failure) => emit(FeaturedProductFailure(failure.errMessage)), (
      products,
    ) {
      length += products.length;
      emit(FeaturedProductSuccess(products));
    });
  }
}
