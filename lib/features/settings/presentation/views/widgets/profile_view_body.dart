import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/functions/get_saved_user_data.dart';
import 'package:fruits_hub/core/services/firebase_auth_service.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/widgets/custom_button.dart';
import 'package:fruits_hub/core/utils/widgets/custom_text_form_field.dart';
import 'package:fruits_hub/features/auth/presentation/views/widgets/custom_password_form_field.dart';
import 'package:fruits_hub/features/settings/presentation/managers/profile/profile_cubit.dart';
import 'package:provider/provider.dart';

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});

  @override
  State<ProfileViewBody> createState() => ProfileViewBodyState();
}

class ProfileViewBodyState extends State<ProfileViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController checkPasswordController = TextEditingController();

  late String name, email;
  bool isSocialAccount = false;

  @override
  void initState() {
    super.initState();
    _checkIfSocialAccount();
  }

  Future<void> _checkIfSocialAccount() async {
    final providerData = FirebaseAuthService().getCurrentUserProviderId();
    setState(() {
      isSocialAccount = providerData != 'password';
    });
  }

  void clearControllers() {
    newPasswordController.clear();
    currentPasswordController.clear();
    checkPasswordController.clear();
    setState(() {});
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    currentPasswordController.dispose();
    checkPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        autovalidateMode: autovalidateMode,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  AppStrings.personalInfo.tr(),
                  style: AppTextStyle.textStyle13w600.copyWith(
                    color: theme.colorScheme.onBackground,
                  ),
                ),
              ),
              SizedBox(height: 8),
              CustomTextFormField(
                hintText: getSavedUserData().name,
                textInputType: TextInputType.text,
                suffixIcon: SvgPicture.asset(
                  Assets.imagesEdit,
                  fit: BoxFit.scaleDown,
                  color: theme.colorScheme.primary,
                ),
                onSaved:
                    (value) =>
                        name =
                            (value == null || value.isEmpty)
                                ? getSavedUserData().name
                                : value,
              ),
              SizedBox(height: 8),
              CustomTextFormField(
                hintText: getSavedUserData().email,
                textInputType: TextInputType.emailAddress,
                suffixIcon: SvgPicture.asset(
                  Assets.imagesEdit,
                  fit: BoxFit.scaleDown,
                  color: theme.colorScheme.primary,
                ),
                onSaved:
                    (value) =>
                        email =
                            (value == null || value.isEmpty)
                                ? getSavedUserData().email
                                : value,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  AppStrings.changePassword.tr(),
                  style: AppTextStyle.textStyle13w600.copyWith(
                    color: theme.colorScheme.onBackground,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (isSocialAccount)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppStrings.socialAccountPasswordMessage.tr(),
                    style: AppTextStyle.textStyle13w600.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else ...[
                CustomPasswordFormField(
                  controller: currentPasswordController,
                  hintText: AppStrings.currentPassword.tr(),
                ),
                const SizedBox(height: 8),
                CustomPasswordFormField(
                  hintText: AppStrings.newPassword.tr(),
                  controller: newPasswordController,
                ),
                const SizedBox(height: 8),
                CustomPasswordFormField(
                  hintText: AppStrings.confirmNewPassword.tr(),
                  controller: checkPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.fieldRequired.tr();
                    } else if (value != newPasswordController.text) {
                      log('Password validation value: $value');
                      return AppStrings.passwordMismatch.tr();
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 74),
              CustomButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final updatedUser = getSavedUserData().copyWith(
                      name: name,
                      email: email,
                    );
                    context.read<ProfileCubit>().updateProfileData(
                      updatedUser: updatedUser,
                      currentPassword:
                          isSocialAccount ? '' : currentPasswordController.text,
                      newPassword:
                          isSocialAccount ? '' : newPasswordController.text,
                    );
                  } else {
                    autovalidateMode = AutovalidateMode.always;
                    setState(() {});
                  }
                },
                text: AppStrings.saveChanges.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
