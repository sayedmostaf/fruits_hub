import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/features/home/domain/entities/cart_entity.dart';
import 'package:fruits_hub/features/home/domain/entities/cart_item_entity.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  CartEntity cartEntity = CartEntity([]);

  void addCartItem(ProductEntity productEntity) {
    bool isProductExist = cartEntity.isExist(productEntity);
    if (isProductExist) {
      // increase count
    } else {
      CartItemEntity cartItemEntity = CartItemEntity(
        productEntity: productEntity,
        count: 1,
      );
      cartEntity.addCartItem(cartItemEntity);
      emit(CartItemAdded());
    }
  }
}
