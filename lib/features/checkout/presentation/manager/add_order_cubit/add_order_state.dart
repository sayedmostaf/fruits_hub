import 'package:equatable/equatable.dart';

sealed class AddOrderState extends Equatable {
  const AddOrderState();
  @override
  List<Object?> get props => [];
}

class AddOrderInitial extends AddOrderState {}

class AddOrderLoading extends AddOrderState {}

class AddOrderSuccess extends AddOrderState {}

class AddOrderFailure extends AddOrderState {
  final String errMessage;
  const AddOrderFailure(this.errMessage);
}
