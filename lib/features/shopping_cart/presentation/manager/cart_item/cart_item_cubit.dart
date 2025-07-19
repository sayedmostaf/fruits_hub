import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_item_entity.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart_item/cart_item_state.dart';

class CartItemCubit extends Cubit<CartItemState> {
  CartItemCubit() : super(CartItemInitial());

  void updateCartItem({required CartItemEntity cartItem}) {
    emit(CartItemUpdatedState(targetCartItem: cartItem));
  }
}
