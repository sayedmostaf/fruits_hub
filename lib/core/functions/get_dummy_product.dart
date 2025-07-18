import 'package:fruits_hub/core/entities/product_entity.dart';

ProductEntity getDummyProduct() {
  return ProductEntity(
    name: '',
    code: '',
    description: '',
    price: 0,
    imageFilePath: null,
    expirationMonths: 0,
    isFeatured: false,
    isOrganic: false,
    addDate: DateTime.now(),
    unitCount: 0,
    avgRating: 0,
    reviewsCount: 0,
    numberOfCalories: 0,
    imageUrL: null,
    reviews: const [],
    sellingCount: 0,
  );
}

List<ProductEntity> getListOfDummyProducts() {
  return List.generate(5, (_) => getDummyProduct());
}
