import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:fruits_hub/core/services/storage_service.dart';
import 'package:fruits_hub/core/utils/backend_endpoints.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService extends StorageService {
  static late Supabase _supabase;

  static Future<void> init() async {
    _supabase = await Supabase.initialize(
      url: BackendEndpoints.supabaseUrl,
      anonKey: BackendEndpoints.supabaseKey,
    );
  }

  @override
  Future<bool> fileExistsFromUrl({required String publicUrl}) async {
    try {
      final uri = Uri.parse(publicUrl);
      final response = await http.head(uri);
      return response.statusCode == 200;
    } catch (e) {
      log('❌ Error checking file existence from URL: ${e.toString()}');
      return false;
    }
  }

  @override
  Future<String> getPublicUrl({required String path}) async {
    return _supabase.client.storage
        .from(BackendEndpoints.profileImages)
        .getPublicUrl(path);
  }

  @override
  Future<String> uploadFile({required File? file, required String path}) async {
    if (file == null) {
      throw Exception('File is null');
    }
    final String fileName = basename(file.path);
    final String filePath = '$path/$fileName';
    await _supabase.client.storage
        .from(BackendEndpoints.profileImages)
        .upload(filePath, file);
    final String publicUrl = _supabase.client.storage
        .from(BackendEndpoints.profileImages)
        .getPublicUrl(filePath);
    return publicUrl;
  }
}
