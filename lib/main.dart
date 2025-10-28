// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:newss/detils.dart';
// import 'package:newss/hom.dart';
// import 'package:newss/notificationservic/notifiationservcie.dart';
// import 'package:newss/utils/nvgtnserv.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await NotificationService().init();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: NavigationService.navigatorKey,
//       title: 'FCM All States',
//       home: const HomeScreen(),
//       routes: {
//         '/details': (context) => const DetailsScreen(),
//       },
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newss/detils.dart';
import 'package:newss/hom.dart';
import 'package:newss/notificationservic/notifiationservcie.dart';
import 'package:newss/utils/nvgtnserv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'FCM All States',
      home: const HomeScreen(),
      routes: {'/details': (context) => const DetailsScreen()},
      debugShowCheckedModeBanner: false,
    );
  }
}
