// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:newss/notfntbnaer.dart';
// import 'package:newss/utils/payout.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await NotificationService()._showNotification(message);
// }

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();

//   // In-app banner overlay
//   static OverlayEntry? _overlayEntry;

//   Future<void> init() async {
//     await _requestPermission();
//     await _initLocalNotifications();

//     // Token fetch karo (public method)
//     final token = await getFcmToken();
//     debugPrint("FCM Token: $token");

//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     await _handleInitialMessage();
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
//   }

//   Future<void> _requestPermission() async {
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//     );

//     if (settings.authorizationStatus != AuthorizationStatus.authorized) {
//       debugPrint("Notification permission denied");
//     }
//   }

//   Future<void> _initLocalNotifications() async {
//     const AndroidInitializationSettings android = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//     const DarwinInitializationSettings ios = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const InitializationSettings initSettings = InitializationSettings(
//       android: android,
//       iOS: ios,
//     );
//     await _localNotifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (details) {
//         if (details.payload != null) {
//           final payload = NotificationPayload.fromJson(
//             jsonDecode(details.payload!),
//           );
//           _navigateToScreen(payload);
//         }
//       },
//     );

//     // Create high-priority channel for heads-up
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       description: 'Used for important notifications',
//       importance: Importance.high,
//       playSound: true,
//     );

//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);
//   }

//   Future<String?> getFcmToken() async {
//     return await _messaging.getToken();
//   }

//   void _handleForegroundMessage(RemoteMessage message) {
//     // Show in-app banner
//     _showInAppBanner(message);

//     // Also show system tray
//     _showNotification(message);
//   }

//   Future<void> _showNotification(RemoteMessage message) async {
//     final data = message.data;
//     final payload = NotificationPayload(
//       title: message.notification?.title ?? data['title'] ?? 'Notification',
//       body: message.notification?.body ?? data['body'] ?? '',
//       screen: data['screen'] ?? '/',
//       id: data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
//     );

//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'high_importance_channel',
//           'High Importance Notifications',
//           importance: Importance.high,
//           priority: Priority.high,
//           icon: '@mipmap/ic_launcher',
//         );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotifications.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       payload.title,
//       payload.body,
//       notificationDetails,
//       payload: jsonEncode(payload.toJson()),
//     );
//   }

//   void _showInAppBanner(RemoteMessage message) {
//     final context = NavigationService.navigatorKey.currentContext;
//     if (context == null || !context.mounted) return;

//     final payload = NotificationPayload.fromRemoteMessage(message);

//     // Remove previous banner
//     _overlayEntry?.remove();
//     _overlayEntry = null;

//     _overlayEntry = OverlayEntry(
//       builder:
//           (_) => InAppNotificationBanner(
//             title: payload.title,
//             body: payload.body,
//             onTap: () {
//               _overlayEntry?.remove();
//               _overlayEntry = null;
//               _navigateToScreen(payload);
//             },
//           ),
//     );

//     Overlay.of(context).insert(_overlayEntry!);

//     // Auto-dismiss after 4 seconds
//     Future.delayed(const Duration(seconds: 4), () {
//       _overlayEntry?.remove();
//       _overlayEntry = null;
//     });
//   }

//   Future<void> _handleInitialMessage() async {
//     final message = await _messaging.getInitialMessage();
//     if (message != null) {
//       await Future.delayed(const Duration(seconds: 1)); // Wait for UI
//       final payload = NotificationPayload.fromRemoteMessage(message);
//       _navigateToScreen(payload);
//     }
//   }

//   void _handleMessageOpenedApp(RemoteMessage message) {
//     final payload = NotificationPayload.fromRemoteMessage(message);
//     _navigateToScreen(payload);
//   }

//   void _navigateToScreen(NotificationPayload payload) {
//     final context = NavigationService.navigatorKey.currentContext;
//     if (context == null || !context.mounted) return;

//     // Simple navigation logic
//     switch (payload.screen) {
//       case '/details':
//         Navigator.pushNamed(context, '/details', arguments: payload.id);
//         break;
//       default:
//         Navigator.pushNamed(context, '/');
//     }
//   }
// }

// // Helper to access navigator from anywhere
// class NavigationService {
//   static final GlobalKey<NavigatorState> navigatorKey =
//       GlobalKey<NavigatorState>();
// }
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:newss/notfntbnaer.dart';
import 'package:newss/utils/nvgtnserv.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService()._showSystemNotification(message);
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  static OverlayEntry? _overlayEntry;

  Future<void> _getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      debugPrint("Notification permission denied");
    }
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _local.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!) as Map<String, dynamic>;
          _navigate(data);
        }
      },
    );

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance',
      importance: Importance.high,
      playSound: true,
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<String?> getFcmToken() async {
    return await _messaging.getToken();
  }

  void _handleForeground(RemoteMessage message) {
    _showInAppBanner(message);
    _showSystemNotification(message);
  }

  Future<void> _showSystemNotification(RemoteMessage message) async {
    final data = message.data;
    final payload = {
      'title': message.notification?.title ?? data['title'] ?? 'Notification',
      'body': message.notification?.body ?? data['body'] ?? '',
      'screen': data['screen'] ?? '/',
      'id': data['id'] ?? DateTime.now().toString(),
    };

    const android = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance',
      importance: Importance.high,
      priority: Priority.high,
    );
    const ios = DarwinNotificationDetails();
    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      payload['title'],
      payload['body'],
      const NotificationDetails(android: android, iOS: ios),
      payload: jsonEncode(payload),
    );
  }

  void _showInAppBanner(RemoteMessage message) {
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null || !context.mounted) return;

    final data = message.data;
    final payload = {
      'title': message.notification?.title ?? data['title'] ?? 'Notification',
      'body': message.notification?.body ?? data['body'] ?? '',
      'screen': data['screen'] ?? '/',
      'id': data['id'] ?? 'unknown',
    };

    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder:
          (_) => InAppNotificationBanner(
            title: payload['title']!,
            body: payload['body']!,
            onTap: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
              _navigate(payload);
            },
          ),
    );
    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 4), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  Future<void> _handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      await Future.delayed(const Duration(seconds: 1));
      _navigate(message.data);
    }
  }

  void _handleMessageOpened(RemoteMessage message) {
    _navigate(message.data);
  }

  void _navigate(Map<String, dynamic> data) {
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null || !context.mounted) return;

    final screen = data['screen'] ?? '/';
    final id = data['id'] ?? 'No ID';

    if (screen == '/details') {
      Navigator.pushNamed(context, '/details', arguments: id);
    }
  }

  // Manual Test
  void testBanner() {
    final fake = RemoteMessage(
      notification: const RemoteNotification(
        title: "TEST",
        body: "Banner Working!",
      ),
      data: {'screen': '/details', 'id': 'TEST123'},
    );
    _handleForeground(fake);
  }
}
