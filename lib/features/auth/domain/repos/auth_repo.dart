import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/errors/failure.dart';
import 'package:fruits_hub/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> resetPassword(String password);
  Future<void> sendPasswordResetEmail(String email);

  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, UserEntity>> signInWithFacebook();
  Future<Either<Failure, void>> updateUserData({
    required UserEntity userEntity,
  });
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> changeUserPassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<String> sendVerificationCode(String phoneNumber);

  Future<void> verifyCode(String smsCode);

  Future<void> addUserData({required UserEntity userEntity});
  Future<void> saveUserData({required UserEntity userEntity});
  Future<UserEntity> getUserData({required String uid});
  Future<bool> isUserExist({required String uid});
}
