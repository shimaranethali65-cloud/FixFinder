import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'viewbidsscreen.dart';
import 'ratingscreen.dart';

class JobDetailsScreen extends StatelessWidget {
  final String jobId;
  final String workerUID; // Ensure this is exactly 'workerUID'
  final String category;
  final String description;
  final String location;

  const JobDetailsScreen({
    super.key,
    required this.jobId,
    required this.workerUID, // <--- Error 1: This must be inside these { }
    required this.category,
    required this.description,
    required this.location,
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 30),

                // 🖼️ IMAGE
                Center(
                  child: Image.asset(
                    "assets/images/postsuccesful.png",
                    height: 180,
                  ),
                ),

                const SizedBox(height: 60),

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

                          // View Bids
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewBidsScreen(jobId: jobId),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
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

      // ✅ FIXED: PROPER PLACE
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RatingScreen(
                    workerId: workerUID, // Use the variable we defined above
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Mark as Completed",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
