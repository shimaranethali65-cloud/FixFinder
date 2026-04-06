import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_colors.dart';
import 'viewbidsscreen.dart';

class JobDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> jobData;

  const JobDetailsScreen({
    super.key,
    required this.jobData,
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {

  @override
  Widget build(BuildContext context) {

    // ✅ SAFE DATA EXTRACTION
    final category = widget.jobData['category'] ?? "N/A";
    final description = widget.jobData['description'] ?? "N/A";
    final location = widget.jobData['location'] ?? "N/A";
    final jobId = widget.jobData['jobId'] ?? "";
    final status = widget.jobData['status'] ?? "waiting";
    final postedBy = widget.jobData['postedBy'] ?? "User";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                /// 🔙 HEADER
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

                /// SUCCESS TEXT
                const Text(
                  "Post Successful!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 30),

                /// IMAGE
                Center(
                  child: Image.asset(
                    "assets/images/postsuccesful.png",
                    height: 180,
                  ),
                ),

                const SizedBox(height: 40),

                /// DETAILS BOX
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

                      Text("Posted By : $postedBy"),
                      const SizedBox(height: 8),

                      Text("Location : $location"),
                      const SizedBox(height: 8),

                      Text("Description : $description"),
                      const SizedBox(height: 8),

                      Text(
                        "Status : ${status == 'completed' ? 'Completed' : 'Waiting for bids'}",
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (jobId.isEmpty) return;

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

      /// MARK AS COMPLETED BUTTON
      bottomNavigationBar: jobId.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {

                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Complete Job"),
                          content: const Text(
                            "Are you sure you want to mark this job as completed?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text(
                                "Yes",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    // ✅ FIX 1
                    if (!mounted) return;

                    if (confirm != true) return;

                    try {
                      await FirebaseFirestore.instance
                          .collection('jobs')
                          .doc(jobId)
                          .update({
                        'status': 'completed',
                        'completedAt': Timestamp.now(),
                      });

                      // ✅ FIX 2
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Job marked as completed"),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.pop(context);

                    } catch (e) {
                      // ✅ FIX 3
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
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