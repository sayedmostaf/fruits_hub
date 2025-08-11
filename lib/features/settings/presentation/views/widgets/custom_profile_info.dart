import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/functions/get_saved_user_data.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/settings/presentation/managers/images/profile_image_cubit.dart';
import 'package:fruits_hub/features/settings/presentation/managers/images/profile_image_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomProfileInfo extends StatefulWidget {
  const CustomProfileInfo({
    super.key,
    required this.name,
    required this.email,
    this.onTap,
    this.showEditIcon = true,
    this.avatarSize = 40.0,
    this.backgroundColor,
    this.borderColor,
    this.elevation = 0,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16.0,
  });

  final String name, email;
  final VoidCallback? onTap;
  final bool showEditIcon;
  final double avatarSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final double elevation;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  State<CustomProfileInfo> createState() => _CustomProfileInfoState();
}

class _CustomProfileInfoState extends State<CustomProfileInfo>
    with TickerProviderStateMixin {
  File? _imageFile;
  String? _imageUrl;
  bool isLoading = false;

  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _shimmerController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _imageUrl = getSavedUserData().imageUrl;

    // Initialize animation controllers
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Initialize animations
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.elasticOut),
    );

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  Future<void> _pickImage() async {
    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Rotation animation for camera icon
    _rotationController.forward().then((_) {
      _rotationController.reverse();
    });

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
      await _showImageSourceDialog();
    } else {
      log('❌ Permission denied');
      if (mounted) {
        _showPermissionDialog();
      }
    }

    setState(() => isLoading = false);
  }

  Future<void> _showImageSourceDialog() async {
    final theme = Theme.of(context);
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppStrings.selectImageSource.tr(),
                  style: AppTextStyle.textStyle13w700.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageSourceOption(
                      icon: Icons.camera_alt,
                      label: AppStrings.camera.tr(),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImageFromSource(ImageSource.camera);
                      },
                    ),
                    _buildImageSourceOption(
                      icon: Icons.photo_library,
                      label: AppStrings.gallery.tr(),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImageFromSource(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 800,
      maxHeight: 800,
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
  }

  void _showPermissionDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              AppStrings.permissionRequired.tr(),
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            content: Text(
              AppStrings.permissionRequiredPhotoAccess.tr(),
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppStrings.cancel.tr(),
                  style: TextStyle(color: theme.colorScheme.outline),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: Text(
                  AppStrings.openSettings.tr(),
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildShimmerAvatar() {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _shimmerAnimation.value, 0.0),
              end: Alignment(1.0 + _shimmerAnimation.value, 0.0),
              colors: [
                theme.colorScheme.surfaceVariant.withOpacity(0.3),
                theme.colorScheme.surfaceVariant.withOpacity(0.7),
                theme.colorScheme.surfaceVariant.withOpacity(0.3),
              ],
            ),
          ),
          child: CircleAvatar(
            radius: widget.avatarSize,
            backgroundColor: Colors.transparent,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            onTapDown: widget.onTap != null ? _onTapDown : null,
            onTapUp: widget.onTap != null ? _onTapUp : null,
            onTapCancel: widget.onTap != null ? _onTapCancel : null,
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                color:
                    widget.backgroundColor ??
                    (isDarkMode
                        ? theme.colorScheme.surface.withOpacity(0.9)
                        : theme.colorScheme.surface),
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color:
                      widget.borderColor ??
                      theme.colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow:
                    widget.elevation > 0
                        ? [
                          BoxShadow(
                            color:
                                isDarkMode
                                    ? Colors.black.withOpacity(0.3)
                                    : theme.colorScheme.shadow.withOpacity(0.1),
                            blurRadius: widget.elevation * 2,
                            offset: Offset(0, widget.elevation),
                            spreadRadius: 0,
                          ),
                        ]
                        : null,
              ),
              child: Row(
                children: [
                  BlocConsumer<ProfileImageCubit, ProfileImageState>(
                    listener: (context, state) {
                      if (state is ProfileImageSuccess) {
                        final newImageUrl = getSavedUserData().imageUrl;
                        setState(() {
                          _imageUrl = newImageUrl;
                          _imageFile = null;
                        });

                        // Success feedback
                        HapticFeedback.lightImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                 Text(
                                  AppStrings.profilePictureUpdated.tr(),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.green.shade600,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            duration: const Duration(milliseconds: 2000),
                          ),
                        );
                      } else if (state is ProfileImageFailure) {
                        HapticFeedback.heavyImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: Text(state.errMessage)),
                              ],
                            ),
                            backgroundColor: Colors.red.shade600,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      ImageProvider<Object>? imageProvider;
                      if (_imageFile != null) {
                        imageProvider = FileImage(_imageFile!);
                      } else if (_imageUrl != null &&
                          _imageUrl!.trim().isNotEmpty) {
                        imageProvider = CachedNetworkImageProvider(
                          _imageUrl!.trim(),
                        );
                      }

                      final isLoadingState =
                          isLoading || state is ProfileImageLoading;

                      return Hero(
                        tag: 'profile_avatar',
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          clipBehavior: Clip.none,
                          children: [
                            // Avatar container with shimmer
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child:
                                  isLoadingState
                                      ? _buildShimmerAvatar()
                                      : CircleAvatar(
                                        radius: widget.avatarSize,
                                        backgroundImage: imageProvider,
                                        backgroundColor: theme
                                            .colorScheme
                                            .primaryContainer
                                            .withOpacity(0.3),
                                        child:
                                            imageProvider == null
                                                ? AnimatedSwitcher(
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  child: Icon(
                                                    Icons.person_rounded,
                                                    size:
                                                        widget.avatarSize * 0.8,
                                                    color: theme
                                                        .colorScheme
                                                        .primary
                                                        .withOpacity(0.7),
                                                  ),
                                                )
                                                : null,
                                      ),
                            ),
                            // Edit button
                            if (widget.showEditIcon)
                              Positioned(
                                bottom: -4,
                                right: -4,
                                child: AnimatedBuilder(
                                  animation: _rotationAnimation,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: _rotationAnimation.value * 0.5,
                                      child: GestureDetector(
                                        onTap:
                                            isLoadingState ? null : _pickImage,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: theme.colorScheme.primary,
                                            boxShadow: [
                                              BoxShadow(
                                                color: theme.colorScheme.primary
                                                    .withOpacity(0.3),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                theme.colorScheme.primary,
                                            child: AnimatedSwitcher(
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
                                              child:
                                                  isLoadingState
                                                      ? SizedBox(
                                                        width: 12,
                                                        height: 12,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                Color
                                                              >(
                                                                theme
                                                                    .colorScheme
                                                                    .onPrimary,
                                                              ),
                                                        ),
                                                      )
                                                      : SvgPicture.asset(
                                                        Assets.imagesCamera,
                                                        width: 16,
                                                        height: 16,
                                                        color:
                                                            theme
                                                                .colorScheme
                                                                .onPrimary,
                                                      ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: AppTextStyle.textStyle13w700.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontSize: 16,
                          ),
                          child: Text(
                            widget.name.tr(),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: AppTextStyle.textStyle13w400.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                          child: Text(
                            widget.email.tr(),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Usage variants
extension CustomProfileInfoVariants on CustomProfileInfo {
  static CustomProfileInfo card({
    required String name,
    required String email,
    VoidCallback? onTap,
  }) {
    return CustomProfileInfo(
      name: name,
      email: email,
      onTap: onTap,
      elevation: 2,
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
    );
  }

  static CustomProfileInfo compact({
    required String name,
    required String email,
    VoidCallback? onTap,
  }) {
    return CustomProfileInfo(
      name: name,
      email: email,
      onTap: onTap,
      avatarSize: 32,
      showEditIcon: false,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 12,
    );
  }

  static CustomProfileInfo large({
    required String name,
    required String email,
    VoidCallback? onTap,
  }) {
    return CustomProfileInfo(
      name: name,
      email: email,
      onTap: onTap,
      avatarSize: 50,
      padding: const EdgeInsets.all(24),
      borderRadius: 20,
      elevation: 4,
    );
  }
}
