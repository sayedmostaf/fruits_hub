import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/functions/build_error_snack_bar.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/constants.dart';
import 'package:fruits_hub/core/utils/widgets/custom_button.dart';
import 'package:fruits_hub/core/utils/widgets/custom_text_form_field.dart';
import 'package:fruits_hub/features/auth/presentation/managers/forget_password_cubit/forget_password_cubit.dart';
import 'package:fruits_hub/features/auth/presentation/managers/forget_password_cubit/forget_password_state.dart';

class ForgetPasswordViewBody extends StatefulWidget {
  const ForgetPasswordViewBody({super.key});

  @override
  State<ForgetPasswordViewBody> createState() => _ForgetPasswordViewBodyState();
}

class _ForgetPasswordViewBodyState extends State<ForgetPasswordViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordFailure) {
          buildErrorSnackBar(context, message: state.errMessage.tr());
        } else if (state is ForgetPasswordCodeSent) {
          showGeneralDialog(
            context: context,
            barrierDismissible: false,
            barrierLabel: 'check_email',
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) {
              return AlertDialog(
                title: Text(AppStrings.checkEmailTitle.tr()),
                content: Text(AppStrings.checkEmailMessage.tr()),
                actions: [
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Constants.loginViewRoute,
                        (route) => false,
                      );
                    },
                    child: Text(AppStrings.goToLogin.tr()),
                  ),
                ],
              );
            },
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ForgetPasswordCubit>();
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  AppStrings.forgotPasswordTitle.tr(),
                  style: AppTextStyle.textStyle24w700.copyWith(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppStrings.forgotPasswordSubtitle.tr(),
                  style: AppTextStyle.textStyle14w400.copyWith(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextFormField(
                  controller: _emailController,
                  hintText: AppStrings.emailHint.tr(),
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.enterEmailRequired.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text:
                      state is ForgetPasswordLoading
                          ? ''
                          : AppStrings.sendCode.tr(),
                  onPressed: () {
                    if (state is ForgetPasswordLoading) return;
                    if (_formKey.currentState!.validate()) {
                      cubit.sendPasswordResetEmail(_emailController.text);
                    }
                  },
                  child:
                      state is ForgetPasswordLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : null,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
