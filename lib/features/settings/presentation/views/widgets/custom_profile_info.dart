import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/functions/get_saved_user_data.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/settings/presentation/managers/images/profile_image_cubit.dart';
import 'package:fruits_hub/features/settings/presentation/managers/images/profile_image_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomProfileInfo extends StatefulWidget {
  const CustomProfileInfo({super.key, required this.name, required this.email});
  final String name, email;

  @override
  State<CustomProfileInfo> createState() => _CustomProfileInfoState();
}

class _CustomProfileInfoState extends State<CustomProfileInfo> {
  File? _imageFile;
  String? _imageUrl;
  bool isLoading = false;

  Future<void> _pickImage() async {
    setState(() => isLoading = true);
    bool hasPermission = false;

    if (Platform.isAndroid) {
      final mediaStatus = await Permission.photos.status;
      final storageStatus = await Permission.storage.status;

      if (mediaStatus.isGranted || storageStatus.isGranted) {
        hasPermission = true;
      } else {
        final resultMedia = await Permission.photos.request();
        final resultStorage = await Permission.storage.request();
        hasPermission = resultMedia.isGranted || resultStorage.isGranted;
      }
    } else if (Platform.isIOS) {
      final result = await Permission.photos.request();
      hasPermission = result.isGranted;
    }

    if (hasPermission) {
      log('✅ Permission granted');
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _imageUrl = null;
        });

        if (!mounted) return;
        context.read<ProfileImageCubit>().setUserProfileImage(
          imageFile: _imageFile,
        );
      }
    } else {
      log('❌ Permission denied');
      await openAppSettings();
    }

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _imageUrl = getSavedUserData().imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        BlocConsumer<ProfileImageCubit, ProfileImageState>(
          listener: (context, state) {
            if (state is ProfileImageSuccess) {
              final newImageUrl = getSavedUserData().imageUrl;
              setState(() {
                _imageUrl = newImageUrl;
                _imageFile = null;
              });
            } else if (state is ProfileImageFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errMessage)));
            }
          },
          builder: (context, state) {
            ImageProvider<Object>? imageProvider;
            if (_imageFile != null) {
              imageProvider = FileImage(_imageFile!);
            } else if (_imageUrl != null && _imageUrl!.trim().isNotEmpty) {
              imageProvider = CachedNetworkImageProvider(_imageUrl!.trim());
            }
            return Skeletonizer(
              enabled: isLoading || state is ProfileImageLoading,
              child: Stack(
                alignment: Alignment.bottomRight,
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 36.5,
                      backgroundImage: imageProvider,
                      backgroundColor: theme.colorScheme.onSurface.withOpacity(
                        0.1,
                      ),
                      child:
                          imageProvider == null
                              ? Icon(
                                Icons.person,
                                size: 36,
                                color: theme.colorScheme.surface,
                              )
                              : null,
                    ),
                  ),
                  Positioned(
                    bottom: -15,
                    left: 20.5,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: theme.colorScheme.surface,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: theme.colorScheme.background,
                          child: SvgPicture.asset(
                            Assets.imagesCamera,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name.tr(),
                style: AppTextStyle.textStyle13w700.copyWith(
                  color: theme.colorScheme.onBackground,
                ),
              ),
              Text(
                widget.email.tr(),
                style: AppTextStyle.textStyle13w400.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
