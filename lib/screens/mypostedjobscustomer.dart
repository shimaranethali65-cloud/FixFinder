import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'jobdetailsscreen.dart';

class MyPostedJobsScreen extends StatelessWidget {
  const MyPostedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "My Posted Jobs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
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
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No jobs posted yet"),
                  );
                }

                final jobs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job =
                        jobs[index].data() as Map<String, dynamic>;

                    final jobId = jobs[index].id;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// 🔹 TOP ROW (TITLE + BUTTONS)
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              /// LEFT TEXT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [

                                    /// CATEGORY
                                    Text(
                                      job['category'] ??
                                          "No category",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    /// LOCATION
                                    Text(
                                      job['location'] ?? "",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// RIGHT BUTTONS (HORIZONTAL)
                              Row(
                                children: [

                                  /// 🔵 VIEW
                                  SizedBox(
                                    height: 32,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                JobDetailsScreen(
                                                    jobData: job),
                                          ),
                                        );
                                      },
                                      style:
                                          ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.blue,
                                             foregroundColor: Colors.white,
                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal: 12),
                                        shape:
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        "View",
                                        style: TextStyle(
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  /// 🔴 DELETE
                                  SizedBox(
                                    height: 32,
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        final confirm =
                                            await showDialog<
                                                bool>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Delete Job"),
                                              content: const Text(
                                                  "Are you sure you want to delete this job?"),
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
                                                  style:
                                                      ElevatedButton
                                                          .styleFrom(
                                                    backgroundColor:
                                                        Colors.red,
                                                  ),
                                                  child: const Text(
                                                      "Delete"),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (confirm != true)
                                          return;

                                        await FirebaseFirestore
                                            .instance
                                            .collection('jobs')
                                            .doc(jobId)
                                            .delete();
                                      },
                                      style:
                                          OutlinedButton.styleFrom(
                                        foregroundColor:
                                            Colors.red,
                                        side: const BorderSide(
                                            color: Colors.red),
                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal: 12),
                                        shape:
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// 🔹 DESCRIPTION
                          Text(
                            job['description'] ??
                                "No description",
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
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