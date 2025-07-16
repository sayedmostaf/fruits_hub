import 'package:fruits_hub/features/auth/domain/entities/user_entity.dart';

sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserEntity userEntity;
  LoginSuccess({required this.userEntity});
}

class LoginFailure extends LoginState {
  final String errMessage;
  LoginFailure({required this.errMessage});
}
