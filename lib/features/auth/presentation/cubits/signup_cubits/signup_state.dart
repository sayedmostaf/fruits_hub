import 'package:fruits_hub/features/auth/domain/entities/user_entity.dart';

sealed class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final UserEntity userEntity;
  SignupSuccess({required this.userEntity});
}

class SignupFailure extends SignupState {
  final String message;
  SignupFailure({required this.message});
}
