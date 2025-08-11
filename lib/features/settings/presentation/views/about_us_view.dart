import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/widgets/custom_auth_app_bar.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/custom_scroll_behavior.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsView extends StatefulWidget {
  const AboutUsView({super.key});

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF8FAFB),
      appBar: buildAppBar(
        context,
        title: AppStrings.aboutUsTitle.tr(),
        goBack: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildHeroSection(context),
                  _buildDeveloperSection(context),
                  _buildSkillsSection(context),
                  _buildExperienceSection(context),
                  _buildPhilosophySection(context),
                  _buildContactSection(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final theme = Theme.of(context);
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withOpacity(0.15),
              theme.primaryColor.withOpacity(0.05),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 48),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.primaryColor.withOpacity(0.2),
                          theme.primaryColor.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.25),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.1),
                          blurRadius: 60,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      Assets.imagesPersonal,
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.code,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                AppStrings.myName.tr(),
                style:
                    AppTextStyle.textStyle24w700.copyWith(
                      color: theme.colorScheme.onBackground,
                      letterSpacing: -0.8,
                    ) ??
                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.myRole.tr(),
                style:
                    AppTextStyle.textStyle16w600.copyWith(
                      color: theme.primaryColor,
                      letterSpacing: 0.5,
                    ) ??
                    theme.textTheme.titleMedium?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                height: 4,
                width: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor,
                      theme.primaryColor.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeveloperSection(BuildContext context) {
    return _buildAnimatedSection(
      context,
      delay: 200,
      child: _buildContentCard(
        context,
        icon: Icons.flutter_dash_outlined,
        title: AppStrings.aboutMe.tr(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnimatedParagraph(
              context,
              text: AppStrings.aboutMeDescription1.tr(),
              style: _getBodyTextStyle(context),
              delay: 300,
            ),
            const SizedBox(height: 20),
            _buildAnimatedParagraph(
              context,
              text: AppStrings.aboutMeDescription2.tr(),
              style: _getBodyTextStyle(context),
              delay: 500,
            ),
            const SizedBox(height: 20),
            _buildAnimatedParagraph(
              context,
              text: AppStrings.aboutMeDescription3.tr(),
              style: _getBodyTextStyle(context, emphasized: true),
              delay: 700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection(BuildContext context) {
    final skills = [
      {
        'name': AppStrings.flutterAndDart.tr(),
        'level': 0.95,
        'icon': Icons.flutter_dash,
      },
      {
        'name': AppStrings.uiDesign.tr(),
        'level': 0.90,
        'icon': Icons.palette_outlined,
      },
      {
        'name': AppStrings.stateManagement.tr(),
        'level': 0.88,
        'icon': Icons.settings_outlined,
      },
      {
        'name': AppStrings.firebaseIntegration.tr(),
        'level': 0.85,
        'icon': Icons.cloud_outlined,
      },
      {
        'name': AppStrings.apiIntegration.tr(),
        'level': 0.92,
        'icon': Icons.api_outlined,
      },
      {
        'name': AppStrings.performanceOptimization.tr(),
        'level': 0.87,
        'icon': Icons.speed_outlined,
      },
    ];

    return _buildAnimatedSection(
      context,
      delay: 400,
      child: _buildContentCard(
        context,
        icon: Icons.star_outline,
        title: AppStrings.skillsAndExpertise.tr(),
        child: Column(
          children:
              skills.asMap().entries.map((entry) {
                final index = entry.key;
                final skill = entry.value;
                return _buildSkillItem(
                  context,
                  name: skill['name'] as String,
                  level: skill['level'] as double,
                  icon: skill['icon'] as IconData,
                  delay: 600 + (index * 100),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildSkillItem(
    BuildContext context, {
    required String name,
    required double level,
    required IconData icon,
    required int delay,
  }) {
    final theme = Theme.of(context);
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.primaryColor.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.primaryColor.withOpacity(0.15),
                          theme.primaryColor.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 24, color: theme.primaryColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style:
                              AppTextStyle.textStyle16w600?.copyWith(
                                color: theme.colorScheme.onBackground,
                                letterSpacing: -0.1,
                              ) ??
                              theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onBackground,
                              ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 16,
                      color: theme.primaryColor,
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

  Widget _buildExperienceSection(BuildContext context) {
    return _buildAnimatedSection(
      context,
      delay: 600,
      child: _buildContentCard(
        context,
        icon: Icons.work_outline,
        title: AppStrings.experienceAndAchievements.tr(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExperienceItem(
              context,
              title: AppStrings.experienceAndAchievementsPoint1.tr(),
              description:
                  AppStrings.experienceAndAchievementsPoint1Description.tr(),

              delay: 700,
            ),
            _buildExperienceItem(
              context,
              title: AppStrings.experienceAndAchievementsPoint2.tr(),
              description:
                  AppStrings.experienceAndAchievementsPoint2Description.tr(),
              delay: 900,
            ),
            _buildExperienceItem(
              context,
              title: AppStrings.experienceAndAchievementsPoint3.tr(),
              description:
                  AppStrings.experienceAndAchievementsPoint3Description.tr(),
              delay: 1100,
            ),
            _buildExperienceItem(
              context,
              title: AppStrings.experienceAndAchievementsPoint4.tr(),
              description:
                  AppStrings.experienceAndAchievementsPoint4Description.tr(),
              delay: 1300,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceItem(
    BuildContext context, {
    required String title,
    required String description,
    required int delay,
  }) {
    final theme = Theme.of(context);
    return _buildAnimatedParagraph(
      context,
      text: '',
      style: const TextStyle(),
      delay: delay,
      customChild: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, size: 14, color: theme.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        AppTextStyle.textStyle14w600?.copyWith(
                          color: theme.colorScheme.onBackground,
                        ) ??
                        theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style:
                        AppTextStyle.textStyle13w400?.copyWith(
                          color: theme.colorScheme.onBackground.withOpacity(
                            0.7,
                          ),
                          height: 1.5,
                        ) ??
                        theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onBackground.withOpacity(
                            0.7,
                          ),
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhilosophySection(BuildContext context) {
    return _buildAnimatedSection(
      context,
      delay: 800,
      child: _buildContentCard(
        context,
        icon: Icons.lightbulb_outline,
        title: AppStrings.myDevelopmentPhilosophy.tr(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPhilosophyPoint(
              context,
              AppStrings.myDevelopmentPhilosophyPoint1.tr(),
              AppStrings.myDevelopmentPhilosophyPoint1Description.tr(),
              Icons.people_outline,
              1000,
            ),
            _buildPhilosophyPoint(
              context,
              AppStrings.myDevelopmentPhilosophyPoint2.tr(),
              AppStrings.myDevelopmentPhilosophyPoint2Description.tr(),
              Icons.architecture_outlined,
              1200,
            ),
            _buildPhilosophyPoint(
              context,
              AppStrings.myDevelopmentPhilosophyPoint3.tr(),
              AppStrings.myDevelopmentPhilosophyPoint3Description.tr(),
              Icons.school_outlined,
              1400,
            ),
            _buildPhilosophyPoint(
              context,
              AppStrings.myDevelopmentPhilosophyPoint4.tr(),
              AppStrings.myDevelopmentPhilosophyPoint4Description.tr(),
              Icons.verified_outlined,
              1600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhilosophyPoint(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    int delay,
  ) {
    final theme = Theme.of(context);
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.primaryColor.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: theme.primaryColor, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyle.textStyle14w600?.copyWith(
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: AppTextStyle.textStyle12w400?.copyWith(
                            color: theme.colorScheme.onBackground.withOpacity(
                              0.7,
                            ),
                            height: 1.4,
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

  Widget _buildContactSection(BuildContext context) {
    return _buildAnimatedSection(
      context,
      delay: 1000,
      child: _buildContentCard(
        context,
        icon: Icons.favorite_outline,
        title: AppStrings.letsConnect.tr(),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.1),
                Theme.of(context).primaryColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.handshake_outlined,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.thanksForConnecting.tr(),
                style: AppTextStyle.textStyle16w600?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.letsConnectDescription.tr(),
                style: AppTextStyle.textStyle14w400?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onBackground.withOpacity(0.7),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Primary Contact Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _launchEmail(),
                  icon: const Icon(Icons.email_outlined),
                  label: Text(AppStrings.getInTouch.tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Social Media Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(
                    context,
                    icon: Icons.work_outline,
                    label: AppStrings.linkedin.tr(),
                    onTap: () => _launchLinkedIn(),
                  ),
                  _buildSocialButton(
                    context,
                    icon: Icons.code,
                    label: AppStrings.github.tr(),
                    onTap: () => _launchGitHub(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  _buildSocialButton(
                    context,
                    icon: Icons.phone_outlined,
                    label: AppStrings.call.tr(),
                    onTap: () => _launchPhone(),
                  ),
                  _buildSocialButton(
                    context,
                    icon: Icons.description_outlined,
                    label: AppStrings.resume.tr(),
                    onTap: () => _downloadResume(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 90,
        height: 75,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 25, color: Theme.of(context).primaryColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyle.textStyle12w400.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onBackground.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for launching URLs and actions
  void _launchEmail() async {
    const email = 'sayed.mostafa.attia1@gmail.com';
    var subject = AppStrings.letsConnect.tr();
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': subject},
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchLinkedIn() async {
    const url = 'https://www.linkedin.com/in/sayed-mostafa2004';
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _launchGitHub() async {
    const url = 'https://github.com/sayedmostaf';
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _launchPhone() async {
    const phoneNumber = '+201091706101';
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _downloadResume() async {
    // You can either launch a URL to your resume or implement file download
    const resumeUrl =
        'https://drive.google.com/drive/u/0/folders/18VRA8Qd9qKTwqm_zyxcZ9JPtxkfgCGbW';
    final Uri uri = Uri.parse(resumeUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildAnimatedSection(
    BuildContext context, {
    required Widget child,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: child,
      ),
    );
  }

  Widget _buildContentCard(
    BuildContext context, {
    required Widget child,
    required IconData icon,
    required String title,
    Color? backgroundColor,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: theme.dividerColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: theme.primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style:
                    AppTextStyle.textStyle14w700?.copyWith(
                      color: theme.colorScheme.onBackground,
                    ) ??
                    theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildAnimatedParagraph(
    BuildContext context, {
    required String text,
    required TextStyle? style,
    required int delay,
    Widget? customChild,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child:
          customChild ??
          SelectableText(text, style: style, textAlign: TextAlign.justify),
    );
  }

  TextStyle? _getBodyTextStyle(
    BuildContext context, {
    bool emphasized = false,
  }) {
    final theme = Theme.of(context);
    return emphasized
        ? AppTextStyle.textStyle12w500?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.9),
              height: 1.7,
              letterSpacing: 0.1,
            ) ??
            theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              height: 1.7,
              color: theme.colorScheme.onBackground.withOpacity(0.9),
            )
        : AppTextStyle.textStyle14w400?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.8),
              height: 1.7,
              letterSpacing: 0.1,
            ) ??
            theme.textTheme.bodyMedium?.copyWith(
              height: 1.7,
              color: theme.colorScheme.onBackground.withOpacity(0.8),
            );
  }
}
