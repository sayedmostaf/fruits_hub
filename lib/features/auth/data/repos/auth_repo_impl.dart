import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruits_hub/core/errors/custom_exception.dart';
import 'package:fruits_hub/core/errors/failure.dart';
import 'package:fruits_hub/core/services/database_service.dart';
import 'package:fruits_hub/core/services/firebase_auth_service.dart';
import 'package:fruits_hub/core/services/shared_preferences.dart';
import 'package:fruits_hub/core/utils/backend_endpoints.dart';
import 'package:fruits_hub/core/utils/constants.dart';
import 'package:fruits_hub/features/auth/data/models/user_model.dart';
import 'package:fruits_hub/features/auth/domain/entities/user_entity.dart';
import 'package:fruits_hub/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final DatabaseService databaseService;
  AuthRepoImpl({
    required this.firebaseAuthService,
    required this.databaseService,
  });
  @override
  Future<void> addUserData({required UserEntity userEntity}) async {
    await databaseService.addDocument(
      path: BackendEndpoints.addUserData,
      data: UserModel.fromEntity(userEntity).toJson(),
      documentId: userEntity.uid,
    );
  }

  @override
  Future<Either<Failure, void>> changeUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await firebaseAuthService.changeUserPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return right(null);
    } on CustomException catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    User? user;
    try {
      user = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userEntity = UserEntity(name: name, email: email, uid: user.uid);
      await addUserData(userEntity: userEntity);
      return right(userEntity);
    } on CustomException catch (e) {
      await deleteUser(user);
      return left(ServerFailure(errMessage: e.toString()));
    } catch (e) {
      await deleteUser(user);
      log('❌ Exception from createUserWithEmailAndPassword: ${e.toString()}');
      return left(ServerFailure(errMessage: e.toString()));
    }
  }

  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }

  @override
  Future<UserEntity> getUserData({required String uid}) async {
    final data = await databaseService.getDocumentOrCollection(
      path: BackendEndpoints.getUserData,
      documentId: uid,
    );
    // it's should be a map
    if (data is List) {
      return UserModel.fromJson(data.first as Map<String, dynamic>);
    }
    return UserModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<bool> isUserExist({required String uid}) async {
    return await databaseService.isDocumentExist(
      path: BackendEndpoints.isUserExists,
      documentId: uid,
    );
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await firebaseAuthService.loginUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userEntity = await getUserData(uid: user.uid);
      await saveUserData(userEntity: userEntity);
      return right(userEntity);
    } on CustomException catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    } catch (e) {
      log('❌ Exception from loginUserWithPasswordAndEmail: ${e.toString()}');
      return left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<void> resetPassword(String password) async {
    await firebaseAuthService.resetPassword(password);
  }

  @override
  Future<void> saveUserData({required UserEntity userEntity}) async {
    final userJson = jsonEncode(UserModel.fromEntity(userEntity).toJson());
    await Pref.setString(Constants.userData, userJson);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuthService.sendPasswordResetEmail(email);
  }

  @override
  Future<String> sendVerificationCode(String phoneNumber) {
    return firebaseAuthService.sendVerificationCode(phoneNumber);
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() async {
    try {
      final user = await firebaseAuthService.signInWithFacebook();
      final userEntity = UserModel.fromFirebase(user);
      await saveUserData(userEntity: userEntity);
      return right(userEntity);
    } catch (e) {
      log('❌ Exception from signInWithFacebook(): ${e.toString()}');
      return left(
        ServerFailure(errMessage: 'opps there was an error, pls try later'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithGoogle();
      final bool exists = await isUserExist(uid: user.uid);
      late final UserEntity finalUserEntity;
      if (exists) {
        finalUserEntity = await getUserData(uid: user.uid);
      } else {
        finalUserEntity = UserModel.fromFirebase(user);
        await addUserData(userEntity: finalUserEntity);
      }
      await saveUserData(userEntity: finalUserEntity);
      return right(finalUserEntity);
    } catch (e) {
      await deleteUser(user);
      log('❌ Exception from signInWithGoogle(): ${e.toString()}');
      return left(
        ServerFailure(errMessage: 'Opps there was an error, pls try later'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await firebaseAuthService.signOut();
      await Pref.remove(Constants.userData);
      log('✅ User signed out successfully');
      return right(null);
    } catch (e) {
      log('❌ Error during sign out: ${e.toString()}');
      return left(
        ServerFailure(errMessage: 'حدث خطأ أثناء تسجيل الخروج، حاول مرة أخرى.'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateUserData({
    required UserEntity userEntity,
  }) async {
    try {
      await databaseService.addDocument(
        path: BackendEndpoints.updateUserData,
        data: UserModel.fromEntity(userEntity).toJson(),
        documentId: userEntity.uid,
      );
      await saveUserData(userEntity: userEntity);
      log('✅ User data updated successfully');
      return right(null);
    } catch (e) {
      log('❌ Error updating user data: ${e.toString()}');
      return left(ServerFailure(errMessage: '❌ Failed to update user data'));
    }
  }

  @override
  Future<void> verifyCode(String smsCode) async {
    await firebaseAuthService.verifyCode(smsCode);
  }
}
