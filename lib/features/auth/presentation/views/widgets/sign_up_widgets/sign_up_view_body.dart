import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/functions/build_error_snack_bar.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/widgets/custom_button.dart';
import 'package:fruits_hub/core/utils/widgets/custom_text_form_field.dart';
import 'package:fruits_hub/features/auth/presentation/managers/signup_cubit.dart/signup_cubit.dart';
import 'package:fruits_hub/features/auth/presentation/views/widgets/custom_password_form_field.dart';
import 'package:fruits_hub/features/auth/presentation/views/widgets/have_an_account_widget.dart';
import 'package:fruits_hub/features/auth/presentation/views/widgets/terms_and_conditions_widget.dart';
import 'package:provider/provider.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String name, email, password;
  bool isTermsAccepted = false;
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
            Text(
              AppStrings.createAccountNow.tr(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AppStrings.fillDetailsToContinue.tr()',
              style: TextStyle(fontSize: 16, color: theme.hintColor),
            ),
            const SizedBox(height: 32),
            Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                children: [
                  CustomTextFormField(
                    onSaved: (value) => name = value!,
                    hintText: AppStrings.fullName.tr(),
                    textInputType: TextInputType.name,
                    prefixIcon: Icon(Icons.person_outline, size: 20),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.fieldRequired.tr();
                      }
                      if (value.length < 3) {
                        return 'AppStrings.nameTooShort.tr()';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    onSaved: (value) => email = value!,
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
                    hintText: AppStrings.emailHint.tr(),
                    textInputType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email_outlined, size: 20),
                  ),
                  const SizedBox(height: 16),
                  CustomPasswordFormField(
                    onSaved: (value) => password = value!,
                    hintText: AppStrings.passwordHint.tr(),
                    prefixIcon: Icon(Icons.lock_outline, size: 20),
                  ),
                  const SizedBox(height: 16),
                  TermsAndConditionsWidget(
                    onChange: (currentState) {
                      setState(() => isTermsAccepted = currentState);
                    },
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    onPressed: _submitForm,
                    text: AppStrings.createNewAccount.tr(),
                  ),
                  const SizedBox(height: 24),
                  HaveAnAccountWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (isTermsAccepted) {
        setState(() => isLoading = true);
        context.read<SignupCubit>().createUserWithEmailAndPassword(
          name: name,
          email: email,
          password: password,
        );
      } else {
        buildErrorSnackBar(context, message: AppStrings.acceptTermsFirst.tr());
      }
    } else {
      setState(() => autovalidateMode = AutovalidateMode.always);
    }
  }
}
