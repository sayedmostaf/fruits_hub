import 'package:hive/hive.dart';
part 'recent_search_entity.g.dart';

@HiveType(typeId: 0)
class RecentSearchEntity {
  @HiveField(0)
  List<String> recentSearches;
  RecentSearchEntity({required this.recentSearches});
}
