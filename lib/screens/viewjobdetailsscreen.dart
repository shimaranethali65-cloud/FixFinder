import 'package:fixfinder/screens/submitbidscreen.dart';
import 'package:flutter/material.dart';

class JobDetailsPage extends StatelessWidget {
  const JobDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Job Details",
          style: TextStyle(color: Colors.black),
        ),
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildItem(Icons.lightbulb_outline, "Title", "Fix leaking pipes"),
            buildItem(Icons.category_outlined, "Category", "plumber"),
            buildItem(Icons.location_on_outlined, "Location", "Fetched user address"),
            buildItem(Icons.description_outlined, "Description",
                "Pipe leaking under kitchen sink"),
            buildItem(Icons.person_outline, "Posted By", "John D"),

            const SizedBox(height: 25),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SubmitBidPage()),
                  );
                },
                child: const Text("Place Bid"),
              ),
            ),

            const SizedBox(height: 25),

            Center(
              child: Image.network(
                "https://cdn-icons-png.flaticon.com/512/1995/1995574.png",
                height: 140,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Text(
            "$title : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}