import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Screens
import 'screens/customernavbar.dart';
import 'screens/splashscreen.dart';
import 'screens/signupscreen.dart';
import 'screens/profilescreen.dart';
import 'screens/editprofilescreen.dart';
import 'screens/loginscreen.dart';
import 'screens/workernavbar.dart';
import 'screens/createjobscreen.dart';
import 'screens/myjobsscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        '/myJobs': (context) => const MyJobsScreen(),

        // ✅ FINAL SAFE HOME ROUTE (NO CRASH EVER)
        '/home': (context) {
          final route = ModalRoute.of(context);
          final args = route?.settings.arguments;

          return CustomerNavBar(
            initialIndex: (args is Map && args["index"] != null)
                ? args["index"]
                : 0,
          );
        },

        '/workerHome': (context) => const WorkerNavBar(),

        '/createJob': (context) => const CreateJobScreen(),
      },
    );
  }
}
