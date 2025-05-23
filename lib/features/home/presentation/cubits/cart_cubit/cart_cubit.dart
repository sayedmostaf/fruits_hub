import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/features/home/domain/entities/cart_entity.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  CartEntity cartEntity = CartEntity([]);

  void addCartItem(ProductEntity productEntity) {
    bool isProductExist = cartEntity.isExist(productEntity);
    var cartItem = cartEntity.getCartItem(productEntity);
    if (isProductExist) {
      cartItem.increaseCount();
    } else {
      cartEntity.addCartItem(cartItem);
      emit(CartItemAdded());
    }
  }
}
