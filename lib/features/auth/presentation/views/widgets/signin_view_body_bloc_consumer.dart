import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/widgets/custom_progress_hud.dart';
import 'package:fruits_hub/features/auth/presentation/cubits/signin_cubits/signin_cubit.dart';
import 'package:fruits_hub/features/auth/presentation/cubits/signup_cubits/signup_state.dart';
import 'package:fruits_hub/features/auth/presentation/views/widgets/login_view_body.dart';

class SigninViewBodyBlocConsumer extends StatelessWidget {
  const SigninViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninCubit, SigninState>(
      builder: (context, state) {
        return CustomProgressHud(
          isLoading: state is SignupLoading ? true : false,
          child: SigninViewBody(),
        );
      },
      listener: (context, state) {},
    );
  }
}
