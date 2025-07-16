import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:fruits_hub/features/auth/presentation/managers/login_cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;
  LoginCubit(this.authRepo) : super(LoginInitial());

  Future<void> loginUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    final result = await authRepo.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(LoginFailure(errMessage: failure.errMessage)),
      (userEntity) => emit(LoginSuccess(userEntity: userEntity)),
    );
  }

  Future<void> loginWithGoogleAccount() async {
    emit(LoginLoading());
    final result = await authRepo.signInWithGoogle();
    result.fold(
      (failure) => emit(LoginFailure(errMessage: failure.errMessage)),
      (userEntity) => emit(LoginSuccess(userEntity: userEntity)),
    );
  }

  Future<void> loginWithFacebookAccount() async {
    emit(LoginLoading());
    final result = await authRepo.signInWithFacebook();
    result.fold(
      (failure) => emit(LoginFailure(errMessage: failure.errMessage)),
      (userEntity) => emit(LoginSuccess(userEntity: userEntity)),
    );
  }
}
