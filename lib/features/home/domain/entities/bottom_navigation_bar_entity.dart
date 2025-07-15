import 'package:fruits_hub/core/utils/app_images.dart';

class BottomNavigationBarEntity {
  final String nameKey, activeTag, inActiveTag;
  const BottomNavigationBarEntity({
    required this.nameKey,
    required this.activeTag,
    required this.inActiveTag,
  });
  String get translatedName => nameKey;
}

List<BottomNavigationBarEntity> get bottomNavigationBarTags => [
  BottomNavigationBarEntity(
    nameKey: 'home',
    activeTag: Assets.imagesVuesaxBoldHome,
    inActiveTag: Assets.imagesVuesaxOutlineHome,
  ),
  BottomNavigationBarEntity(
    nameKey: 'products',
    activeTag: Assets.imagesVuesaxBoldProducts,
    inActiveTag: Assets.imagesVuesaxOutlineProducts,
  ),
  BottomNavigationBarEntity(
    nameKey: 'cart',
    activeTag: Assets.imagesVuesaxBoldShoppingCart,
    inActiveTag: Assets.imagesVuesaxOutlineShoppingCart,
  ),
  BottomNavigationBarEntity(
    nameKey: 'account',
    activeTag: Assets.imagesVuesaxBoldUser,
    inActiveTag: Assets.imagesVuesaxOutlineUser,
  ),
];
