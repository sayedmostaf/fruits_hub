abstract class RecentSearchLocalRepo {
  Future<List<String>> getRecentSearches();
  Future<void> saveRecentSearch(List<String> search);
  Future<void> addSearch(String searchTerm);
  Future<void> removeAt(int index);
  Future<void> clearAll();
}
