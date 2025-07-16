import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/widgets/custom_button.dart';
import 'package:fruits_hub/core/utils/widgets/custom_or_divider.dart';
import 'package:fruits_hub/core/utils/widgets/custom_text_form_field.dart';
import 'package:fruits_hub/features/auth/presentation/managers/login_cubit/login_cubit.dart';
import 'package:fruits_hub/features/auth/presentation/views/widgets/custom_password_form_field.dart';
import 'package:fruits_hub/features/auth/presentation/views/widgets/custom_social_buttons.dart';
import 'package:fruits_hub/features/auth/presentation/views/widgets/do_not_have_an_account_widget.dart';
import 'package:provider/provider.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String email, password;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            children: [
              SizedBox(height: 24),
              CustomTextFormField(
                hintText: AppStrings.emailHint.tr(),
                textInputType: TextInputType.emailAddress,
                onSaved: (value) => email = value!,
              ),
              const SizedBox(height: 16),
              CustomPasswordFormField(onSaved: (value) => password = value!),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      //TODO: handle navigate to forgot password
                    },
                    child: Text(
                      AppStrings.forgetPassword.tr(),
                      style: AppTextStyle.textStyle13w600.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 33),
              CustomButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    context.read<LoginCubit>().loginUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                  } else {
                    autovalidateMode = AutovalidateMode.always;
                    setState(() {});
                  }
                },
                text: AppStrings.login.tr(),
              ),
              const SizedBox(height: 33),
              DoNotHaveAnAccountWidget(),
              CustomOrDivider(),
              const SizedBox(height: 33),
              CustomSocialButtons(
                onPressed: () {
                  context.read<LoginCubit>().loginWithGoogleAccount();
                },
                text: AppStrings.loginWithGoogle.tr(),
                iconData: Assets.imagesGoogleIcon,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
