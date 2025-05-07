import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/widgets/notification_widget.dart';

AppBar buildAppBar(context, {required String title}) {
  return AppBar(
    backgroundColor: Colors.white,
    leading: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Icon(Icons.arrow_back_ios_new),
    ),
    actions: const [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: NotificationWidget(),
      ),
    ],
    centerTitle: true,
    title: Text(title, style: TextStyles.bold19, textAlign: TextAlign.center),
  );
}
