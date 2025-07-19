import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_item_entity.dart';

sealed class CartItemState {}

final class CartItemInitial extends CartItemState {}

final class CartItemUpdatedState extends CartItemState {
  final CartItemEntity targetCartItem;
  CartItemUpdatedState({required this.targetCartItem});
}
