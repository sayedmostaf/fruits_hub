import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/constants.dart';
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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: size.height - (size.height * 0.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.welcomeBack.tr(),
                    style: AppTextStyle.textStyle24w700.copyWith(
                      color: theme.colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.loginToContinue.tr(),
                    style: AppTextStyle.textStyle16w400.copyWith(
                      color: theme.hintColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  CustomTextFormField(
                    hintText: AppStrings.emailHint.tr(),
                    textInputType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email_outlined, size: 20),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.fieldRequired.tr();
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return AppStrings.invalidEmailFormat.tr();
                      }
                      return null;
                    },
                    onSaved: (value) => email = value!,
                  ),
                  const SizedBox(height: 16),
                  CustomPasswordFormField(
                    onSaved: (value) => password = value!,
                    hintText: AppStrings.passwordHint.tr(),
                    prefixIcon: Icon(Icons.lock_outline, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Constants.forgetPasswordViewRoute,
                        );
                      },
                      child: Text(
                        AppStrings.forgetPassword.tr(),
                        style: AppTextStyle.textStyle13w600.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    onPressed: _submitForm,
                    text: AppStrings.login.tr(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            DoNotHaveAnAccountWidget(),
            const SizedBox(height: 32),
            const CustomOrDivider(),
            const SizedBox(height: 32),
            CustomSocialButtons(
              onPressed: () {
                context.read<LoginCubit>().loginWithGoogleAccount();
              },
              text: AppStrings.loginWithGoogle.tr(),
              iconData: Assets.imagesGoogleIcon,
            ),
            const SizedBox(height: 16),
            CustomSocialButtons(
              onPressed: () {
                // Add Facebook login functionality
              },
              text: AppStrings.loginWithFacebook.tr(),
              iconData: Assets.imagesFacebookIcon,
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() => isLoading = true);
      context.read<LoginCubit>().loginUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } else {
      setState(() => autovalidateMode = AutovalidateMode.always);
    }
  }
}
