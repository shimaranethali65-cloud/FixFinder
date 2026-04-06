import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkerAssignedJobsScreen extends StatefulWidget {
  const WorkerAssignedJobsScreen({super.key});

  @override
  State<WorkerAssignedJobsScreen> createState() =>
      _WorkerAssignedJobsScreenState();
}

class _WorkerAssignedJobsScreenState
    extends State<WorkerAssignedJobsScreen> {

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text("Assigned Jobs"),
        centerTitle: true,
      ),

      body: user == null
          ? const Center(child: Text("User not logged in"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('jobs')
                  .where('assignedTo', isEqualTo: user!.uid)
                  .where('status', whereIn: ['assigned', 'completed']) // ✅ FIX
                  .snapshots(),

              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No assigned jobs yet"),
                  );
                }

                final jobs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {

                    final job =
                        jobs[index].data() as Map<String, dynamic>;

                    final jobId = jobs[index].id;
                    final status = job['status'] ?? 'assigned';

                    /// 🔍 DEBUG (remove later if needed)
                    print("Worker UID: ${user!.uid}");
                    print("AssignedTo: ${job['assignedTo']}");

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          /// 🔹 CATEGORY
                          Text(
                            job['category'] ?? "No category",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// 🔹 LOCATION
                          Text(
                            job['location'] ?? "",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// 🔹 DESCRIPTION
                          Text(
                            job['description'] ?? "",
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// 🔹 PRICE
                          Text(
                            "💰 Price: \$${job['assignedPrice'] ?? "0"}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 14),

                          /// 🔹 BUTTON / STATUS
                          SizedBox(
                            width: double.infinity,
                            child: status == 'completed'
                                ? Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "✅ Already Completed",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () async {

                                      final confirm =
                                          await showDialog<bool>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Complete Job"),
                                            content: const Text(
                                                "Mark this job as completed?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        context,
                                                        false),
                                                child: const Text(
                                                    "Cancel"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        context,
                                                        true),
                                                child: const Text(
                                                    "Yes"),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (!mounted) return;
                                      if (confirm != true) return;

                                      await FirebaseFirestore.instance
                                          .collection('jobs')
                                          .doc(jobId)
                                          .update({
                                        'status': 'completed',
                                      });

                                      if (!mounted) return;

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Job completed successfully"),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      "Mark as Completed",
                                      style: TextStyle(
                                          color: Colors.white),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}