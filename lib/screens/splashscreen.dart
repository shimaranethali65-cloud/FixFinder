import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // App Title
              Text(
                "FixFinder",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              // Subtitle
              Text(
                "Find Trusted Workers Nearby",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              SizedBox(height: 40),

              // Image
              Image.asset(
                'assets/images/splash.png',
                height: 250,
              ),

              SizedBox(height: 40),

              // Loading text
              Text(
                "Loading...",
                style: TextStyle(color: Colors.grey),
              ),

              SizedBox(height: 15),

              // Loader
              CircularProgressIndicator(),

            ],
          ),
        ),
      ),
    );
  }
}