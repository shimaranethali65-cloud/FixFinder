import 'package:flutter/material.dart';

class HomeScreenWorker extends StatelessWidget {
  const HomeScreenWorker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello, Worker 👋"),
        leading: const Icon(Icons.arrow_back),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Row(
              children: const [
                Icon(Icons.handyman),
                SizedBox(width: 10),
                Text(
                  "Nearby Jobs",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),

            const SizedBox(height: 20),

            jobCard("Fix leaking pipe"),
            jobCard("Repair broken water pipe"),
            jobCard("Fix pipe joint leak"),
            jobCard("Fix leaking shower"),
            jobCard("Repair toilet flush"),
          ],
        ),
      ),
    );
  }

  Widget jobCard(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(title),

          ElevatedButton(
            onPressed: () {
              print("$title clicked");
            },
            child: const Text("View"),
          )
        ],
      ),
    );
  }
}
