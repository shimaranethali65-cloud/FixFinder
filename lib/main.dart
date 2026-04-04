import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Import your screens
import 'screens/splashscreen.dart';
import 'screens/signupscreen.dart';
import 'screens/profilescreen.dart';
import 'screens/editprofilescreen.dart';
import 'screens/loginscreen.dart';
import 'screens/homescreencustomer.dart';
import 'screens/homescreenworker.dart';
import 'screens/createjobscreen.dart';

// ❌ DO NOT add viewbidsscreen here in routes

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase
  await Firebase.initializeApp();

  debugPrint("🔥 Firebase Connected Successfully!");

  runApp(FixFinderApp());
}

class FixFinderApp extends StatelessWidget {
  const FixFinderApp({super.key}); // ✅ added const constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FixFinder',

      initialRoute: '/',

      routes: {
        '/': (context) => SplashScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),

        '/profile': (context) => const ProfileScreen(),
        '/editProfile': (context) => const EditProfileScreen(),

        '/home': (context) => const HomeScreenCustomer(),
        '/workerHome': (context) =>  HomeScreenWorker(),

        '/createJob': (context) => const CreateJobScreen(),
      
      },
    );
  }
}