part of 'product_entity.dart';

class ProductEntityAdapter extends TypeAdapter<ProductEntity> {
  @override
  final int typeId = 1;

  @override
  ProductEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductEntity(
      name: fields[0] as String,
      code: fields[1] as String,
      description: fields[2] as String,
      price: fields[3] as double,
      expirationMonths: fields[4] as int,
      isFeatured: fields[5] as bool,
      isOrganic: fields[6] as bool,
      addDate: fields[7] as DateTime,
      unitCount: fields[8] as int,
      avgRating: fields[9] as num,
      reviewsCount: fields[10] as int,
      numberOfCalories: fields[11] as int,
      reviews: (fields[12] as List).cast<ReviewEntity>(),
      sellingCount: fields[13] as int,
      imageUrL: fields[14] as String?,
      imageFilePath: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductEntity obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.expirationMonths)
      ..writeByte(5)
      ..write(obj.isFeatured)
      ..writeByte(6)
      ..write(obj.isOrganic)
      ..writeByte(7)
      ..write(obj.addDate)
      ..writeByte(8)
      ..write(obj.unitCount)
      ..writeByte(9)
      ..write(obj.avgRating)
      ..writeByte(10)
      ..write(obj.reviewsCount)
      ..writeByte(11)
      ..write(obj.numberOfCalories)
      ..writeByte(12)
      ..write(obj.reviews)
      ..writeByte(13)
      ..write(obj.sellingCount)
      ..writeByte(14)
      ..write(obj.imageUrL)
      ..writeByte(15)
      ..write(obj.imageFilePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
