import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/errors/failure.dart';
import 'package:fruits_hub/core/repos/images/images_repo.dart';

class ImagesRepoImpl extends ImagesRepo{
  @override
  Future<Either<Failure, String>> uploadImage(File? imageFile) {
    // TODO: implement uploadImage
    throw UnimplementedError();
  }
}
