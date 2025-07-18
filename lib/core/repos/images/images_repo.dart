import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/errors/failure.dart';

abstract class ImagesRepo {
  Future<Either<Failure, String>> uploadImage(File? imageFile);
}
