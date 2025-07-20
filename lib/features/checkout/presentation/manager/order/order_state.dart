sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class OrderLoadingState extends OrderState {}

final class OrderSuccessState extends OrderState {}

final class OrderFailureState extends OrderState {
  final String errMessage;
  OrderFailureState(this.errMessage);
}
