import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/services/app_locator.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/widgets/custom_auth_app_bar.dart';
import 'package:fruits_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:fruits_hub/features/settings/presentation/managers/profile/profile_cubit.dart';
import 'package:fruits_hub/features/settings/presentation/views/widgets/profile_cubit_bloc_consumer.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: AppStrings.profile.tr()),
      body: BlocProvider(
        create: (context) => ProfileCubit(getIt.get<AuthRepo>()),
        child: ProfileCubitBlocConsumer(),
      ),
    );
  }
}
