import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/functions/get_saved_user_data.dart';
import 'package:fruits_hub/core/repos/images/images_repo.dart';
import 'package:fruits_hub/core/services/app_locator.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:fruits_hub/features/notifications/presentation/managers/notifications_cubit.dart';
import 'package:fruits_hub/features/notifications/presentation/managers/notifications_state.dart';
import 'package:fruits_hub/features/settings/presentation/managers/images/profile_image_cubit.dart';
import 'package:fruits_hub/features/settings/presentation/views/about_us_view.dart';
import 'package:fruits_hub/features/settings/presentation/views/favorites_view.dart';
import 'package:fruits_hub/features/settings/presentation/views/profile_view.dart';
import 'package:fruits_hub/features/settings/presentation/views/widgets/custom_profile_info.dart';
import 'package:fruits_hub/features/settings/presentation/views/widgets/custom_setting_item.dart';
import 'package:fruits_hub/features/settings/presentation/views/widgets/custom_settings_sign_out_button.dart';
import 'package:fruits_hub/features/settings/presentation/views/widgets/custom_switch_button.dart';
import 'package:fruits_hub/features/settings/presentation/views/widgets/theme_switch_setting_item.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class SettingsViewBody extends StatefulWidget {
  const SettingsViewBody({super.key});

  @override
  State<SettingsViewBody> createState() => _SettingsViewBodyState();
}

class _SettingsViewBodyState extends State<SettingsViewBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BlocProvider(
                  create:
                      (context) => ProfileImageCubit(
                        imagesRepo: getIt.get<ImagesRepo>(),
                        authRepo: getIt.get<AuthRepo>(),
                      ),
                  child: CustomProfileInfo(
                    name: getSavedUserData().name,
                    email: getSavedUserData().email,
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppStrings.general.tr(),
                    style: AppTextStyle.textStyle13w600.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                CustomSettingItem(
                  onTap: () async {
                    final result =
                        await PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: const ProfileView(),
                          withNavBar: true,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                    if (result == true) {
                      setState(() {});
                    }
                  },
                  title: AppStrings.profile.tr(),
                  image: Assets.imagesVuesaxBoldUser,
                ),
                CustomSettingItem(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const FavoritesView(),
                      withNavBar: true,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  title: AppStrings.favorites.tr(),
                  image: Assets.imagesProfileHeart,
                ),
                BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, state) {
                    final enabled =
                        context.read<NotificationsCubit>().notificationsEnabled;

                    return CustomSwitchButton(
                      title: AppStrings.notifications.tr(),
                      svgIcon: Assets.imagesNotification,
                      onChanged: (value) async {
                        context.read<NotificationsCubit>().toggleNotifications(
                          value,
                        );
                        await Future.delayed(const Duration(milliseconds: 300));
                        context.read<NotificationsCubit>().fetchNotifications();
                      },
                      value: enabled,
                    );
                  },
                ),
                CustomSettingItem(
                  onTap: () => _showLanguagePicker(context),
                  title: AppStrings.language.tr(),
                  image: Assets.imagesGlobal,
                ),
                ThemeSwitchSettingItem(title: AppStrings.theme.tr()),
                SizedBox(height: 22),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppStrings.help.tr(),
                    style: AppTextStyle.textStyle13w600.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomSettingItem(
                  onTap:
                      () => PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const AboutUsView(),
                        withNavBar: true,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      ),
                  title: AppStrings.aboutUs.tr(),
                  image: Assets.imagesInfoCircle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          CustomSettingsSignOutButton(),
          const SizedBox(height: 150),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'LanguagePicker',
      barrierColor: Colors.transparent,
      transitionDuration: Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.transparent.withOpacity(0.2)),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).scaffoldBackgroundColor.withOpacity(0.95),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onVerticalDragUpdate: (details) {
                            if (details.primaryDelta! > 12) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Container(
                            height: 4,
                            width: 40,
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Align(
                          child: Text(
                            AppStrings.chooseLanguage.tr(),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildLanguageOption(
                          context,
                          locale: Locale('ar'),
                          label: 'العربية',
                          flag: '🇪🇬',
                        ),
                        SizedBox(height: 12),
                        _buildLanguageOption(
                          context,
                          locale: Locale('en'),
                          label: 'English',
                          flag: '🇺🇸',
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required Locale locale,
    required String label,
    required String flag,
  }) {
    final isSelected = context.locale == locale;
    return InkWell(
      onTap: () => context.setLocale(locale),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
