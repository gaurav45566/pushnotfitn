// import 'dart:convert';
// import 'dart:async';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// class NotificationService {
//   NotificationService._();
//   static final NotificationService instance = NotificationService._();

//   final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   static const String channelId = "high_importance_channel";
//   static const String channelName = "High Importance Notifications";
//   static const String channelDescription = "Used for important notifications.";

//   final StreamController<Map<String, dynamic>> _onNotificationTapController =
//       StreamController.broadcast();

//   Stream<Map<String, dynamic>> get onNotificationTap =>
//       _onNotificationTapController.stream;

//   Future<void> init(BuildContext context) async {
//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     final iosInit = DarwinInitializationSettings();

//     await _flutterLocalNotificationsPlugin.initialize(
//       InitializationSettings(android: androidInit, iOS: iosInit),
//       onDidReceiveNotificationResponse: (response) {
//         final payload = response.payload;
//         if (payload != null && payload.isNotEmpty) {
//           try {
//             final data = jsonDecode(payload) as Map<String, dynamic>;
//             _onNotificationTapController.add(data);
//           } catch (_) {
//             _onNotificationTapController.add({'payload': payload});
//           }
//         } else {
//           _onNotificationTapController.add({});
//         }
//       },
//     );

//     // Android channel
//     const androidChannel = AndroidNotificationChannel(
//       channelId,
//       channelName,
//       description: channelDescription,
//       importance: Importance.max,
//     );

//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(androidChannel);

//     await _firebaseMessaging.requestPermission();
//     _firebaseMessaging.getToken().then((token) {
//       debugPrint("✅ FCM Token: $token");
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       showNotification(message);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _onNotificationTapController.add(message.data);
//     });
//   }

//   Future<void> showNotification(RemoteMessage message) async {
//     const androidDetails = AndroidNotificationDetails(
//       channelId,
//       channelName,
//       channelDescription: channelDescription,
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const iosDetails = DarwinNotificationDetails();
//     const platformDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       message.notification?.title ?? 'New Notification',
//       message.notification?.body ?? '',
//       platformDetails,
//       payload: jsonEncode(message.data),
//     );
//   }
// }

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:newss/utils/nvgtnserv.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _requestPermission();
    await _initLocalNotifications();
    await _getToken();

    FirebaseMessaging.onMessage.listen(_handleForeground);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _handleInitialMessage();
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        NavigationService.navigateTo('/details');
      },
    );
  }

  Future<void> _getToken() async {
    final token = await _messaging.getToken();
    print("FCM Token: $token");
  }

  Future<String?> getFcmToken() async {
    return await _messaging.getToken();
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    print("Background Message: ${message.notification?.title}");
  }

  Future<void> _handleForeground(RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null) {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'high_importance_channel',
            'Notifications',
            importance: Importance.max,
            priority: Priority.high,
          );
      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
      );
      await _flutterLocalNotificationsPlugin.show(
        0,
        notification.title,
        notification.body,
        details,
      );
    }
  }

  Future<void> _handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      NavigationService.navigateTo('/details');
    }
  }

  Future<void> _handleMessageOpened(RemoteMessage message) async {
    NavigationService.navigateTo('/details');
  }

  Future<void> testBanner() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          importance: Importance.max,
          priority: Priority.high,
        );
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );
    await _flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is a test banner!',
      details,
    );
  }
}
