import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Import your screens
import 'screens/signupscreen.dart';
import 'screens/profilescreen.dart';
import 'screens/editprofilescreen.dart';

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

      // Change this to '/profile' to see your work immediately!
      initialRoute: '/signup',

      routes: {
        '/signup': (context) => SignUpScreen(),
 
        '/profile': (context) => ProfileScreen(),
        '/editProfile': (context) => EditProfileScreen(),

        '/home': (context) => HomeScreenCustomer(),
        '/workerHome': (context) => HomeScreenWorker(),
        '/createJob': (context) => CreateJobScreen(),

      },
    );
  }
}
