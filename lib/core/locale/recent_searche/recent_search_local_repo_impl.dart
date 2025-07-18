import 'package:fruits_hub/core/locale/recent_searche/recent_search_local_repo.dart';
import 'package:fruits_hub/core/utils/locale_box.dart';
import 'package:hive/hive.dart';

class RecentSearchLocalRepoImpl implements RecentSearchLocalRepo {
  final Box<List> _box = Hive.box<List>(LocaleBox.recentSearchBox);
  @override
  Future<List<String>> getRecentSearches() async {
    return _box.get(LocaleBox.recentSearchBox)?.cast<String>() ?? [];
  }

  @override
  Future<void> saveRecentSearch(List<String> search) async {
    await _box.put(LocaleBox.recentSearchBox, search);
  }

  @override
  Future<void> addSearch(String searchTerm) async {
    final current = await getRecentSearches();
    if (!current.contains(searchTerm)) {
      current.insert(0, searchTerm);
    }
    await saveRecentSearch(current.take(10).toList());
  }

  @override
  Future<void> removeAt(int index) async {
    final current = await getRecentSearches();

    if (index >= 0 && index < current.length) {
      current.removeAt(index);
      await saveRecentSearch(current);
    }
  }

  @override
  Future<void> clearAll() async {
    await _box.delete(LocaleBox.recentSearchBox);
  }
}
