import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:fruits_hub/features/auth/presentation/managers/signup_cubit.dart/signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepo authRepo;
  SignupCubit(this.authRepo) : super(SignupInitial());

  LoginUserData loginUserData = LoginUserData(email: '', password: '');
  Future<void> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignupLoading());
    final userData = await authRepo.createUserWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
    loginUserData = LoginUserData(email: email, password: password);
    userData.fold(
      (failure) => emit(SignupFailure(errMessage: failure.errMessage)),
      (userEntity) => emit(SignupSuccess(userEntity: userEntity)),
    );
  }
}

class LoginUserData {
  final String email, password;
  LoginUserData({required this.email, required this.password});
}
