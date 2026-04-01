import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Import your screens
import 'screens/splashscreen.dart';
import 'screens/loginscreen.dart';
import 'screens/signupscreen.dart';
import 'screens/homescreencustomer.dart';
import 'screens/homescreenworker.dart';
import 'screens/createjobscreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase
  await Firebase.initializeApp();

  debugPrint("🔥 Firebase Connected Successfully!");

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
        '/workerHome': (context) => HomeScreenWorker(),
        '/createJob': (context) => CreateJobScreen(),
      },
    );
  }
}