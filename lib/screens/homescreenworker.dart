import 'package:flutter/material.dart';

class HomeScreenWorker extends StatelessWidget {
  const HomeScreenWorker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Worker Home")),
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
              child: ListView(
                children: [
                  jobCard("Fix leaking pipe"),
                  jobCard("Repair broken water pipe"),
                  jobCard("Fix pipe joint leak"),
                  jobCard("Fix leaking shower"),
                  jobCard("Repair toilet flush"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget jobCard(String title) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title),
        trailing: ElevatedButton(
          onPressed: () {
            print("$title clicked");
          },
          child: const Text("View"),
        ),
      ),
    );
  }
}
