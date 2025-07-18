import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/functions/build_error_snack_bar.dart';
import 'package:fruits_hub/core/functions/build_success_snack_bar.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/widgets/custom_progress_hub_widget.dart';
import 'package:fruits_hub/features/auth/presentation/managers/signup_cubit.dart/signup_cubit.dart';
import 'package:fruits_hub/features/auth/presentation/managers/signup_cubit.dart/signup_state.dart';
import 'package:fruits_hub/features/auth/presentation/views/widgets/sign_up_widgets/sign_up_view_body.dart';

class SignUpViewBodyBlocConsumer extends StatelessWidget {
  const SignUpViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          Navigator.pop(context, context.read<SignupCubit>().loginUserData);
          buildSuccessSnackBar(context, message: AppStrings.signupSuccess.tr());
        }
        if (state is SignupFailure) {
          buildErrorSnackBar(context, message: state.errMessage);
        }
      },
      builder: (context, state) {
        return CustomProgressHubWidget(
          isLoading: state is SignupLoading,
          child: SignUpViewBody(),
        );
      },
    );
  }
}
