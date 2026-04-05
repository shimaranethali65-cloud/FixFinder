import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// ✅ Import only what you need
import 'screens/customernavbar.dart';
import 'screens/splashscreen.dart';
import 'screens/signupscreen.dart';
import 'screens/profilescreen.dart';
import 'screens/editprofilescreen.dart';
import 'screens/loginscreen.dart';
import 'screens/homescreenworker.dart';
import 'screens/createjobscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase
  await Firebase.initializeApp();

  debugPrint("🔥 Firebase Connected Successfully!");

  runApp(const FixFinderApp());
}

class FixFinderApp extends StatelessWidget {
  const FixFinderApp({super.key});

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

        // ✅ IMPORTANT: This now loads Bottom Nav
        '/home': (context) => const CustomerNavBar(),

        '/workerHome': (context) => HomeScreenWorker(),

        '/createJob': (context) => const CreateJobScreen(),
      },
    );
  }
}