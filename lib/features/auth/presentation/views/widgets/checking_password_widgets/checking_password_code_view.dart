import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/widgets/custom_auth_app_bar.dart';
import 'package:fruits_hub/features/auth/presentation/views/widgets/checking_password_widgets/checking_password_code_view_body.dart';

class CheckingPasswordCodeView extends StatelessWidget {
  const CheckingPasswordCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: 'التحقق من الرمز'),
      body: CheckingPasswordCodeViewBody(),
    );
  }
}
