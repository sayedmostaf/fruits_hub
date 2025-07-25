import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/functions/build_error_snack_bar.dart';
import 'package:fruits_hub/core/functions/build_success_snack_bar.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/constants.dart';
import 'package:fruits_hub/core/utils/widgets/custom_progress_hub_widget.dart';
import 'package:fruits_hub/features/auth/presentation/managers/sign_out_cubit/sign_out_cubit.dart';
import 'package:fruits_hub/features/auth/presentation/managers/sign_out_cubit/sign_out_state.dart';

class SignOutBlocConsumer extends StatelessWidget {
  const SignOutBlocConsumer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignOutCubit, SignOutState>(
      listener: (context, state) {
        if (state is SignOutSuccess) {
          buildSuccessSnackBar(context, message: AppStrings.signOut.tr());
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              Constants.loginViewRoute,
              (route) => false,
            );
          });
        }
        if (state is SignOutFailure) {
          buildErrorSnackBar(context, message: state.errMessage);
        }
      },
      builder: (context, state) {
        return CustomProgressHubWidget(
          isLoading: state is SignOutLoading,
          child: child,
        );
      },
    );
  }
}
