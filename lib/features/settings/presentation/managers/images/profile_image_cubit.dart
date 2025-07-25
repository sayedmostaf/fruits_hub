import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/functions/get_saved_user_data.dart';
import 'package:fruits_hub/core/repos/images/images_repo.dart';
import 'package:fruits_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:fruits_hub/features/settings/presentation/managers/images/profile_image_state.dart';

class ProfileImageCubit extends Cubit<ProfileImageState> {
  final ImagesRepo imagesRepo;
  final AuthRepo authRepo;
  ProfileImageCubit({required this.imagesRepo, required this.authRepo})
    : super(ProfileImageInitial());

  Future<void> setUserProfileImage({required File? imageFile}) async {
    emit(ProfileImageLoading());
    final uploadResult = await imagesRepo.uploadImage(imageFile);

    uploadResult.fold(
      (failure) => emit(ProfileImageFailure(errMessage: '❌ فشل رفع الصورة')),
      (newImageUrl) async {
        final updatedUser = getSavedUserData().copyWith(imageUrl: newImageUrl);
        final updateResult = await authRepo.updateUserData(
          userEntity: updatedUser,
        );
        updateResult.fold(
          (failure) => emit(
            ProfileImageFailure(errMessage: '❌ فشل تحديث بيانات المستخدم'),
          ),
          (_) async {
            emit(ProfileImageSuccess());
          },
        );
      },
    );
  }
}
