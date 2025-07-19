import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_item_entity.dart';

class CartEntity {
  final List<CartItemEntity> cartItems;
  CartEntity(this.cartItems);

  void addCartItem({required CartItemEntity cartItem}) {
    cartItems.add(cartItem);
  }

  void removeCartItem({required CartItemEntity cartItem}) {
    cartItems.removeWhere(
      (item) => item.productEntity.code == cartItem.productEntity.code,
    );
  }

  void updateCartItem(CartItemEntity updatedItem) {
    for (int i = 0; i < cartItems.length; i++) {
      if (cartItems[i].productEntity.code == updatedItem.productEntity.code) {
        cartItems[i] = updatedItem;
        break;
      }
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  bool isCartItemExist({required ProductEntity productEntity}) {
    return cartItems.any(
      (item) => item.productEntity.code == productEntity.code,
    );
  }

  CartItemEntity getCartItem({required ProductEntity productEntity}) {
    return cartItems.firstWhere(
      (item) => item.productEntity.code == productEntity.code,
      orElse: () => CartItemEntity(productEntity: productEntity, count: 0),
    );
  }

  num calculateTotalPrice() {
    return cartItems.fold(0.0, (sum, item) => sum + item.calculateTotalPrice());
  }
}
