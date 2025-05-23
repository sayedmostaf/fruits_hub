import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/features/home/domain/entities/cart_item_entity.dart'
    show CartItemEntity;

class CartEntity {
  final List<CartItemEntity> cartItems;
  CartEntity(this.cartItems);
  addCartItem(CartItemEntity cartItemEntity) {
    cartItems.add(cartItemEntity);
  }

  bool isExist(ProductEntity product) {
    for (var cartItem in cartItems) {
      if (cartItem.productEntity == product) return true;
    }
    return false;
  }
}
