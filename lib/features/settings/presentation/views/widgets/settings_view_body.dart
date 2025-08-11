import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Profile Header Section
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: BlocProvider(
              create:
                  (context) => ProfileImageCubit(
                    imagesRepo: getIt.get<ImagesRepo>(),
                    authRepo: getIt.get<AuthRepo>(),
                  ),
              child: CustomProfileInfo(
                name: getSavedUserData().name,
                email: getSavedUserData().email,
                onTap: () async {
                  HapticFeedback.lightImpact();
                  final result = await PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: const ProfileView(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                  if (result == true && mounted) {
                    setState(() {});
                  }
                },
                elevation: 2,
                borderRadius: 16,
                padding: const EdgeInsets.all(20),
              ),
            ),
          ),
        ),

        // General Settings Section
        SliverToBoxAdapter(
          child: _buildSettingsSection(
            context,
            title: AppStrings.general.tr(),
            children: [
              CustomSettingItem(
                onTap: () async {
                  HapticFeedback.lightImpact();
                  final result = await PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: const ProfileView(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                  if (result == true && mounted) {
                    setState(() {});
                  }
                },
                title: AppStrings.profile.tr(),
                image: Assets.imagesVuesaxBoldUser,
                subtitle: AppStrings.editYourProfileInformation.tr(),
              ),

              CustomSettingItem(
                onTap: () {
                  HapticFeedback.lightImpact();
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: const FavoritesView(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                title: AppStrings.favorites.tr(),
                image: Assets.imagesProfileHeart,
                subtitle: AppStrings.viewYourFavoritesItems.tr(),
              ),

              BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  final enabled =
                      context.read<NotificationsCubit>().notificationsEnabled;

                  return CustomSwitchButton(
                    title: AppStrings.notifications.tr(),
                    svgIcon: Assets.imagesNotification,
                    subtitle: AppStrings.getNotifiedAboutUpdates.tr(),
                    value: enabled,
                    onChanged: (value) async {
                      context.read<NotificationsCubit>().toggleNotifications(
                        value,
                      );
                      await Future.delayed(const Duration(milliseconds: 300));
                      if (context.mounted) {
                        context.read<NotificationsCubit>().fetchNotifications();
                      }
                    },
                    switchSize: SwitchSize.medium,
                    hapticFeedback: true,
                    animationDuration: const Duration(milliseconds: 200),
                  );
                },
              ),

              CustomSettingItem(
                onTap: () => _showLanguagePicker(context),
                title: AppStrings.language.tr(),
                image: Assets.imagesGlobal,
                subtitle: AppStrings.chooseYourPreferredLanguage.tr(),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getCurrentLanguageFlag(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  ],
                ),
              ),

              ThemeSwitchSettingItem(title: AppStrings.theme.tr()),
            ],
          ),
        ),

        // Help & Support Section
        SliverToBoxAdapter(
          child: _buildSettingsSection(
            context,
            title: AppStrings.help.tr(),
            children: [
              CustomSettingItem(
                onTap: () {
                  HapticFeedback.lightImpact();
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: const AboutUsView(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                title: AppStrings.aboutUs.tr(),
                image: Assets.imagesInfoCircle,
                subtitle: AppStrings.learnMoreAboutUs.tr(),
              ),

              CustomSettingItem(
                onTap: () => _showContactDialog(context),
                title: AppStrings.contactSupport.tr(),
                image: Assets.imagesSupport, // Replace with support icon
                subtitle: AppStrings.getYourHelpAboutYourAccount.tr(),
              ),

              CustomSettingItem(
                onTap: () => _showPrivacyDialog(context),
                title: AppStrings.privacyPolicy.tr(),
                image: Assets.imagesPrivacy, // Replace with privacy icon
                subtitle: AppStrings.readOurPrivacyPolicy.tr(),
              ),
            ],
          ),
        ),

        // Sign Out Section
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 32, 16, 24),
            child: const CustomSettingsSignOutButton(),
          ),
        ),

        // Bottom spacing
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              title,
              style: AppTextStyle.textStyle13w600.copyWith(
                color: theme.colorScheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Settings Container
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 10),

                for (int i = 0; i < children.length; i++) ...[
                  children[i],

                  SizedBox(height: 5),
                ],
                SizedBox(height: 5),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _getCurrentLanguageFlag() {
    final currentLocale = context.locale;
    return currentLocale.languageCode == 'ar' ? '🇪🇬' : '🇺🇸';
  }

  void _showLanguagePicker(BuildContext context) {
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _LanguagePickerModal(),
    );
  }

  void _showContactDialog(BuildContext context) {
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              AppStrings.contactSupport.tr(),
              textAlign: TextAlign.start,
            ),
            content:  Text(
              textAlign: TextAlign.start,
              '${AppStrings.youCanReachUsAt.tr()}\n\nsayed.mostafa.wrk@gmail.com\n+20 1091706101',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:  Text(AppStrings.close.tr()),
              ),
            ],
          ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title:  Text(AppStrings.privacyPolicy.tr(), textAlign: TextAlign.start),
            content:  Text(
              textAlign: TextAlign.start,
              AppStrings.privacyPolicyContent.tr(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:  Text(AppStrings.close.tr(), textAlign: TextAlign.start),
              ),
            ],
          ),
    );
  }
}

class _LanguagePickerModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Text(
              AppStrings.chooseLanguage.tr(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            // Language options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildLanguageOption(
                    context,
                    locale: const Locale('ar'),
                    label: AppStrings.arabic.tr(),
                    flag: '🇪🇬',
                    subtitle: AppStrings.arabic.tr(),
                  ),

                  const SizedBox(height: 12),

                  _buildLanguageOption(
                    context,
                    locale: const Locale('en'),
                    label: AppStrings.english.tr(),
                    flag: '🇺🇸',
                    subtitle: AppStrings.english.tr(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required Locale locale,
    required String label,
    required String flag,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final isSelected = context.locale == locale;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        context.setLocale(locale);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                  : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Flag
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(flag, style: const TextStyle(fontSize: 20)),
              ),
            ),

            const SizedBox(width: 16),

            // Language info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Check icon
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
