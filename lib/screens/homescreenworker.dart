import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Worker Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreenWorker(),
    );
  }
}

class HomeScreenWorker extends StatelessWidget {
  const HomeScreenWorker({super.key});

  // ✅ YOUR SAMPLE DATA (kept)
  final List<Map<String, String>> customerPosts = const [
    {"title": "Fix leaking pipe", "customer": "John Doe"},
    {"title": "Repair broken water pipe", "customer": "Alice Smith"},
    {"title": "Fix pipe joint leak", "customer": "Bob Johnson"},
    {"title": "Fix leaking shower", "customer": "Mary Jane"},
    {"title": "Repair toilet flush", "customer": "Peter Parker"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Worker Home"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "Nearby Jobs",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('jobs')
                    .snapshots(),
                builder: (context, snapshot) {

                  // 🔥 If Firebase loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 🔥 If Firebase has data → use it
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    final jobs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        var job = jobs[index];

                        String title = job['title'];
                        String customer = job['customer'];

                        return jobCard(context, title, customer);
                      },
                    );
                  }

                  // 🔥 If NO Firebase data → use SAMPLE DATA
                  return ListView.builder(
                    itemCount: customerPosts.length,
                    itemBuilder: (context, index) {
                      final post = customerPosts[index];
                      return jobCard(
                          context, post["title"]!, post["customer"]!);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget jobCard(BuildContext context, String title, String customer) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold), // ✅ bold
        ),

        subtitle: Text("Customer: $customer"),

        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue, // ✅ light blue
          ),

          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobDetailsScreen(
                  jobTitle: title,
                  customerName: customer,
                ),
              ),
            );
          },

          child: const Text("View"),
        ),
      ),
    );
  }
}

// 🔥 Login Screen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Screen")),
      body: const Center(
        child: Text("This is the login screen"),
      ),
    );
  }
}

// 🔥 Job Details Screen
class JobDetailsScreen extends StatelessWidget {
  final String jobTitle;
  final String customerName;

  const JobDetailsScreen({
    super.key,
    required this.jobTitle,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Job Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jobTitle,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Customer: $customerName"),
          ],
        ),
      ),
    );
  }
}