import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'jobdetailsscreen.dart';
import 'customernavbar.dart';

class MyPostedJobsScreen extends StatelessWidget {
  const MyPostedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    print("Current User UID: ${user?.uid}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Posted Jobs"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const CustomerNavBar(initialIndex: 0),
              ),
            );
          },
        ),
      ),
      body: user == null
          ? const Center(child: Text("User not logged in"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('jobs')
                  .where('postedById', isEqualTo: user.uid)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print("Firestore Error: ${snapshot.error}");
                  return const Center(child: Text("Something went wrong"));
                }

                final jobs = snapshot.data?.docs ?? [];
                print("Jobs count: ${jobs.length}");

                if (jobs.isEmpty) {
                  return const Center(
                    child: Text("No jobs posted yet"),
                  );
                }

                return ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    final data = job.data() as Map<String, dynamic>;

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔹 CATEGORY
                            Text(
                              data['category'] ?? "No category",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // 🔹 DESCRIPTION
                            Text(
                              data['description'] ?? "",
                              style: const TextStyle(fontSize: 14),
                            ),

                            const SizedBox(height: 6),

                            // 🔹 LOCATION
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    data['location'] ?? "",
                                    style: const TextStyle(
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // 🔥 UPDATED BUTTONS (SMALL + RIGHT SIDE)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // 🔵 VIEW
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => JobDetailsScreen(
                                          jobId: job.id,
                                          category: data['category'],
                                          description: data['description'],
                                          location: data['location'],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.visibility, size: 18),
                                  label: const Text("View"),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // 🔴 DELETE
                                TextButton.icon(
                                  onPressed: () async {
                                    final confirm = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Delete Job"),
                                        content: const Text(
                                            "Are you sure you want to delete this job?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text("Delete"),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      await FirebaseFirestore.instance
                                          .collection('jobs')
                                          .doc(job.id)
                                          .delete();
                                    }
                                  },
                                  icon: const Icon(Icons.delete, size: 18),
                                  label: const Text("Delete"),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}