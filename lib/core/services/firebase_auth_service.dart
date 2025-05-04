import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fruits_hub/core/errors/exceptions.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  Future deleteUser() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }

  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        "Exception in FirebaseAuthService.createUserWithEmailAndPassword: ${e.toString()} and code is ${e.code}",
      );
      if (e.code == 'weak-password') {
        throw CustomException('الرقم السري ضعيف جداً.');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException('لقد قمت بالتسجيل مسبقاً. الرجاء تسجيل الدخول.');
      } else if (e.code == 'network-request-failed') {
        throw CustomException('تاكد من اتصالك بالانترنت.');
      } else {
        throw CustomException('لقد حدث خطأ ما. الرجاء المحاولة مرة اخرى.');
      }
    } catch (e) {
      log(
        "Exception in FirebaseAuthService.createUserWithEmailAndPassword: ${e.toString()}",
      );
      throw CustomException('لقد حدث خطأ ما. الرجاء المحاولة مرة اخرى.');
    }
  }

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        "Exception in FirebaseAuthService.signInWithEmailAndPassword: ${e.toString()} and code is ${e.code}",
      );
      if (e.code == 'user-not-found') {
        throw CustomException('الرقم السري او البريد الالكتروني غير صحيح.');
      } else if (e.code == 'wrong-password') {
        throw CustomException('الرقم السري او البريد الالكتروني غير صحيح.');
      } else if (e.code == 'network-request-failed') {
        throw CustomException('تاكد من اتصالك بالانترنت.');
      } else {
        throw CustomException('لقد حدث خطأ ما. الرجاء المحاولة مرة اخرى.');
      }
    } catch (e) {
      log(
        "Exception in FirebaseAuthService.signInWithEmailAndPassword: ${e.toString()}",
      );
      throw CustomException('لقد حدث خطأ ما. الرجاء المحاولة مرة اخرى.');
    }
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return (await FirebaseAuth.instance.signInWithCredential(credential)).user!;
  }

  Future<User> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential credential = FacebookAuthProvider.credential(
      loginResult.accessToken!.tokenString,
    );
    return (await FirebaseAuth.instance.signInWithCredential(credential)).user!;
  }
}
