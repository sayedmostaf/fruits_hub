import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:fruits_hub/features/auth/presentation/managers/forget_password_cubit/forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthRepo authRepo;
  ForgetPasswordCubit(this.authRepo) : super(ForgetPasswordInitial());

  Future<void> sendPasswordResetEmail(String email) async {
    emit(ForgetPasswordLoading());
    try {
      await authRepo.sendPasswordResetEmail(email);
      emit(ForgetPasswordCodeSent());
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
    }
  }
}
