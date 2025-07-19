part of 'recent_search_entity.dart';

class RecentSearchesEntityAdapter extends TypeAdapter<RecentSearchEntity> {
  @override
  final int typeId = 0;

  @override
  RecentSearchEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentSearchEntity(
      recentSearches: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, RecentSearchEntity obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.recentSearches);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentSearchesEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
