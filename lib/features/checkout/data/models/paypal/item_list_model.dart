import 'package:fruits_hub/features/checkout/data/models/paypal/item_model.dart';
import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_item_entity.dart';

class ItemListModel {
  List<ItemModel>? items;
  ItemListModel({this.items});
  factory ItemListModel.fromEntity({
    required List<CartItemEntity> cartItemsEntities,
  }) {
    return ItemListModel(
      items:
          cartItemsEntities
              .map((cartItem) => ItemModel.fromEntity(cartItemEntity: cartItem))
              .toList(),
    );
  }

  Map<dynamic, dynamic> toJson() => {
    "items":
        items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}
