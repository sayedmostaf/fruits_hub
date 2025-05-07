import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/widgets/notification_widget.dart';

class CustomHomeAppBar extends StatelessWidget {
  const CustomHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: NotificationWidget(),
      title: Text(
        'مرحبًا بك في متجرنا',
        textAlign: TextAlign.right,
        style: TextStyles.regular16.copyWith(color: Color(0xFF949D9E)),
      ),
      subtitle: Text(
        'سيد مصطفى',
        textAlign: TextAlign.right,
        style: TextStyles.bold16,
      ),
    );
  }
}
