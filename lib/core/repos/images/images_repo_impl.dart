import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/errors/failure.dart';
import 'package:fruits_hub/core/repos/images/images_repo.dart';
import 'package:fruits_hub/core/services/storage_service.dart';
import 'package:fruits_hub/core/utils/backend_endpoints.dart';
import 'package:path/path.dart';

class ImagesRepoImpl extends ImagesRepo {
  final StorageService storageService;
  ImagesRepoImpl({required this.storageService});
  @override
  Future<Either<Failure, String>> uploadImage(File? imageFile) async {
    try {
      if (imageFile == null) {
        return left(ServerFailure(errMessage: '❌ No image file provided'));
      }
      final String fileName = basename(imageFile.path);
      final String filePath = '${BackendEndpoints.profileImages}/$fileName';
      final String publicUrl = await storageService.getPublicUrl(
        path: filePath,
      );
      final bool exists = await storageService.fileExistsFromUrl(
        publicUrl: publicUrl,
      );
      if (exists) {
        log('⚠️ File already exists, returning existing URL');
        return right(publicUrl);
      } else {
        final String uploadedUrl = await storageService.uploadFile(
          file: imageFile,
          path: BackendEndpoints.profileImages,
        );
        log("✅ Uploaded image URL: $uploadedUrl");
        return right(uploadedUrl);
      }
    } catch (e) {
      log('❌ ImageRepoImpl.uploadImage: ${e.toString()}');
      return left(ServerFailure(errMessage: '❌ can not upload the image'));
    }
  }
}
