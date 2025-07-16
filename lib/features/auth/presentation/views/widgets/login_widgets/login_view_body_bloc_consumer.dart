import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/helper_functions/build_error_snack_bar.dart';
import 'package:fruits_hub/core/helper_functions/build_success_snack_bar.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/widgets/custom_progress_hub_widget.dart';
import 'package:fruits_hub/features/auth/presentation/managers/login_cubit/login_cubit.dart';
import 'package:fruits_hub/features/auth/presentation/managers/login_cubit/login_state.dart';
import 'package:fruits_hub/features/auth/presentation/views/widgets/login_widgets/login_view_body.dart';

class LoginViewBodyBlocConsumer extends StatelessWidget {
  const LoginViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          buildSuccessSnackBar(context, message: AppStrings.loginSuccess.tr());
        
        // TODO: go to home page
        }
        if (state is LoginFailure) {
          buildErrorSnackBar(context, message: state.errMessage.tr());
        }
      },
      builder: (context, state) {
        return CustomProgressHubWidget(
          isLoading: state is LoginLoading,
          child: LoginViewBody(),
        );
      },
    );
  }
}
