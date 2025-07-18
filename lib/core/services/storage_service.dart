import 'dart:io';

abstract class StorageService {
  Future<String> uploadFile({required File? file, required String path});
  Future<bool> fileExistsFromUrl({required String publicUrl});
  Future<String> getPublicUrl({required String path});
}
