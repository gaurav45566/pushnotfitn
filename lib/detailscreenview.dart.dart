import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments ?? 'No ID';
    return Scaffold(
      appBar: AppBar(title: const Text("Notification Details")),
      body: Center(
        child: Text(
          "Notification ID: $id",
          style: const TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
