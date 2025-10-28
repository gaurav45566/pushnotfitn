// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:newss/notificationservic/notifiationservcie.dart';
// import '../services/notification_service.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String? _token;

//   @override
//   void initState() {
//     super.initState();
//     _refreshToken();
//   }

//   Future<void> _refreshToken() async {
//     final token = await NotificationService().getFcmToken();
//     setState(() => _token = token);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("FCM All States")),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text("FCM Token:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//               const SizedBox(height: 10),
//               SelectableText(
//                 _token ?? "Loading...",
//                 style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(onPressed: _refreshToken, child: const Text("Refresh Token")),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_token != null) {
//                     Clipboard.setData(ClipboardData(text: _token!));
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Token Copied!")));
//                   }
//                 },
//                 child: const Text("Copy Token"),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                 onPressed: () => NotificationService().testBanner(),
//                 child: const Text("TEST BANNER NOW", style: TextStyle(color: Colors.white)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newss/notificationservic/notifiationservcie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _refreshToken();
  }

  Future<void> _refreshToken() async {
    final token = await NotificationService().getFcmToken();
    setState(() => _token = token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FCM All States")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "FCM Token:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              SelectableText(
                _token ?? "Loading...",
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _refreshToken,
                child: const Text("Refresh Token"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_token != null) {
                    Clipboard.setData(ClipboardData(text: _token!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Token Copied!")),
                    );
                  }
                },
                child: const Text("Copy Token"),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => NotificationService().testBanner(),
                child: const Text(
                  "TEST BANNER NOW",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
