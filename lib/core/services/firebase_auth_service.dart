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
        throw CustomException('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException('The account already exists for that email.');
      } else {
        throw CustomException('An error occurred. Please try again later.');
      }
    } catch (e) {
      throw CustomException('An error occurred. Please try again later.');
    }
  }
}
