import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'viewjobdetailsscreen.dart';

class HomeScreenWorker extends StatelessWidget {
  const HomeScreenWorker({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/login');
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FB),

        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('jobs')
                .where('status', isEqualTo: 'waiting')
                .orderBy('createdAt', descending: true)
                .snapshots(),

            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Error loading jobs"));
              }

              final jobs = snapshot.data!.docs;

              if (jobs.isEmpty) {
                return const Center(child: Text("No jobs available"));
              }

              /// ✅ FULL SCROLL FIX USING ListView ONLY
              return ListView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                children: [

                  /// 🔙 HEADER
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Text(
                        "Hello, Worker 👋",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// 🔧 TITLE (IMPROVED)
                  const Text(
                    "🔧 Nearby Jobs",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 81, 82, 82),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔥 JOB LIST
                  ...jobs.map((job) {
                    final category = job['category'] ?? '';
                    final description = job['description'] ?? '';
                    final jobId = job['jobId'];

                    return _jobCard(
                      context,
                      category,
                      description,
                      jobId,
                    );
                  }).toList(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// ✨ JOB CARD
  Widget _jobCard(
    BuildContext context,
    String category,
    String description,
    String jobId,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ICON
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.work, color: Colors.blue),
          ),

          const SizedBox(width: 12),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// VIEW BUTTON (FIXED)
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewJobDetailsScreen(
                    jobId: jobId,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "View",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}