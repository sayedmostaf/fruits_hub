import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/widgets/custom_auth_app_bar.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/custom_scroll_behavior.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: buildAppBar(
        context,
        title: AppStrings.aboutUsTitle,
        goBack: true,
      ),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildParagraph(
                context,
                text: AppStrings.aboutUsParagraph1.tr(),
                style: AppTextStyle.textStyle13w400.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.7),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              _buildParagraph(
                context,
                text: AppStrings.aboutUsParagraph1.tr(),
                style: AppTextStyle.textStyle13w600.copyWith(
                  color: theme.colorScheme.onBackground,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 16),
              _buildParagraph(
                context,
                text: AppStrings.aboutUsParagraph2.tr(),
                style: AppTextStyle.textStyle13w600.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.7),
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 16),
              _buildParagraph(
                context,
                text: AppStrings.aboutUsParagraph3.tr(),
                style: AppTextStyle.textStyle13w600.copyWith(
                  color: theme.colorScheme.onBackground,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParagraph(
    BuildContext context, {
    required String text,
    required TextStyle style,
  }) {
    return Text(text, textAlign: TextAlign.justify, style: style);
  }
}
