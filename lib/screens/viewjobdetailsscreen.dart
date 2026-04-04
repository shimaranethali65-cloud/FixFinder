import 'package:flutter/material.dart';

class ViewJobDetailsScreen extends StatelessWidget {
  const ViewJobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
      ),
      body: const Center(
        child: Text(
          "This is Job Details Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
