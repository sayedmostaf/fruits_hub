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
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                children: [
                  SizedBox(height: 24),
                  CustomTextFormField(
                    onSaved: (value) {
                      name = value!;
                    },
                    hintText: AppStrings.fullName.tr(),
                    textInputType: TextInputType.name,
                  ),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    onSaved: (value) {
                      email = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.enterEmailRequired.tr();
                      }
                      final emailRegExp = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegExp.hasMatch(value)) {
                        return AppStrings.invalidEmailFormat.tr();
                      }
                      return null;
                    },
                    hintText: AppStrings.emailHint.tr(),
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  CustomPasswordFormField(
                    onSaved: (value) {
                      password = value!;
                    },
                  ),
                  SizedBox(height: 16),
                  TermsAndConditionsWidget(
                    onChange: (currentState) {
                      isTermsAccepted = currentState;
                    },
                  ),
                  Expanded(child: SizedBox(height: 30)),
                  CustomButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        if (isTermsAccepted) {
                          context
                              .read<SignupCubit>()
                              .createUserWithEmailAndPassword(
                                name: name,
                                email: email,
                                password: password,
                              );
                        } else {
                          buildErrorSnackBar(
                            context,
                            message: AppStrings.acceptTermsFirst.tr(),
                          );
                        }
                      } else {
                        setState(() {
                          autovalidateMode = AutovalidateMode.always;
                        });
                      }
                    },
                    text: AppStrings.createNewAccount.tr(),
                  ),
                  SizedBox(height: 30),
                  HaveAnAccountWidget(),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
