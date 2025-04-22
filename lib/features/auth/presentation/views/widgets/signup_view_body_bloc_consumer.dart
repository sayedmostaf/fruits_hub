import 'package:flutter/widgets.dart';
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
        return SignupViewBody();
      },
      listener: (context, state) {},
    );
  }
}
