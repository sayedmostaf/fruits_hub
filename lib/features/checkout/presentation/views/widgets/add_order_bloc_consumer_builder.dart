import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/functions/build_error_snack_bar.dart';
import 'package:fruits_hub/core/functions/build_success_snack_bar.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/widgets/custom_progress_hub_widget.dart';
import 'package:fruits_hub/features/checkout/presentation/manager/order/order_cubit.dart';
import 'package:fruits_hub/features/checkout/presentation/manager/order/order_state.dart';

class AddOrderBlocConsumerBuilder extends StatelessWidget {
  const AddOrderBlocConsumerBuilder({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderFailureState) {
          buildErrorSnackBar(context, message: state.errMessage);
        }
        if (state is OrderSuccessState) {
          buildSuccessSnackBar(
            context,
            message: AppStrings.paymentSuccess.tr(),
          );
        }
      },
      builder: (context, state) {
        return CustomProgressHubWidget(
          isLoading: state is OrderLoadingState,
          child: child,
        );
      },
    );
  }
}
