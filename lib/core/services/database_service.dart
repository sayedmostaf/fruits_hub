abstract class DatabaseService {
  Future<void> addDocument({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  });
  Future<dynamic> getDocumentOrCollection({
    required String path,
    String? documentId,
    Map<String, dynamic>? queries,
  });
  Future<bool> isDocumentExist({required String path, required documentId});
}
