import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruits_hub/core/errors/esceptions.dart';

class FirebaseAuthService {
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw CustomException('الرقم السري ضعيف جداً.');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException('لقد قمت بالتسجيل مسبقاً. الرجاء تسجيل الدخول.');
      } else {
        throw CustomException('لقد حدث خطأ ما. الرجاء المحاولة مرة اخرى.');
      }
    } catch (e) {
      throw CustomException('لقد حدث خطأ ما. الرجاء المحاولة مرة اخرى.');
    }
  }
}
