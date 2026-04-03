import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'viewbidsscreen.dart';

class JobDetailsScreen extends StatelessWidget {
  final String category;
  final String description;
  final String location;
  final String jobId; // ✅ NEW

  const JobDetailsScreen({
    super.key,
    required this.category,
    required this.description,
    required this.location,
    required this.jobId, // ✅ NEW
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [

                // 🔙 HEADER
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Text(
                      "Job Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ✅ SUCCESS TEXT
                const Text(
                  "Post Successful !",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 40),

                // 🖼️ IMAGE
                Center(
                  child: Image.asset(
                    "assets/images/postsuccesful.png",
                    height: 200,
                  ),
                ),

                const SizedBox(height: 80),

                // 📦 DETAILS BOX
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("Category : $category"),
                      const SizedBox(height: 8),

                      Text("Location : $location"),
                      const SizedBox(height: 8),

                      Text("Description : $description"),
                      const SizedBox(height: 8),

                      const Text("Status : Waiting for bids"),

                      const SizedBox(height: 20),

                      Row(
                        children: [

                          // Cancel
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // ✅ VIEW BIDS WITH JOB ID
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewBidsScreen(
                                          jobId: jobId, // ✅ PASS HERE
                                        ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.primaryBlue,
                              ),
                              child: const Text(
                                "View Bids",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}