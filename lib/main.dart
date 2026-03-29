import 'package:flutter/material.dart';

// Import your screens (matching your new file names)
import 'screens/splashscreen.dart';
import 'screens/loginscreen.dart';
import 'screens/signupscreen.dart';
import 'screens/homescreencustomer.dart';

void main() {
  runApp(FixFinderApp());
}

class FixFinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FixFinder',

      initialRoute: '/',

      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreenCustomer(),
      },
    );
  }
}