import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/repos/order/order_repo.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:fruits_hub/features/checkout/presentation/manager/order/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this.orderRepo) : super(OrderInitial());
  final OrderRepo orderRepo;
  Future<void> addOrder({required OrderEntity orderEntity}) async {
    emit(OrderLoadingState());
    final result = await orderRepo.addOrder(orderEntity: orderEntity);
    result.fold(
      (failure) => emit(OrderFailureState(failure.errMessage)),
      (success) => emit(OrderSuccessState()),
    );
  }
}
