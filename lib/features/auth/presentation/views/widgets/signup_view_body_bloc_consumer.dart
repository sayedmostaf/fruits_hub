import 'package:flutter/material.dart';
import 'package:fruits_hub/core/helper_functions/build_error_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/features/auth/presentation/cubits/signup_cubits/signup_cubit.dart';
import 'package:fruits_hub/features/auth/presentation/cubits/signup_cubits/signup_state.dart';
import 'package:fruits_hub/features/auth/presentation/views/widgets/signup_view_body.dart';

class SignupViewBodyBlocConsumer extends StatelessWidget {
  const SignupViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is SignupLoading ? true : false,
          child: SignupViewBody(),
        );
      },
      listener: (context, state) {
        if (state is SignupSuccess) {
          Navigator.pop(context);
        }
        if (state is SignupFailure) {
          showBar(context, state.message);
        }
      },
    );
  }
}
