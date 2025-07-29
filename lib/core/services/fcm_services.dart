import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmServices {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static Future<void> initFcm() async {
    await _initLocalNotifications();

    final settings = await FirebaseMessaging.instance.requestPermission();
    log('🔐 Notification permission: ${settings.authorizationStatus}');

    await FirebaseMessaging.instance.subscribeToTopic('users');
    log('📡 Subscribed to topic: users');

    final token = await FirebaseMessaging.instance.getToken();
    log('📱 Token: $token');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('📥 FG Message: ${message.notification?.title}');
      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('📬 Notification clicked!');
    });
  }

  static Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettings = InitializationSettings(android: androidSettings);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  } 

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
    );
  }

  static Future<void> backgroundHandler(RemoteMessage message) async {
    log('📦 BG Message: ${message.notification?.title}');
  }
}
