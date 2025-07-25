import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/services/app_locator.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/widgets/custom_auth_app_bar.dart';
import 'package:fruits_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:fruits_hub/features/auth/presentation/managers/sign_out_cubit/sign_out_cubit.dart';
import 'package:fruits_hub/features/settings/presentation/views/widgets/settings_view_body.dart';
import 'package:fruits_hub/features/settings/presentation/views/widgets/sign_out_bloc_consumer.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        title: AppStrings.account.tr(),
        goBack: false,
      ),
      body: BlocProvider(
        create: (context) => SignOutCubit(getIt.get<AuthRepo>()),
        child: SignOutBlocConsumer(child: SettingsViewBody()),
      ),
    );
  }
}
