import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/functions/get_saved_user_data.dart';
import 'package:fruits_hub/features/auth/domain/entities/user_entity.dart';
import 'package:fruits_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:fruits_hub/features/settings/presentation/managers/profile/profile_states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.authRepo) : super(ProfileInitial());

  final AuthRepo authRepo;

  Future<void> updateProfileData({
    required UserEntity updatedUser,
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ProfileLoading());

    final oldUserData = getSavedUserData();

    final updateResult = await authRepo.updateUserData(userEntity: updatedUser);

    await updateResult.fold(
      (failure) async {
        emit(ProfileFailure(errMessage: failure.errMessage));
      },
      (_) async {
        final isThirdPartyLogin =
            currentPassword.isEmpty && newPassword.isEmpty;

        if (isThirdPartyLogin) {
          emit(ProfileSuccess());
          return;
        }

        final passwordResult = await authRepo.changeUserPassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );

        await passwordResult.fold(
          (failure) async {
            final rollbackResult = await authRepo.updateUserData(
              userEntity: oldUserData,
            );
            rollbackResult.fold(
              (rollbackFailure) {
                emit(
                  ProfileFailure(
                    errMessage:
                        '${failure.errMessage} — فشل استرجاع البيانات القديمة: ${rollbackFailure.errMessage}',
                  ),
                );
              },
              (_) {
                emit(ProfileFailure(errMessage: failure.errMessage));
              },
            );
          },
          (_) async {
            emit(ProfileSuccess());
          },
        );
      },
    );
  }
}
