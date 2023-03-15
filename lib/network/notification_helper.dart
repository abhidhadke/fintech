import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HelperNotification {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializeSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializeSettings,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      debugPrint('#######Message######');
      debugPrint(
          '${message?.messageId}\n${message?.notification?.title}\n${message?.notification?.body}');
    });

    //FirebaseMessaging.onBackgroundMessage.call((RemoteMessage message) => firebaseMessagingBackgroundHandler(message));
  }
}
