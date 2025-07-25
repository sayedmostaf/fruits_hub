sealed class ProfileImageState {}

final class ProfileImageInitial extends ProfileImageState {}

final class ProfileImageFailure extends ProfileImageState {
  final String errMessage;
  ProfileImageFailure({required this.errMessage});
}

final class ProfileImageSuccess extends ProfileImageState {}

final class ProfileImageLoading extends ProfileImageState {}
