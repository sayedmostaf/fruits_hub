import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/widgets/notification_widget.dart';

AppBar buildAppBar() {
  return AppBar(
    actions: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: NotificationWidget(),
      ),
    ],
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text(
      'الأكثر مبيعًا',
      textAlign: TextAlign.center,
      style: TextStyles.bold19,
    ),
  );
}
