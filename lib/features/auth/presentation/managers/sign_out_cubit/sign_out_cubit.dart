import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:fruits_hub/features/auth/presentation/managers/sign_out_cubit/sign_out_state.dart';

class SignOutCubit extends Cubit<SignOutState> {
  final AuthRepo authRepo;
  SignOutCubit(this.authRepo) : super(SignOutInitial());
  Future<void> signOut() async {
    emit(SignOutLoading());
    final result = await authRepo.signOut();

    result.fold(
      (failure) => emit(SignOutFailure(errMessage: failure.errMessage)),
      (_) => emit(SignOutSuccess()),
    );
  }
}
