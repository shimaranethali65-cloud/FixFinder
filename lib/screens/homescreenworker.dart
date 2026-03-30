import 'package:flutter/material.dart';

class HomeScreenWorker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Worker Home")),
      body: Center(
        child: Text("Worker Dashboard"),
      ),
    );
  }
}