import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_entity.dart';
import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_item_entity.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final CartEntity cart = CartEntity([]);

  void addCartItem({required ProductEntity product}) {
    final exists = cart.isCartItemExist(productEntity: product);
    final item = cart.getCartItem(productEntity: product);
    final updatedItem = item.copyWith(count: item.count + 1);

    if (!exists) {
      cart.addCartItem(cartItem: updatedItem);
    } else {
      cart.updateCartItem(updatedItem);
    }
    emit(CartItemChanged());
  }

  void updateItemCount({
    required ProductEntity product,
    required int newCount,
  }) {
    final updatedItem = CartItemEntity(productEntity: product, count: newCount);
    cart.updateCartItem(updatedItem);
    emit(CartItemChanged());
  }

  void removeCartItem({required CartItemEntity cartItem}) {
    cart.removeCartItem(cartItem: cartItem);
    emit(CartItemChanged());
  }

  void clearCart() {
    cart.clearCart();
    emit(CartItemChanged());
  }
}
