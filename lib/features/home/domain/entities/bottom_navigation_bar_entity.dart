import 'package:fruits_hub/core/utils/app_images.dart';

class BottomNavigationBarEntity {
  final String activeImage, inActiveImage;
  final String title;
  BottomNavigationBarEntity({
    required this.activeImage,
    required this.inActiveImage,
    required this.title,
  });
}

List<BottomNavigationBarEntity> get bottomNavigationBarItems => [
  BottomNavigationBarEntity(
    activeImage: Assets.imagesVuesaxBoldHome,
    inActiveImage: Assets.imagesVuesaxOutlineHome,
    title: 'الرئيسية',
  ),
  BottomNavigationBarEntity(
    activeImage: Assets.imagesVuesaxBoldProducts,
    inActiveImage: Assets.imagesVuesaxOutlineProducts,
    title: 'المنتجات',
  ),
  BottomNavigationBarEntity(
    activeImage: Assets.imagesVuesaxBoldShoppingCart,
    inActiveImage: Assets.imagesVuesaxOutlineShoppingCart,
    title: 'سلة التسوق',
  ),
  BottomNavigationBarEntity(
    activeImage: Assets.imagesVuesaxBoldUser,
    inActiveImage: Assets.imagesVuesaxOutlineUser,
    title: 'حسابي',
  ),
];
