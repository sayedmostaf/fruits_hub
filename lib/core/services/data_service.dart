abstract class DatabaseService {
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
  });
  Future<void> getUserData({required String path, required String uId});
}
