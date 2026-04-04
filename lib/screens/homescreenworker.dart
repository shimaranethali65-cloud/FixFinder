import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Worker Home',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreenWorker(),
    );
  }
}

class HomeScreenWorker extends StatelessWidget {
  const HomeScreenWorker({super.key});

  // Sample customer posts
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
            // Simulate going back to login (replace with real login later)
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: customerPosts.length,
                itemBuilder: (context, index) {
                  final post = customerPosts[index];
                  return jobCard(context, post["title"]!, post["customer"]!);
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Customer: $customer"),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue, // Light blue button
          ),
          onPressed: () {
            // Open job details
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

// Dummy login screen for back button
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

// Job details screen
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jobTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Customer: $customerName"),
            const SizedBox(height: 20),
            const Text(
              "Job Description:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("Here you can add detailed job description..."),
          ],
        ),
      ),
    );
  }
}
