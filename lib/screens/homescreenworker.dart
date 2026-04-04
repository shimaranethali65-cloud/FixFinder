import 'package:flutter/material.dart';

// Example: Sample customer posts
class HomeScreenWorker extends StatelessWidget {
  const HomeScreenWorker({super.key});

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
            Navigator.pushReplacementNamed(context, '/login');
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
          style: const TextStyle(fontWeight: FontWeight.bold), // bold
        ),
        subtitle: Text("Customer: $customer"),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/jobDetails',
              arguments: {"title": title, "customer": customer},
            );
          },
          child: const Text("View"),
        ),
      ),
    );
  }
}

// Job Details Screen (can create separate file if you want)
class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final title = args["title"];
    final customer = args["customer"];

    return Scaffold(
      appBar: AppBar(title: const Text("Job Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Customer: $customer"),
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
