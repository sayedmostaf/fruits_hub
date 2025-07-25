import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/functions/build_error_snack_bar.dart';
import 'package:fruits_hub/core/functions/build_success_snack_bar.dart';
import 'package:fruits_hub/core/utils/widgets/custom_progress_hub_widget.dart';
import 'package:fruits_hub/features/settings/presentation/managers/profile/profile_cubit.dart';
import 'package:fruits_hub/features/settings/presentation/managers/profile/profile_states.dart';
import 'package:fruits_hub/features/settings/presentation/views/widgets/profile_view_body.dart';

class ProfileCubitBlocConsumer extends StatefulWidget {
  const ProfileCubitBlocConsumer({super.key});

  @override
  State<ProfileCubitBlocConsumer> createState() =>
      _ProfileCubitBlocConsumerState();
}

class _ProfileCubitBlocConsumerState extends State<ProfileCubitBlocConsumer> {
  final GlobalKey<ProfileViewBodyState> _profileViewBodyKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileFailure) {
          buildErrorSnackBar(
            context,
            message:
                state.errMessage.isNotEmpty
                    ? state.errMessage
                    : 'حدث خطأ أثناء تحديث الملف الشخصي. حاول مرة أخرى.',
          );
        }
        if (state is ProfileSuccess) {
          buildSuccessSnackBar(
            context,
            message: 'تم تحديث الملف الشخصي وكلمة المرور بنجاح',
          );
          _profileViewBodyKey.currentState?.clearControllers();
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        return CustomProgressHubWidget(
          isLoading: state is ProfileLoading,
          child: ProfileViewBody(key: _profileViewBodyKey),
        );
      },
    );
  }
}
