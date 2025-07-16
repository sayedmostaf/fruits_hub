import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fruits_hub/core/errors/custom_exception.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  String? _verificationId;
  Future<void> deleteUser() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }

  Future<void> verifyCode(String smsCode) async {
    if (_verificationId == null) {
      throw CustomException('لم يتم إرسال كود التحقق بعد');
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        throw const CustomException('كود التحقق غير صحيح');
      } else if (e.code == 'session-expired') {
        throw const CustomException('انتهت صلاحية الجلسة، أرسل الكود مرة أخرى');
      } else {
        throw CustomException(e.message ?? 'حدث خطأ أثناء التحقق من الكود');
      }
    } catch (e) {
      throw CustomException('حدث خطأ غير متوقع أثناء التحقق من الكود');
    }
  }

  Future<void> resetPassword(String password) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw CustomException('لم يتم تسجيل الدخول');
    }

    try {
      await user.updatePassword(password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw const CustomException('weak_password');
      } else if (e.code == 'requires-recent-login') {
        throw const CustomException('requires_recent_login');
      } else {
        throw CustomException(e.message ?? 'password_reset_failed');
      }
    } catch (e) {
      throw const CustomException('unexpected_error');
    }
  }

  Future<String> sendVerificationCode(String phoneNumber) async {
    final Completer<String> completer = Completer<String>();

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (_) {},
        verificationFailed: (FirebaseAuthException e) {
          log('❌ Verification Failed: ${e.message}');
          completer.completeError(
            CustomException('فشل إرسال الكود، حاول مرة أخرى'),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          log('✅ Code Sent, verificationId: $verificationId');
          _verificationId = verificationId;
          completer.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (e) {
      completer.completeError(CustomException('حدث خطأ أثناء إرسال الكود'));
    }
    return completer.future;
  }

  Future<void> signOut() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null &&
          user.providerData.any(
            (element) => element.providerId == 'google.com',
          )) {
        final googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      log('❌ Error during signOut: $e');
      throw const CustomException('حدث خطأ أثناء تسجيل الخروج، حاول مرة أخرى.');
    }
  }

  String? getCurrentUserProviderId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.providerData.isNotEmpty) {
      return user.providerData.first.providerId;
    }
    return null;
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
        'Exception from FirebaseAuthService.createUserWithEmailAndPassword(): ${e.toString()} and Code = ${e.code}',
      );
      if (e.code == 'weak-password') {
        throw const CustomException('كلمة المرور ضعيفة جدًا');
      } else if (e.code == 'email-already-in-use') {
        throw const CustomException('هذا البريد الإلكتروني مستخدم بالفعل');
      } else if (e.code == 'network-request-failed') {
        throw const CustomException('تحقق من الاتصال بالإنترنت');
      } else {
        throw const CustomException('حدث خطأ ما، حاول لاحقًا');
      }
    } catch (e) {
      log(
        'Exception from FirebaseAuthService.createUserWithEmailAndPassword(): ${e.toString()}',
      );
      throw const CustomException('حدث خطأ ما، حاول لاحقًا');
    }
  }

  Future<User> loginUserWithEmailAndPassword({
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
        'Exception from FirebaseAuthService.loginUserWithEmailAndPassword(): ${e.toString()} and Code = ${e.code}',
      );
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw const CustomException(
          'البريد الإلكتروني أو كلمة المرور غير صحيحة',
        );
      } else if (e.code == 'network-request-failed') {
        throw const CustomException('تحقق من الاتصال بالإنترنت');
      } else {
        throw const CustomException('حدث خطأ ما، حاول لاحقًا');
      }
    } catch (e) {
      log(
        'Exception from FirebaseAuthService.loginUserWithEmailAndPassword(): ${e.toString()}',
      );
      throw const CustomException('حدث خطأ ما، حاول لاحقًا');
    }
  }

  Future<void> changeUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      throw const CustomException('المستخدم غير موجود');
    }

    if (currentPassword == newPassword) {
      throw const CustomException(
        'كلمة المرور الجديدة لا يمكن أن تكون مثل الحالية',
      );
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      log('❌ FirebaseAuthService.changeUserPassword(): ${e.message}');
      if (e.code == 'wrong-password') {
        throw const CustomException('كلمة المرور الحالية غير صحيحة');
      } else if (e.code == 'weak-password') {
        throw const CustomException('كلمة المرور الجديدة ضعيفة جدًا');
      } else if (e.code == 'requires-recent-login') {
        throw const CustomException('يرجى تسجيل الدخول مرة أخرى ثم المحاولة');
      } else {
        throw CustomException(e.message ?? 'فشل تغيير كلمة المرور');
      }
    } catch (e) {
      log('❌ Error in changeUserPassword: $e');
      throw const CustomException('حدث خطأ غير متوقع أثناء تغيير كلمة المرور');
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
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    return (await FirebaseAuth.instance.signInWithCredential(
      facebookAuthCredential,
    )).user!;
  }

  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw const CustomException('البريد الإلكتروني غير مسجل');
      } else if (e.code == 'invalid-email') {
        throw const CustomException('صيغة البريد الإلكتروني غير صحيحة');
      } else {
        throw CustomException(
          e.message ?? 'فشل إرسال البريد الإلكتروني لإعادة التعيين',
        );
      }
    } catch (e) {
      throw const CustomException('حدث خطأ غير متوقع');
    }
  }
}
