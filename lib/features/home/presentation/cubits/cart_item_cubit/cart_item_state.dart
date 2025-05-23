import 'package:fruits_hub/features/home/domain/entities/cart_item_entity.dart';

sealed class CartItemState {}

class CartItemInitial extends CartItemState {}

class CartItemUpdated extends CartItemState {
  final CartItemEntity cartItemEntity;
  CartItemUpdated(this.cartItemEntity);
}
